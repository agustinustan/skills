# Tasks: Markdown to PDF Skill

**Input**: Design documents from `specs/002-markdown-to-pdf-skill/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/skill-contract.md](contracts/skill-contract.md), [quickstart.md](quickstart.md)

**Tests**: Included because FR-016 explicitly requires validation coverage for metadata, table of contents, math, Mermaid diagrams, and long tables.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel because it touches different files and does not depend on incomplete tasks.
- **[Story]**: User story label from [spec.md](spec.md), only used in user story phases.
- Every task includes an exact file path.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare the existing skill package and validation layout for implementation.

- [X] T001 Create validation fixture directories in skills/markdown-to-pdf/fixtures/success/ and skills/markdown-to-pdf/fixtures/failure/
- [X] T002 [P] Create scripts directory for conversion helpers in skills/markdown-to-pdf/scripts/
- [X] T003 [P] Create test directory for skill validation in skills/markdown-to-pdf/tests/
- [X] T004 [P] Add executable placeholder script with CLI usage comments in skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
- [X] T005 [P] Add executable placeholder validation script in skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh
- [X] T006 Document repository-local image name and fixture paths in skills/markdown-to-pdf/SKILL.md

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the shared conversion contract, container runtime, and test fixtures required before any user story can be completed.

**Critical**: No user story work can begin until this phase is complete.

- [X] T007 Update skills/markdown-to-pdf/Dockerfile to support Pandoc HTML output plus Playwright-compatible Chromium PDF rendering from pandoc/latex:3.10-debian
- [X] T008 [P] Add print stylesheet for professional PDF layout, TOC, math, diagrams, page breaks, and long tables in skills/markdown-to-pdf/templates/print.css
- [X] T009 [P] Add HTML wrapper template for Pandoc output in skills/markdown-to-pdf/templates/report.html
- [X] T010 [P] Add representative successful Markdown fixture with metadata, headings, math, Mermaid, local image reference, and long table in skills/markdown-to-pdf/fixtures/success/report.md
- [X] T011 [P] Add local image fixture referenced by the successful Markdown sample in skills/markdown-to-pdf/fixtures/success/assets/sample.svg
- [X] T012 Add shared shell helpers for source validation, metadata extraction, path resolution, unique output naming, and sanitized diagnostics in skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
- [X] T013 Add Docker build and tool smoke-test commands for the local renderer image in skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh
- [X] T014 Update skills/markdown-to-pdf/SKILL.md to state the canonical workflow Markdown -> Pandoc -> HTML -> Playwright Chromium -> PDF

**Checkpoint**: Foundation ready; the package has the conversion script shape, renderer image baseline, shared templates, and fixtures required by each story.

---

## Phase 3: User Story 1 - Convert a Markdown Report to a Shareable PDF (Priority: P1) MVP

**Goal**: A user converts exactly one Markdown report into one complete, shareable PDF with metadata, table of contents, math, Mermaid diagrams, local relative assets, and long tables.

**Independent Test**: Run the success fixture through the skill and verify a non-empty PDF with resolved metadata, TOC, rendered math, rendered Mermaid, local image, and readable long table output.

### Tests for User Story 1

- [X] T015 [P] [US1] Add success fixture assertions for metadata, TOC, math, Mermaid, local image, long table, and non-empty PDF in skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh
- [X] T016 [P] [US1] Add output path collision assertion for unique filename generation in skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh
- [X] T017 [P] [US1] Add single-source invocation assertion rejecting multiple Markdown paths in skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh

### Implementation for User Story 1

- [X] T018 [US1] Implement single Markdown source argument parsing and rejection of multiple source files in skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
- [X] T019 [US1] Implement metadata resolution from frontmatter, user/default values, and fallback filename/date values in skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
- [X] T020 [US1] Implement default output path derivation and unique filename generation when requested PDF output exists in skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
- [X] T021 [US1] Implement Pandoc Markdown-to-HTML step with table of contents and local asset path handling in skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
- [X] T022 [US1] Implement Playwright Chromium HTML-to-PDF rendering step in skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
- [X] T023 [US1] Wire print stylesheet and HTML wrapper into the conversion command in skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
- [X] T024 [US1] Update skills/markdown-to-pdf/SKILL.md with the single-file invocation contract, output naming behavior, and success result format
- [X] T025 [US1] Run the US1 validation path and record expected command/output in specs/002-markdown-to-pdf-skill/quickstart.md

**Checkpoint**: User Story 1 is independently complete when the success fixture generates a non-empty PDF and reports the actual final path.

---

## Phase 4: User Story 2 - Diagnose Conversion Problems Clearly (Priority: P2)

**Goal**: A user receives actionable diagnostics for invalid inputs, unsupported assets, rendering failures, missing tools, and unwritable destinations.

**Independent Test**: Run failure fixtures for missing file, missing local asset, remote HTTP/HTTPS asset, invalid Mermaid, invalid math, unwritable output, and major-section render failure; each failure reports a clear cause and no misleading success.

### Tests for User Story 2

- [X] T026 [P] [US2] Add missing local asset fixture in skills/markdown-to-pdf/fixtures/failure/missing-asset.md
- [X] T027 [P] [US2] Add remote HTTP/HTTPS asset fixture in skills/markdown-to-pdf/fixtures/failure/remote-asset.md
- [X] T028 [P] [US2] Add invalid Mermaid fixture in skills/markdown-to-pdf/fixtures/failure/invalid-mermaid.md
- [X] T029 [P] [US2] Add invalid math fixture in skills/markdown-to-pdf/fixtures/failure/invalid-math.md
- [X] T030 [P] [US2] Add diagnostics assertions for all failure fixtures in skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh

### Implementation for User Story 2

- [X] T031 [US2] Implement missing source, empty source, unreadable source, and unwritable destination checks in skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
- [X] T032 [US2] Implement local relative asset validation and remote HTTP/HTTPS asset rejection in skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
- [X] T033 [US2] Implement hard-fail detection for failed LaTeX math, Mermaid diagrams, and missing major source sections in skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
- [X] T034 [US2] Implement sanitized actionable diagnostics that avoid environment dumps and secrets in skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
- [X] T035 [US2] Update skills/markdown-to-pdf/SKILL.md troubleshooting section with missing asset, remote asset, invalid math, invalid Mermaid, and degraded-output failure guidance
- [X] T036 [US2] Update specs/002-markdown-to-pdf-skill/quickstart.md with the final failure validation commands and expected diagnostics

**Checkpoint**: User Story 2 is independently complete when each failure fixture fails clearly and no failed conversion reports success.

---

## Phase 5: User Story 3 - Reuse Professional PDF Defaults (Priority: P3)

**Goal**: A repeat user gets consistent report styling, metadata behavior, navigation, table handling, and configuration defaults without custom work for every document.

**Independent Test**: Convert multiple Markdown reports with different lengths and metadata states, then verify consistent default styling, PDF metadata, navigable structure, long-table handling, and documented configuration behavior.

### Tests for User Story 3

- [X] T037 [P] [US3] Add alternate metadata-complete fixture in skills/markdown-to-pdf/fixtures/success/report-with-full-metadata.md
- [X] T038 [P] [US3] Add metadata-missing fixture for fallback metadata validation in skills/markdown-to-pdf/fixtures/success/report-with-fallback-metadata.md
- [X] T039 [P] [US3] Add professional defaults assertions for metadata, navigation, long tables, and style markers in skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh

### Implementation for User Story 3

- [X] T040 [US3] Implement default style option mapping for theme, cover, margins, headers, footers, logo, and syntax highlighting in skills/markdown-to-pdf/scripts/convert-markdown-to-pdf.sh
- [X] T041 [US3] Align skills/markdown-to-pdf/templates/themes/professional.tex with the HTML/Chromium print stylesheet behavior in skills/markdown-to-pdf/templates/print.css
- [X] T042 [US3] Align skills/markdown-to-pdf/templates/covers/standard.tex and skills/markdown-to-pdf/templates/covers/corporate.tex with the documented professional defaults in skills/markdown-to-pdf/templates/print.css
- [X] T043 [US3] Update skills/markdown-to-pdf/SKILL.md with final professional defaults, metadata fallback rules, and configuration examples
- [X] T044 [US3] Update specs/002-markdown-to-pdf-skill/quickstart.md with final default-style validation commands and expected results

**Checkpoint**: User Story 3 is independently complete when multiple reports produce consistent professional PDFs with verified metadata, navigation, and long-table behavior.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final validation, documentation consistency, packaging, and cleanup across all stories.

- [X] T045 [P] Update docs/README.md if any new permanent documentation page is added for markdown-to-pdf
- [X] T046 [P] Ensure package release includes all markdown-to-pdf scripts, fixtures, templates, and Dockerfile via Makefile
- [X] T047 Run full skill validation script in skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh
- [X] T048 Run repository checks with make lint and make package from Makefile
- [X] T049 Review skills/markdown-to-pdf/SKILL.md for secret-safety guidance and no stale XeLaTeX-only workflow claims
- [X] T050 Review specs/002-markdown-to-pdf-skill/quickstart.md against implemented commands and update any stale expected output

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; can start immediately.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational; MVP scope.
- **User Story 2 (Phase 4)**: Depends on Foundational and can be developed after or alongside US1, but its degraded-output checks are easiest after the core conversion path exists.
- **User Story 3 (Phase 5)**: Depends on Foundational and benefits from US1 conversion path, but can refine defaults independently.
- **Polish (Phase 6)**: Depends on the desired user stories being complete.

### User Story Dependencies

- **US1 (P1)**: No dependency on other user stories; complete this first for MVP.
- **US2 (P2)**: Can start after Foundational; hard-failure checks should be verified against the US1 conversion path.
- **US3 (P3)**: Can start after Foundational; final styling validation depends on the US1 conversion path.

### Within Each User Story

- Test fixtures and validation assertions come before implementation tasks.
- Script behavior tasks come before SKILL.md and quickstart updates that document final commands.
- Each story checkpoint must pass before claiming that story complete.

---

## Parallel Execution Examples

### User Story 1

```text
Task: "T015 [P] [US1] Add success fixture assertions in skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh"
Task: "T016 [P] [US1] Add output path collision assertion in skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh"
Task: "T017 [P] [US1] Add single-source invocation assertion in skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh"
```

### User Story 2

```text
Task: "T026 [P] [US2] Add missing local asset fixture in skills/markdown-to-pdf/fixtures/failure/missing-asset.md"
Task: "T027 [P] [US2] Add remote HTTP/HTTPS asset fixture in skills/markdown-to-pdf/fixtures/failure/remote-asset.md"
Task: "T028 [P] [US2] Add invalid Mermaid fixture in skills/markdown-to-pdf/fixtures/failure/invalid-mermaid.md"
Task: "T029 [P] [US2] Add invalid math fixture in skills/markdown-to-pdf/fixtures/failure/invalid-math.md"
```

### User Story 3

```text
Task: "T037 [P] [US3] Add alternate metadata-complete fixture in skills/markdown-to-pdf/fixtures/success/report-with-full-metadata.md"
Task: "T038 [P] [US3] Add metadata-missing fixture in skills/markdown-to-pdf/fixtures/success/report-with-fallback-metadata.md"
Task: "T039 [P] [US3] Add professional defaults assertions in skills/markdown-to-pdf/tests/validate-markdown-to-pdf.sh"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 setup.
2. Complete Phase 2 foundational conversion assets.
3. Complete Phase 3 User Story 1.
4. Stop and validate the success fixture produces one complete PDF from one Markdown source.

### Incremental Delivery

1. Deliver US1 to prove the core conversion path.
2. Add US2 to make failures safe and actionable.
3. Add US3 to stabilize professional defaults and repeatable styling.
4. Run Phase 6 polish after the desired story set is complete.

### Parallel Team Strategy

1. Complete Setup and Foundational phases together.
2. After Foundational, one contributor can build US1 core conversion while another prepares US2 failure fixtures and another prepares US3 default-style fixtures.
3. Merge through story checkpoints so each story remains independently demonstrable.
