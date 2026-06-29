---
name: markdown-to-pdf
description: Convert markdown files to professional PDF documents with metadata, table of contents, LaTeX math, Mermaid diagrams, and long tables. Use when generating shareable PDF reports from markdown.
---

# Markdown to PDF

Convert exactly one Markdown report into one professional PDF using this local workflow:

```text
Markdown -> Pandoc -> HTML -> Playwright Chromium -> PDF
```

Use the repository-local package at `skills/markdown-to-pdf/`. The renderer image is built from `skills/markdown-to-pdf/Dockerfile` and defaults to:

```text
markdown-to-pdf:local
```

## Invocation

Default:

```bash
skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh path/to/report.md
```

Explicit output:

```bash
skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh path/to/report.md --output path/to/report.pdf
```

Build the local image during conversion:

```bash
skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh --build-image path/to/report.md
```

Only one Markdown source file is supported per invocation. Do not pass multiple Markdown files or a folder.

## Inputs and Outputs

- Input: one readable, non-empty `.md` or `.markdown` file.
- Output: one PDF file.
- Default output path: the source filename with `.pdf`.
- Existing output path: never overwritten; the skill generates a unique filename such as `report-1.pdf` and reports the actual final path.
- Assets: local relative image references only, resolved from the source file directory.
- Remote HTTP/HTTPS assets: unsupported in v1 and must fail with an actionable message.

## Metadata

Metadata is resolved before conversion and reported to the user.

Supported metadata:

- `title`
- `subtitle`
- `author`
- `date`
- `subject`
- `keywords`

Resolution order:

1. CLI option, such as `--title "Quarterly Report"`.
2. YAML frontmatter in the Markdown source.
3. Sensible fallback where available, such as title from filename and date from the current day.

## Professional Defaults

The default theme is `professional`. The generated PDF should include:

- readable typography
- print margins suitable for A4
- table of contents for headed documents
- visible document metadata
- rendered LaTeX math
- rendered Mermaid diagrams
- readable page breaks for long tables
- local images and supported relative assets

Optional style values:

```bash
--theme professional
--theme default
--theme modern
--theme minimal
```

## Validation

Run the full validation script from the repository root:

```bash
skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh
```

The validation builds the Docker image, checks required tools, converts success fixtures, verifies unique output naming, and confirms failure fixtures produce actionable diagnostics.

Fixture locations:

```text
skills/markdown-to-pdf/fixtures/success/
skills/markdown-to-pdf/fixtures/failure/
```

## Failure Policy

Do not produce a degraded PDF when important content cannot render. Conversion must fail when:

- the source file is missing, empty, or unreadable
- more than one source file is provided
- a local relative asset is missing
- a remote HTTP/HTTPS asset is referenced
- LaTeX math delimiters are invalid
- Mermaid rendering fails
- major source sections do not appear in the rendered HTML
- the output directory is missing or unwritable
- the container image or required rendering tools are unavailable

Normal diagnostics must be concise and must not expose secrets, environment dumps, or unrelated command output.

## Troubleshooting

- **Image missing**: Build it with `docker build -t markdown-to-pdf:local skills/markdown-to-pdf`.
- **Remote image rejected**: Download the asset into the document folder and reference it with a local relative path.
- **Missing local asset**: Fix the Markdown reference relative to the source file directory.
- **Math fails**: Check that `$...$` and `$$...$$` delimiters are balanced and valid.
- **Mermaid fails**: Validate the diagram syntax in the source Markdown.
- **Output path exists**: Read the reported final path; the existing file was preserved.
