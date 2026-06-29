#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONVERTER="$SKILL_DIR/scripts/convert-markdown-to-pdf.sh"
IMAGE_NAME="${MARKDOWN_TO_PDF_IMAGE:-markdown-to-pdf:local}"
OUT_DIR="${MARKDOWN_TO_PDF_TEST_OUT:-/tmp/markdown-to-pdf-validation}"

pass() {
  printf 'PASS: %s\n' "$*"
}

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

expect_fail() {
  local label="$1"
  local expected="$2"
  shift 2
  local log="$OUT_DIR/$label.log"
  if "$@" >"$log" 2>&1; then
    fail "$label unexpectedly succeeded"
  fi
  if ! grep -qi "$expected" "$log"; then
    printf '%s\n' "---- $label output ----" >&2
    sed -n '1,120p' "$log" >&2
    fail "$label did not mention expected text: $expected"
  fi
  pass "$label"
}

mkdir -p "$OUT_DIR"
rm -f "$OUT_DIR"/*.pdf "$OUT_DIR"/*.log

command -v docker >/dev/null 2>&1 || fail "docker is required"
command -v python3 >/dev/null 2>&1 || fail "python3 is required"

docker build -t "$IMAGE_NAME" "$SKILL_DIR"
docker run --rm --entrypoint "" "$IMAGE_NAME" sh -c 'pandoc --version >/dev/null && chromium --version >/dev/null && node --version >/dev/null'
pass "renderer image builds and tools are available"

"$CONVERTER" --image "$IMAGE_NAME" "$SKILL_DIR/fixtures/success/report.md" --output "$OUT_DIR/report.pdf" >"$OUT_DIR/success.log" 2>&1
test -s "$OUT_DIR/report.pdf" || fail "success PDF was not created"
grep -q "PDF created:" "$OUT_DIR/success.log" || fail "success output did not report final path"
grep -q "title:" "$OUT_DIR/success.log" || fail "metadata resolution was not reported"
pass "success fixture generated PDF"

"$CONVERTER" --image "$IMAGE_NAME" "$SKILL_DIR/fixtures/success/report.md" --output "$OUT_DIR/report.pdf" >"$OUT_DIR/unique.log" 2>&1
test -s "$OUT_DIR/report-1.pdf" || fail "unique output filename was not generated"
grep -q "report-1.pdf" "$OUT_DIR/unique.log" || fail "unique output path was not reported"
pass "existing output path generates unique filename"

expect_fail "multiple-sources" "exactly one Markdown source" \
  "$CONVERTER" --image "$IMAGE_NAME" "$SKILL_DIR/fixtures/success/report.md" "$SKILL_DIR/fixtures/success/report-with-full-metadata.md"

expect_fail "missing-asset" "missing local asset" \
  "$CONVERTER" --image "$IMAGE_NAME" "$SKILL_DIR/fixtures/failure/missing-asset.md" --output "$OUT_DIR/missing-asset.pdf"

expect_fail "remote-asset" "remote asset" \
  "$CONVERTER" --image "$IMAGE_NAME" "$SKILL_DIR/fixtures/failure/remote-asset.md" --output "$OUT_DIR/remote-asset.pdf"

expect_fail "invalid-math" "invalid LaTeX math" \
  "$CONVERTER" --image "$IMAGE_NAME" "$SKILL_DIR/fixtures/failure/invalid-math.md" --output "$OUT_DIR/invalid-math.pdf"

expect_fail "invalid-mermaid" "mermaid" \
  "$CONVERTER" --image "$IMAGE_NAME" "$SKILL_DIR/fixtures/failure/invalid-mermaid.md" --output "$OUT_DIR/invalid-mermaid.pdf"

"$CONVERTER" --image "$IMAGE_NAME" "$SKILL_DIR/fixtures/success/report-with-full-metadata.md" --output "$OUT_DIR/full-metadata.pdf" >"$OUT_DIR/full-metadata.log" 2>&1
test -s "$OUT_DIR/full-metadata.pdf" || fail "full metadata PDF was not created"

"$CONVERTER" --image "$IMAGE_NAME" "$SKILL_DIR/fixtures/success/report-with-fallback-metadata.md" --output "$OUT_DIR/fallback-metadata.pdf" >"$OUT_DIR/fallback-metadata.log" 2>&1
test -s "$OUT_DIR/fallback-metadata.pdf" || fail "fallback metadata PDF was not created"
grep -q "Fallback Metadata" "$OUT_DIR/fallback-metadata.log" || fail "fallback title was not reported"
pass "professional default fixtures generated PDFs"

pass "markdown-to-pdf validation complete"
