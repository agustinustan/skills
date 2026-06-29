# Feature Specification: Markdown to PDF Skill

**Feature Branch**: `002-markdown-to-pdf-skill`

**Created**: 2026-06-30

**Status**: Draft

**Input**: User description: "Buat skill markdown-to-pdf. Skill ini berguna untuk Convert markdown files to professional PDF documents with metadata, table of contents, LaTeX math, Mermaid diagrams, and long tables. Use when generating shareable PDF reports from markdown. Alur kerja: markdown -> pandoc -> html -> Playwright Chromium -> pdf. Technology: docker image pandoc/latex:3.10-debian"

## Clarifications

### Session 2026-06-30

- Q: Should v1 support one Markdown file, multiple files, or folder conversion per invocation? → A: Single Markdown file per invocation only.
- Q: Should v1 allow remote HTTP/HTTPS assets referenced by Markdown? → A: Only local relative assets are supported.
- Q: What should happen when the requested PDF output already exists? → A: Auto-generate a unique filename instead of overwriting.
- Q: Should conversion continue when math, diagrams, or major sections cannot render? → A: Fail conversion when math, diagrams, or major sections cannot render.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Convert a Markdown Report to a Shareable PDF (Priority: P1)

A user with a finished Markdown report wants to produce a polished PDF that can be shared with stakeholders without manually recreating formatting, metadata, navigation, diagrams, or tables.

**Why this priority**: This is the primary purpose of the skill and delivers the minimum useful outcome.

**Independent Test**: Can be fully tested by providing a Markdown file that contains headings, metadata, a table of contents requirement, math, a diagram, and a long table, then confirming the output PDF is complete and ready to share.

**Acceptance Scenarios**:

1. **Given** a Markdown report with document metadata and multiple heading levels, **When** the user invokes the skill for that file, **Then** a PDF is produced with the requested metadata and a usable table of contents.
2. **Given** a Markdown report containing LaTeX math, Mermaid diagrams, and long tables, **When** the user converts it to PDF, **Then** each content type appears correctly in the generated PDF.
3. **Given** the output destination is not specified, **When** the user converts a Markdown file, **Then** the skill saves the PDF beside the source file using a predictable matching filename.

---

### User Story 2 - Diagnose Conversion Problems Clearly (Priority: P2)

A user converting a report wants actionable feedback when the source document, assets, diagrams, or conversion environment prevent a successful PDF.

**Why this priority**: Conversion failures are common for report sources with linked images, diagrams, tables, or malformed markup; clear diagnostics reduce retry time.

**Independent Test**: Can be tested by converting Markdown with a missing image, invalid diagram syntax, malformed metadata, and an unwritable output path, then checking that each failure explains the cause and next action.

**Acceptance Scenarios**:

1. **Given** the Markdown file references an asset that cannot be found, **When** conversion runs, **Then** the user is told which asset is missing and where it was referenced.
2. **Given** a diagram or math expression cannot be rendered, **When** conversion runs, **Then** the user receives a message identifying the problematic section and the conversion does not silently produce an incomplete PDF.
3. **Given** the output path cannot be written, **When** conversion runs, **Then** the user receives a clear permission or destination error and no misleading success message is shown.

---

### User Story 3 - Reuse Professional PDF Defaults (Priority: P3)

A user who repeatedly creates reports wants consistent professional defaults so that PDFs have predictable layout, metadata, navigation, and table handling without custom configuration for every document.

**Why this priority**: Consistent defaults improve usability after the core conversion path is available, but they can be refined independently.

**Independent Test**: Can be tested by converting several Markdown reports with different lengths and content structures, then confirming the PDFs use consistent title pages or headers, table formatting, page breaks, and metadata behavior.

**Acceptance Scenarios**:

1. **Given** a Markdown report has explicit title, author, subject, and date metadata, **When** conversion completes, **Then** the PDF exposes that metadata to common PDF viewers.
2. **Given** a Markdown report contains a table that spans multiple pages, **When** conversion completes, **Then** the table remains readable across page boundaries.
3. **Given** a Markdown report contains enough headings for navigation, **When** conversion completes, **Then** the PDF includes navigable structure for readers.

### Edge Cases

- Source file does not exist, is empty, or is not readable.
- Source Markdown uses relative image or attachment paths from its own directory.
- Source Markdown references remote HTTP/HTTPS assets, which are unsupported in v1 and must be reported clearly.
- Metadata is incomplete, malformed, or absent.
- Mermaid diagram syntax is invalid or renders too large for the page.
- LaTeX math is malformed or includes unsupported constructs.
- Tables are wider than the page, span many pages, or contain very long unbroken text.
- Requested output file already exists.
- Conversion environment or required rendering capability is unavailable.
- Generated output would be blank, incomplete, or missing major source sections.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The skill MUST accept exactly one Markdown source file per invocation and produce one PDF document suitable for stakeholder sharing.
- **FR-002**: The skill MUST preserve document metadata from the source when metadata is provided, including title, author, subject or description, date, and keywords where available.
- **FR-003**: The skill MUST support an automatically generated table of contents for documents with headings.
- **FR-004**: The skill MUST render LaTeX-style math expressions in the generated PDF.
- **FR-005**: The skill MUST render Mermaid diagrams in the generated PDF.
- **FR-006**: The skill MUST keep long tables readable when they span multiple pages.
- **FR-007**: The skill MUST preserve local images and other supported linked assets referenced by the Markdown file using local relative paths.
- **FR-008**: The skill MUST reject remote HTTP/HTTPS asset references in v1 with an actionable message instead of fetching them automatically.
- **FR-009**: The skill MUST provide professional default styling appropriate for reports, including readable typography, page margins, heading hierarchy, code blocks, tables, and page breaks.
- **FR-010**: The skill MUST let users specify an output path and MUST provide a predictable default output path when none is specified.
- **FR-011**: The skill MUST protect existing output files from accidental overwrite by automatically generating a unique output filename when the requested PDF path already exists.
- **FR-012**: The skill MUST report successful conversion with the final PDF location.
- **FR-013**: The skill MUST report conversion failures with actionable messages that identify the failed input, content feature, asset, or output destination when known.
- **FR-014**: The skill MUST avoid exposing secrets from the user's environment, source files, or command output in normal messages.
- **FR-015**: The skill MUST document its expected inputs, outputs, supported Markdown features, limitations, and common troubleshooting steps.
- **FR-016**: The skill MUST include validation coverage that demonstrates conversion of metadata, table of contents, math, Mermaid diagrams, and long tables.
- **FR-017**: The skill MUST fail conversion instead of producing a degraded PDF when LaTeX math, Mermaid diagrams, or major source sections cannot render.

### Key Entities

- **Markdown Source Document**: The input report file, including front matter, headings, prose, code, math, diagrams, tables, images, and local relative asset references.
- **PDF Document**: The generated shareable report, including visible pages, document metadata, navigable structure, rendered diagrams, rendered math, and readable tables.
- **Conversion Request**: The user's conversion intent for one Markdown source file, including source path, optional destination path, output naming behavior, and any requested report options.
- **Conversion Result**: The outcome returned to the user, including success or failure status, output location when successful, and actionable diagnostics when unsuccessful or when rendering cannot complete without degrading the PDF.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can convert a representative 20-page Markdown report into a shareable PDF in under 2 minutes on a typical local development machine.
- **SC-002**: At least 95% of supported sample reports containing metadata, table of contents, math, Mermaid diagrams, and long tables produce complete PDFs on the first attempt.
- **SC-003**: 100% of failed conversions in the validation suite return a clear failure reason and do not report success.
- **SC-004**: A reviewer can verify PDF metadata, navigable structure, rendered diagrams, rendered math, and readable multi-page tables from the generated sample PDF without inspecting implementation details.
- **SC-005**: Users can complete the primary conversion task with one command and no manual post-processing for the documented sample report.

## Assumptions

- The first version targets local report generation by a developer or documentation author in this repository.
- The first version does not support batch or recursive folder conversion.
- The source of truth is a Markdown file on disk, with local relative assets resolved from the source file's directory unless documented otherwise.
- Remote HTTP/HTTPS assets are out of scope for v1 to keep conversion local, private, and repeatable.
- A professional PDF means the output is readable, consistently styled, has useful metadata and navigation, and preserves the important source content.
- If source metadata is absent, the skill uses sensible fallback metadata derived from the source filename and conversion date.
- Existing files are not overwritten by default; when the requested PDF path exists, the skill derives a unique filename and reports the actual output path.
- The user-provided conversion approach is a planning constraint, while this specification defines the user-visible behavior and acceptance criteria.
