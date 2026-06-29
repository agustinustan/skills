---
name: markdown-to-pdf
description: Convert markdown files to professional PDF documents with metadata, table of contents, LaTeX math, Mermaid diagrams, and long tables. Use when generating shareable PDF reports from markdown.
---

# Markdown to Professional PDF

Convert Markdown documents into professional PDFs using Pandoc with XeLaTeX, Mermaid diagram support, customizable themes, cover pages, and automatic table of contents.

## Input Variables

The skill expects the following variables to be provided by the user:

- `{{input-file}}` — markdown filename without `.md` extension.
- `{{version}}` — document version (e.g. `v1.0`, `v1.1`, or `draft`).
- `{{title}}` — document title.
- `{{subtitle}}` — document subtitle.
- `{{date}}` — document date.

The markdown file is located at:

```
workspace/{{input-file}}.md
```

## Configuration

Before conversion, check for a configuration file at the project root:

```
pdf-config.yaml
```

**If the file does not exist**, generate it with default values (see below).

**If the file exists**, read and apply its settings.

### Configuration File Format

```yaml
theme: professional          # default | professional | modern | minimal
cover: standard              # none | compact | standard | corporate
margin:
  top: 2.5cm
  bottom: 2.5cm
  left: 2.5cm
  right: 2.5cm
page_numbers: true
header:
  left: ""
  center: ""
  right: ""
footer:
  left: ""
  center: ""
  right: ""
logo_path: ""
code_highlight: tango
```

### Theme Presets

| Theme | Color | Vibe | Best For |
|-------|-------|------|----------|
| `default` | Black monochrome | Clean, no color | Internal documents |
| `professional` | Navy blue `#1A5276` | Corporate, trustworthy | Formal reports, proposals |
| `modern` | Teal green `#16A085` | Fresh, energetic | Tech docs, product specs |
| `minimal` | Dark gray `#2C3E50` | Understated, elegant | Academic, technical |

### Cover Presets

| Cover | Description |
|-------|-------------|
| `none` | No cover page — uses standard `\maketitle` |
| `compact` | Title + subtitle + date, no separate page |
| `standard` | Full title page with decorative rules |
| `corporate` | Colored header block, logo placeholder, metadata table |

### Header / Footer

- `header.*` and `footer.*` accept plain text. Leave empty to disable.
- If `page_numbers: true` and `footer.center` is empty, page numbers appear centered.
- Common patterns:
  - `header.right: "DRAFT"` — watermark-like status
  - `header.left: "$title$"` — document title in header
  - `footer.center: "Page X of Y"` — custom page numbering (use `Page \thepage`)

### Logo

- `logo_path` is relative to the markdown file (e.g. `assets/logo.png`).
- Leave empty to show a placeholder box on the corporate cover.

## Metadata Resolution

Resolve the following fields in order of priority:

| Field | Source |
|-------|--------|
| `title` | document title |
| `subtitle` | document subtitle |
| `date` | document date |
| `version` | document version (e.g. `v1.0`, `v1.1`, `draft`) |
| `author` | document author (optional) |

### Resolution Order

1. **YAML frontmatter** — inspect the markdown file. If a field exists in frontmatter (e.g. `title: "..."` in `---` block), use it. **Do NOT pass `--metadata` for that field** — Pandoc will read it from the file. Passing `--metadata` from CLI always overrides frontmatter.

2. **Ask user interactively** — for every field NOT found in frontmatter, ask the user one by one. Show the derived default as a suggestion. The user can accept (press Enter) or override.

   Example:
   ```
   Title [Application Overview Document]:
   Subtitle [Factoring Management System]: Ringkasan Teknis
   Date [2026-06-18]:
   Version [v1.0]: v1.1
   Author (optional) []: John Doe
   ```

3. **Derived default** — if the user accepts the default (presses Enter), use the derived value:
   - `title` — from markdown filename (replace `_` with space, title-case)
   - `subtitle` — from first meaningful sentence in the document, or leave empty
   - `date` — today's date (YYYY-MM-DD)
   - `version` — `v1.0`, or increment last version if previous PDF exists
   - `author` — leave empty unless provided

### Passing to Pandoc

After resolution, build the `--metadata` flags:

| Field | If from frontmatter | If from user/default |
|-------|-------------------|---------------------|
| title | ❌ skip | `--metadata title="..."` |
| subtitle | ❌ skip | `--metadata subtitle="..."` |
| date | ❌ skip | `--metadata date="..."` |
| version | ❌ skip | `--metadata version="..."` |
| author | ❌ skip | `--metadata author="..."` |

Before converting, report a table showing the resolved value and its source for each field.

## Setup (First Time)

Build the Docker image once before first use:

```bash
docker build -t pandoc-mermaid:latest /home/agustinus/workspace/markdown-conversion/.pi/skills/markdown-to-pdf/
```

Validate the image can run all required tools:

```bash
docker run --rm --entrypoint "" pandoc-mermaid:latest sh -c 'pandoc --version && xelatex --version && mmdc --version'
```

## Conversion

Once metadata is resolved and config is ready, run the conversion.

### Step 1: Map Config to Pandoc Variables

Read `pdf-config.yaml` at the project root and derive these Pandoc variables:

| Config Key | Pandoc `-V` Flag |
|------------|-----------------|
| `theme: professional` | `-V theme=professional -V theme_professional=true` |
| `theme: modern` | `-V theme=modern -V theme_modern=true` |
| `theme: minimal` | `-V theme=minimal -V theme_minimal=true` |
| `theme: default` | `-V theme=default -V theme_default=true` |
| `cover: standard` | `-V cover_standard=true` |
| `cover: compact` | `-V cover_compact=true` |
| `cover: corporate` | `-V cover_corporate=true` |
| `cover: none` | *(do not pass any cover flag)* |
| `margin: top/bottom/left/right` | `-V geometry:top=Xcm -V geometry:bottom=...` |
| `page_numbers: true/false` | `-V page_numbers=true` or omit |
| `header.left: "text"` | `-V header_left=text` |
| `header.center: "text"` | `-V header_center=text` |
| `header.right: "text"` | `-V header_right=text` |
| `footer.left: "text"` | `-V footer_left=text` |
| `footer.center: "text"` | `-V footer_center=text` |
| `footer.right: "text"` | `-V footer_right=text` |
| `logo_path: "path"` | `-V logo_path=path` |
| `code_highlight: style` | `--syntax-highlighting=style` (kosongkan untuk disable) |
| `--listings` | Enables wrapped code blocks so long snippets stay within the page margin |

### Step 2: Run Conversion

> **PENTING:** JANGAN copy-paste command di bawah mentah-mentah. Setiap `-V` flag WAJIB diambil dari `pdf-config.yaml` menggunakan mapping di Step 1. Command di bawah hanya template — semua nilai `{{...}}` harus diisi dari config yang sudah dibaca.

```bash
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$(pwd)/workspace:/data" \
  -v "$(pwd)/.pi/skills/markdown-to-pdf/template.latex:/data/template.latex" \
  pandoc-mermaid:latest \
  "/data/{{input-file}}.md" \
    --output "/data/{{input-file}}-{{version}}.pdf" \
    --template=/data/template.latex \
    --toc \
    --pdf-engine=xelatex \
    --filter mermaid-filter \
    --listings \
    --metadata title="{{title}}" \
    --metadata subtitle="{{subtitle}}" \
    --metadata date="{{date}}" \
    --metadata version="{{version}}" \
    {{# baca theme dari pdf-config.yaml, lalu tambahkan: }}
    -V theme={{theme}} \
    -V theme_{{theme}}=true \
    {{# baca cover dari pdf-config.yaml. Jika bukan "none", tambahkan: }}
    -V cover_{{cover}}=true \
    {{# baca margin dari pdf-config.yaml: }}
    -V "geometry:top={{margin.top}}" -V "geometry:bottom={{margin.bottom}}" \
    -V "geometry:left={{margin.left}}" -V "geometry:right={{margin.right}}" \
    {{# jika page_numbers: true, tambahkan: }}
    -V page_numbers=true \
    {{# untuk setiap header.* / footer.* yang tidak kosong, tambahkan -V: }}
    -V header_left="{{header.left}}" \
    -V footer_center="{{footer.center}}" \
    {{# jika logo_path tidak kosong, tambahkan: }}
    -V logo_path="{{logo_path}}" \
    {{# jika code_highlight tidak kosong, tambahkan: }}
    --syntax-highlighting={{code_highlight}}
```

> ⚠️ Hanya pass `-V` flag yang nilainya tidak kosong. Untuk `cover: none`, jangan pass `cover_*` apapun. Untuk `header.*` / `footer.*` yang kosong (string `""`), jangan pass flag-nya sama sekali.

This produces:

```
workspace/{{input-file}}-{{version}}.pdf
```

### Pandoc Flags Explained

| Flag | Purpose |
|------|---------|
| `--template=/data/template.latex` | Custom template with themes, covers, header/footer |
| `--toc` | Generates a table of contents with page numbers |
| `--pdf-engine=xelatex` | Uses XeLaTeX for Unicode and system font support |
| `--filter mermaid-filter` | Renders Mermaid diagrams via mermaid-cli |
| `--metadata` | Sets PDF metadata (title, subtitle, date) |
| `-V theme_*` | Selects color theme |
| `-V cover_*` | Selects cover page design |
| `-V geometry:*` | Sets page margins |
| `-V page_numbers` | Enables page numbering in footer |

## PDF Output Requirements

The generated PDF must have:

- A clear title, subtitle, version, and date on the first page or cover.
- A table of contents with page numbers (no bullet points).
- Properly rendered LaTeX math: inline `$...$`, display `$$...$$`, and fractions like `$\frac{a}{b}$`.
- Rendered Mermaid diagrams.
- Tables that continue across page breaks.
- Colored section headings and styled elements per the selected theme.
- Custom header/footer text if configured.
- Consistent color scheme across headings, rules, tables, and code blocks.

## Validation

After conversion, run a validation test with a sample markdown that exercises all features:

1. Create a test markdown file with:
   - Headings (for TOC)
   - LaTeX math: `$\frac{a}{b} = c$`
   - A Mermaid flowchart
   - A table long enough to span pages

2. Convert it to PDF with `--version=test`.

3. Verify the PDF was created successfully and is non-empty.

If the test passes, the skill is ready. If not, debug and fix issues before proceeding with the actual document.

## Troubleshooting

- **Mermaid diagrams not rendered:** Ensure `mermaid-filter` is installed correctly in the container. Check `docker run` output for mermaid-filter errors.
- **LaTeX math not rendering:** Verify `--pdf-engine=xelatex` is specified and the math syntax is valid LaTeX.
- **TOC without page numbers:** This is the default Pandoc behavior with `--toc`. XeLaTeX produces the TOC with page numbers by design.
- **Unicode characters missing:** XeLaTeX needs `fonts-freefont-ttf` installed (included in the Dockerfile).
- **Template not found:** Ensure the `-v` mount for `template.latex` is correct and the file exists.
- **fancyhdr/framed errors:** These packages are included in the base `pandoc/latex` image. If missing, add them to the Dockerfile.
- **Logo not showing on corporate cover:** Verify `logo_path` is relative to the markdown file and the file exists in the mounted volume.
