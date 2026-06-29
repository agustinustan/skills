# Skill Contract: Markdown to PDF

## Package Contract

The skill package MUST exist at:

```text
skills/markdown-to-pdf/
```

Required files:

```text
skills/markdown-to-pdf/
├── SKILL.md
├── Dockerfile
├── template.latex
└── templates/
    ├── covers/
    └── themes/
```

## `SKILL.md` Contract

`SKILL.md` MUST contain YAML frontmatter with:

```yaml
name: markdown-to-pdf
description: <trigger-oriented description>
```

The Markdown body MUST describe:

- When to use the skill.
- Accepted Markdown source input.
- Default and explicit PDF output behavior.
- Metadata precedence and fallback behavior.
- Table of contents generation.
- LaTeX math support.
- Mermaid diagram support.
- Local asset handling.
- Long-table and page-break behavior.
- Existing-output unique filename behavior.
- Failure diagnostics.
- End-to-end validation with a representative sample.

## Invocation Contract

Default invocation:

```text
$markdown-to-pdf path/to/report.md
```

Expected outcome:

- The skill validates exactly one source document.
- The skill resolves document metadata.
- The skill converts the document through the documented local workflow.
- The skill reports the final PDF path when successful.
- The skill does not overwrite an existing PDF; if the default output exists, it generates and reports a unique filename.

Invocation with output path:

```text
$markdown-to-pdf path/to/report.md --output path/to/report.pdf
```

Expected outcome:

- The PDF is written to the requested output path when it does not already exist.
- If the requested output path already exists, a unique filename is generated and reported.
- Parent directory or permission problems are reported clearly.

## Rendering Contract

The implementation MUST use the planned local conversion chain:

```text
Markdown -> Pandoc -> HTML -> Playwright Chromium -> PDF
```

The container baseline MUST be:

```text
pandoc/latex:3.10-debian
```

The generated PDF MUST support:

- PDF metadata from source metadata, user overrides, or derived defaults.
- Table of contents for headed documents.
- Rendered LaTeX math.
- Rendered Mermaid diagrams.
- Readable tables across page boundaries.
- Local images and supported relative assets.

The implementation MUST reject:

- Multiple source Markdown files in one invocation.
- Folder or recursive conversion input.
- Remote HTTP/HTTPS asset references.
- Degraded output where math, Mermaid diagrams, or major source sections fail to render.

## Diagnostics Contract

Failures MUST be reported as actionable messages for at least:

- Missing source file.
- Empty or unreadable source file.
- Missing relative asset.
- Remote HTTP/HTTPS asset reference.
- Invalid Mermaid diagram.
- Invalid or unsupported math.
- Unavailable container or rendering dependency.
- Unwritable output destination.
- Blank or incomplete PDF output.
- Existing requested output path, handled by unique filename generation rather than failure.

Normal diagnostics MUST avoid printing secrets or full environment dumps.

## Validation Contract

The feature is valid when a representative sample conversion proves:

- Metadata is visible in the output.
- Table of contents is generated.
- Math renders correctly.
- Mermaid diagrams render correctly.
- A long table remains readable across pages.
- The resulting PDF exists and is non-empty.
- Existing output path collision produces a unique final filename.
- Known failure fixtures produce clear failure messages.

## Non-Goals

- No hosted rendering service.
- No web API or daemon.
- No persistent database.
- No remote storage integration.
- No remote asset fetching in v1.
- No batch or recursive folder conversion in v1.
- No automatic overwrite of user files.
