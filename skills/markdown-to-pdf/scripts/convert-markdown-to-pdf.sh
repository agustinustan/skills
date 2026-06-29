#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${MARKDOWN_TO_PDF_IMAGE:-markdown-to-pdf:local}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
  cat <<'USAGE'
Usage: convert-markdown-to-pdf.sh [options] <source.md>

Options:
  --output <file.pdf>     Desired PDF path. Existing files are never overwritten.
  --title <text>          Metadata override.
  --subtitle <text>       Metadata override.
  --author <text>         Metadata override.
  --date <YYYY-MM-DD>     Metadata override.
  --subject <text>        Metadata override.
  --keywords <text>       Metadata override.
  --theme <name>          professional, default, modern, or minimal.
  --image <name>          Docker image name. Default: markdown-to-pdf:local.
  --build-image           Build the local image before conversion.
  --help                  Show this help.
USAGE
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

info() {
  printf '%s\n' "$*"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "$1 is required but was not found"
}

abs_path() {
  local path="$1"
  local dir base
  dir="$(cd "$(dirname "$path")" && pwd)"
  base="$(basename "$path")"
  printf '%s/%s\n' "$dir" "$base"
}

slug_title() {
  local name="$1"
  name="${name%.*}"
  name="${name//_/ }"
  name="${name//-/ }"
  printf '%s\n' "$name" | awk '{ for (i=1; i<=NF; i++) { $i=toupper(substr($i,1,1)) substr($i,2) } print }'
}

unique_output_path() {
  local desired="$1"
  if [[ ! -e "$desired" ]]; then
    printf '%s\n' "$desired"
    return 0
  fi

  local dir base ext stem candidate i
  dir="$(dirname "$desired")"
  base="$(basename "$desired")"
  ext=".pdf"
  stem="${base%.pdf}"
  i=1
  while :; do
    candidate="$dir/$stem-$i$ext"
    if [[ ! -e "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
    i=$((i + 1))
  done
}

extract_frontmatter_value() {
  local file="$1"
  local key="$2"
  awk -v key="$key" '
    BEGIN { in_fm=0; seen_start=0 }
    NR == 1 && $0 == "---" { in_fm=1; seen_start=1; next }
    seen_start && in_fm && $0 == "---" { exit }
    in_fm && $0 ~ "^" key ":" {
      sub("^[^:]+:[[:space:]]*", "")
      gsub(/^["'\'']|["'\'']$/, "")
      print
      exit
    }
  ' "$file"
}

validate_local_assets() {
  local source="$1"
  python3 - "$source" <<'PY'
from pathlib import Path
from urllib.parse import unquote
import re
import sys

source = Path(sys.argv[1])
root = source.parent
text = source.read_text(encoding="utf-8")

remote = []
missing = []

patterns = [
    re.compile(r'!\[[^\]]*\]\(([^)\s]+)(?:\s+"[^"]*")?\)'),
    re.compile(r'<img\b[^>]*\bsrc=["\']([^"\']+)["\']', re.I),
]

for pattern in patterns:
    for match in pattern.finditer(text):
        ref = match.group(1).strip()
        if ref.startswith(("http://", "https://")):
            remote.append(ref)
            continue
        if ref.startswith(("#", "data:", "mailto:")):
            continue
        ref = ref.split("#", 1)[0]
        if not ref:
            continue
        candidate = (root / unquote(ref)).resolve()
        try:
            candidate.relative_to(root.resolve())
        except ValueError:
            missing.append(ref)
            continue
        if not candidate.exists():
            missing.append(ref)

if remote:
    print("remote asset references are not supported in v1: " + ", ".join(remote), file=sys.stderr)
    sys.exit(20)
if missing:
    print("missing local asset(s): " + ", ".join(missing), file=sys.stderr)
    sys.exit(21)
PY
}

validate_math_balance() {
  local source="$1"
  python3 - "$source" <<'PY'
from pathlib import Path
import re
import sys

text = Path(sys.argv[1]).read_text(encoding="utf-8")
text = re.sub(r'```.*?```', '', text, flags=re.S)
display = text.count('$$')
single = len(re.findall(r'(?<!\\)\$(?!\$)', text))
if display % 2 or single % 2:
    print("invalid LaTeX math delimiter balance", file=sys.stderr)
    sys.exit(22)
PY
}

SOURCE=""
OUTPUT=""
BUILD_IMAGE=0
declare -a METADATA_ARGS=()
THEME="professional"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)
      [[ $# -ge 2 ]] || die "--output requires a value"
      OUTPUT="$2"
      shift 2
      ;;
    --title|--subtitle|--author|--date|--subject|--keywords)
      [[ $# -ge 2 ]] || die "$1 requires a value"
      case "$1" in
        --title) TITLE="$2" ;;
        --subtitle) SUBTITLE="$2" ;;
        --author) AUTHOR="$2" ;;
        --date) DATE="$2" ;;
        --subject) SUBJECT="$2" ;;
        --keywords) KEYWORDS="$2" ;;
      esac
      METADATA_ARGS+=("--metadata" "${1#--}=$2")
      shift 2
      ;;
    --theme)
      [[ $# -ge 2 ]] || die "--theme requires a value"
      THEME="$2"
      shift 2
      ;;
    --image)
      [[ $# -ge 2 ]] || die "--image requires a value"
      IMAGE_NAME="$2"
      shift 2
      ;;
    --build-image)
      BUILD_IMAGE=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    --*)
      die "unknown option: $1"
      ;;
    *)
      if [[ -n "$SOURCE" ]]; then
        die "exactly one Markdown source file is supported per invocation"
      fi
      SOURCE="$1"
      shift
      ;;
  esac
done

[[ -n "$SOURCE" ]] || die "source Markdown file is required"
[[ "$SOURCE" == *.md || "$SOURCE" == *.markdown ]] || die "source must be a Markdown file"
[[ -f "$SOURCE" ]] || die "source file not found: $SOURCE"
[[ -r "$SOURCE" ]] || die "source file is not readable: $SOURCE"
[[ -s "$SOURCE" ]] || die "source file is empty: $SOURCE"

require_cmd docker
require_cmd python3

SOURCE_ABS="$(abs_path "$SOURCE")"
SOURCE_DIR="$(dirname "$SOURCE_ABS")"
SOURCE_BASE="$(basename "$SOURCE_ABS")"

validate_local_assets "$SOURCE_ABS"
validate_math_balance "$SOURCE_ABS"

if [[ -z "$OUTPUT" ]]; then
  OUTPUT="${SOURCE_ABS%.*}.pdf"
fi
OUTPUT_ABS="$(abs_path "$OUTPUT")"
OUTPUT_DIR="$(dirname "$OUTPUT_ABS")"
[[ -d "$OUTPUT_DIR" ]] || die "output directory does not exist: $OUTPUT_DIR"
[[ -w "$OUTPUT_DIR" ]] || die "output directory is not writable: $OUTPUT_DIR"
FINAL_OUTPUT="$(unique_output_path "$OUTPUT_ABS")"
FINAL_BASE="$(basename "$FINAL_OUTPUT")"

if [[ $BUILD_IMAGE -eq 1 ]]; then
  info "Building image $IMAGE_NAME from $SKILL_DIR"
  docker build -t "$IMAGE_NAME" "$SKILL_DIR"
elif ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
  die "Docker image $IMAGE_NAME not found. Build it with: docker build -t $IMAGE_NAME $SKILL_DIR"
fi

TITLE="${TITLE:-$(extract_frontmatter_value "$SOURCE_ABS" title)}"
SUBTITLE_VALUE="${SUBTITLE:-$(extract_frontmatter_value "$SOURCE_ABS" subtitle)}"
AUTHOR="${AUTHOR:-$(extract_frontmatter_value "$SOURCE_ABS" author)}"
DATE_VALUE="${DATE:-$(extract_frontmatter_value "$SOURCE_ABS" date)}"
SUBJECT_VALUE="${SUBJECT:-$(extract_frontmatter_value "$SOURCE_ABS" subject)}"
KEYWORDS_VALUE="${KEYWORDS:-$(extract_frontmatter_value "$SOURCE_ABS" keywords)}"

if [[ -z "$TITLE" ]]; then
  TITLE="$(slug_title "$SOURCE_BASE")"
  METADATA_ARGS+=("--metadata" "title=$TITLE")
fi
if [[ -z "$DATE_VALUE" ]]; then
  DATE_VALUE="$(date +%F)"
  METADATA_ARGS+=("--metadata" "date=$DATE_VALUE")
fi

info "Resolved metadata:"
info "  title: ${TITLE:-frontmatter}"
info "  subtitle: ${SUBTITLE_VALUE:-not set}"
info "  author: ${AUTHOR:-not set}"
info "  date: ${DATE_VALUE:-frontmatter}"
info "  subject: ${SUBJECT_VALUE:-not set}"
info "  keywords: ${KEYWORDS_VALUE:-not set}"

docker run --rm \
	  --entrypoint "" \
	  --user "$(id -u):$(id -g)" \
	  -e HOME=/tmp \
	  -v "$SOURCE_DIR:/data:ro" \
  -v "$OUTPUT_DIR:/out" \
	  "$IMAGE_NAME" \
	  bash -c '
	    set -eu
	    python3 /usr/local/bin/render-mermaid.py "/data/$1" /tmp/source.md
	    pandoc /tmp/source.md \
	      --from markdown+yaml_metadata_block+tex_math_dollars \
	      --to html5 \
	      --standalone \
	      --embed-resources \
	      --resource-path=/data:/tmp \
	      --toc \
	      --toc-depth=3 \
	      --mathml \
	      --template=/opt/markdown-to-pdf/report.html \
	      --metadata "theme=$2" \
	      "${@:4}" \
      --output "/tmp/report.html"
    test -s /tmp/report.html
    if grep -q "<h[1-6]" "/tmp/report.html" || ! grep -q "^#" "/data/$1"; then
      node /usr/local/bin/render-pdf.mjs /tmp/report.html "/out/$3"
      test -s "/out/$3"
    else
      echo "major source sections did not render" >&2
      exit 30
    fi
  ' bash "$SOURCE_BASE" "$THEME" "$FINAL_BASE" "${METADATA_ARGS[@]}"

info "PDF created: $FINAL_OUTPUT"
