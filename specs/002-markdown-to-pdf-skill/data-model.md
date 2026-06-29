# Data Model: Markdown to PDF Skill

## Skill

Represents the discoverable `markdown-to-pdf` capability.

**Fields**:

- `name`: Exact skill identifier. Must be `markdown-to-pdf`.
- `description`: Trigger-oriented description explaining when to use the skill.
- `instructions`: Operational guidance for converting Markdown to PDF.
- `assets`: Rendering files required by the skill, such as templates, themes, covers, and container definition.

**Validation rules**:

- `name` must match the directory name and required identifier `markdown-to-pdf`.
- `description` must mention Markdown to professional PDF conversion.
- `instructions` must cover input, output, metadata, table of contents, math, diagrams, long tables, diagnostics, and validation.
- Required rendering assets must exist before conversion is attempted.

## Markdown Source Document

Represents the input report file.

**Fields**:

- `path`: Source Markdown file location.
- `frontmatter`: Optional source metadata.
- `headings`: Heading structure used for table of contents and navigation.
- `body_content`: Prose, lists, code, tables, math, diagrams, and images.
- `relative_assets`: Local relative files referenced from the Markdown document.

**Validation rules**:

- `path` must exist, be readable, and point to a non-empty Markdown file.
- Relative assets must resolve from the source document directory unless documented otherwise.
- Remote HTTP/HTTPS asset references are invalid for v1 and must produce actionable diagnostics.
- Mermaid diagrams and math expressions must be renderable or fail conversion with actionable diagnostics.
- Long tables and wide tables must remain readable in the generated PDF.

## Conversion Request

Represents the user's requested conversion.

**Fields**:

- `source_path`: Required Markdown source path.
- `output_path`: Optional PDF destination.
- `metadata_overrides`: Optional title, author, subject or description, date, keywords, and version.
- `output_naming`: Strategy for deriving the final PDF filename, including unique filename generation when the requested output already exists.
- `style_options`: Optional theme, cover, header/footer, margin, logo, and syntax highlighting preferences.

**Validation rules**:

- `source_path` is required and must identify exactly one Markdown file.
- If `output_path` is omitted, the default output path is derived from the source filename.
- Existing output files are protected by deriving a unique filename when the requested output path already exists.
- Metadata values must be resolved before conversion starts and should be reported to the user.

## Rendered HTML Document

Represents the intermediate document produced from Markdown before PDF rendering.

**Fields**:

- `html_path`: Intermediate HTML location.
- `resolved_assets`: Assets made available to the rendering step.
- `rendered_math`: Math rendering state.
- `rendered_diagrams`: Diagram rendering state.
- `toc`: Generated table of contents.
- `print_styles`: Page, table, heading, and code formatting rules.

**Validation rules**:

- HTML must contain the expected source sections before PDF rendering.
- Math, diagrams, and major source sections must either render successfully or fail conversion with clear diagnostics.
- Print styles must support readable page breaks and table continuation.

## PDF Document

Represents the generated shareable report.

**Fields**:

- `path`: Final PDF output location.
- `metadata`: PDF-visible metadata.
- `navigation`: Table of contents and heading structure.
- `pages`: Rendered page content.
- `diagnostics`: Validation observations or warnings.

**Validation rules**:

- `path` must exist after successful conversion.
- PDF file size must be non-zero.
- Metadata, table of contents, math, diagrams, and long tables must be verifiable for the sample document.
- A failed conversion must not leave the user with a misleading success message.
- A successful PDF must not be a degraded output missing math, diagrams, or major source sections.

## Conversion Result

Represents the final outcome shown to the user.

**Fields**:

- `status`: `success` or `failure`.
- `output_path`: Actual final PDF path when successful, including any unique filename derived from an existing requested path.
- `message`: Concise user-facing result.
- `diagnostics`: Actionable details for failures.

**Validation rules**:

- Success must include the final PDF location.
- Failure must identify the known source of the problem, such as missing file, missing asset, remote asset reference, invalid diagram, invalid math, missing major section, unavailable tool, or unwritable destination.
- Normal messages must not expose secrets from environment variables, source files, or command output.

## Relationships

- One `Skill` handles many `Conversion Request` instances.
- One `Conversion Request` references exactly one `Markdown Source Document`.
- One `Markdown Source Document` produces one `Rendered HTML Document`.
- One `Rendered HTML Document` produces one `PDF Document`.
- Each `Conversion Request` produces one `Conversion Result`.

## State Transitions

```text
Requested -> Input Validated -> Metadata Resolved -> HTML Rendered -> PDF Rendered -> Validated -> Reported
```

Failure can occur at any stage after `Requested`; failures transition directly to `Reported` with actionable diagnostics.
