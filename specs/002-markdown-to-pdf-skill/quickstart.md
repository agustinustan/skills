# Quickstart: Validate Markdown to PDF Skill

## Prerequisites

- Work from the repository root.
- Docker Desktop integration is available in WSL.
- The active feature points at this spec:

```bash
cat .specify/feature.json
```

Expected feature directory:

```text
specs/002-markdown-to-pdf-skill
```

## 1. Inspect the Skill Package

```bash
find skills/markdown-to-pdf -maxdepth 3 -type f | sort
```

Expected files include:

```text
skills/markdown-to-pdf/Dockerfile
skills/markdown-to-pdf/SKILL.md
skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
skills/markdown-to-pdf/scripts/render-pdf.mjs
skills/markdown-to-pdf/templates/print.css
skills/markdown-to-pdf/templates/report.html
skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh
```

## 2. Build the Rendering Image

```bash
docker build -t markdown-to-pdf:local skills/markdown-to-pdf
```

Expected result: the image builds successfully from `pandoc/latex:3.10-debian`.

## 3. Smoke Test Required Tools

```bash
docker run --rm --entrypoint "" markdown-to-pdf:local sh -c 'pandoc --version && chromium --version && node --version'
```

Expected result: each tool prints a version.

## 4. Convert the Representative Sample

```bash
skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh \
  --image markdown-to-pdf:local \
  skills/markdown-to-pdf/fixtures/success/report.md \
  --output /tmp/sample-report.pdf
```

Expected behavior:

- The script reports resolved metadata before conversion.
- The script produces `/tmp/sample-report.pdf`.
- The PDF is non-empty.
- The PDF includes metadata, table of contents, rendered math, rendered Mermaid diagram, local image content, and readable long table content.

## 5. Validate Unique Output Naming

Run the same command again:

```bash
skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh \
  --image markdown-to-pdf:local \
  skills/markdown-to-pdf/fixtures/success/report.md \
  --output /tmp/sample-report.pdf
```

Expected behavior:

- Existing `/tmp/sample-report.pdf` is not overwritten.
- The script reports a unique final output path such as `/tmp/sample-report-1.pdf`.

## 6. Validate Failure Diagnostics

Run or simulate these failure cases:

```bash
skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh --image markdown-to-pdf:local path/to/missing.md
skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh --image markdown-to-pdf:local skills/markdown-to-pdf/fixtures/failure/missing-asset.md --output /tmp/missing-asset.pdf
skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh --image markdown-to-pdf:local skills/markdown-to-pdf/fixtures/failure/remote-asset.md --output /tmp/remote-asset.pdf
skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh --image markdown-to-pdf:local skills/markdown-to-pdf/fixtures/failure/invalid-mermaid.md --output /tmp/invalid-mermaid.pdf
skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh --image markdown-to-pdf:local skills/markdown-to-pdf/fixtures/failure/invalid-math.md --output /tmp/invalid-math.pdf
```

Expected behavior:

- Each failure identifies the cause.
- No failure is reported as success.
- Remote HTTP/HTTPS assets are rejected instead of fetched.
- Failed math, Mermaid, or major-section rendering does not produce a degraded PDF.
- Messages do not expose secrets or full environment dumps.

## 7. Run Full Skill Validation

```bash
skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh
```

Expected result:

- Docker image builds.
- Required tools are available.
- Success fixtures generate non-empty PDFs.
- Failure fixtures produce actionable diagnostics.
- Existing output collision produces a unique filename.

## 8. Run Repository Checks

```bash
make lint
make package
```

Expected result:

- Shell lint passes when `shellcheck` is available.
- The release package includes `skills/markdown-to-pdf/`.
