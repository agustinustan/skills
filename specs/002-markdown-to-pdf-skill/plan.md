# Implementation Plan: Markdown to PDF Skill

**Branch**: `002-markdown-to-pdf-skill` | **Date**: 2026-06-30 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/002-markdown-to-pdf-skill/spec.md`

## Summary

Harden the existing `skills/markdown-to-pdf/` skill so one Markdown report per invocation converts into one professional PDF with metadata, table of contents, LaTeX math, Mermaid diagrams, local relative assets, and readable long tables. The current worktree already contains the skill package, Dockerfile, LaTeX template, theme fragments, and cover fragments; implementation should align those artifacts with the clarified specification rather than create a duplicate skill directory.

## Technical Context

**Language/Version**: Markdown skill instructions, YAML/frontmatter metadata, shell command examples, Dockerfile based on `pandoc/latex:3.10-debian`, LaTeX templates, and optional Python/shell validation helpers

**Primary Dependencies**: Pandoc, XeLaTeX, Playwright/Chromium rendering path, Mermaid CLI/filter support, Docker Desktop integration, existing repository packaging under `skills/`

**Storage**: Files under `skills/markdown-to-pdf/`; generated PDFs and temporary working files live beside the user's source document or in an explicit output path, with unique filename derivation when a requested output already exists; no persistent application database

**Testing**: Metadata/frontmatter checks, Docker image build and tool smoke test, single-file sample Markdown conversion, PDF existence/non-empty checks, unique output naming checks, local/remote asset diagnostics, and hard-failure assertions for math, Mermaid, major-section, and other known failure cases

**Target Platform**: Local WSL environment with Docker Desktop integration; skill distributed through this AI skills repository for Codex-style assistant invocation

**Project Type**: Skill package inside an AI skills distribution repository

**Performance Goals**: Representative 20-page Markdown report converts in under 2 minutes on a typical local development machine; validation feedback appears immediately when required files or tools are missing

**Constraints**: Use the requested Markdown -> Pandoc -> HTML -> Playwright Chromium -> PDF workflow; base the container on `pandoc/latex:3.10-debian`; process exactly one Markdown file per invocation; support local relative assets only; avoid exposing secrets in logs; never overwrite existing PDF outputs automatically; fail rather than produce a degraded PDF when math, Mermaid diagrams, or major source sections cannot render

**Scale/Scope**: One skill package, its rendering assets, documentation, and validation samples; no batch conversion, recursive folder conversion, web service, daemon, database, remote asset fetching, or remote storage

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The project constitution file currently contains placeholder principle text and no ratified, enforceable gates. Planning will therefore apply the repository rules from `AGENTS.md`, the existing skill package conventions, and the feature specification:

- Keep changes scoped to `skills/markdown-to-pdf/` plus validation/documentation needed for this feature.
- Prefer existing repository structure and packaging conventions.
- Use Docker via `docker compose` only when Compose is needed; otherwise use direct `docker build` and `docker run` commands for the skill image.
- Avoid destructive operations, secret exposure, and automatic commits.
- Keep feature planning artifacts under `specs/002-markdown-to-pdf-skill/`.

Gate status before Phase 0: PASS. No enforceable constitution violation identified.

## Project Structure

### Documentation (this feature)

```text
specs/002-markdown-to-pdf-skill/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── skill-contract.md
├── checklists/
│   └── requirements.md
└── spec.md
```

### Source Code (repository root)

```text
skills/
├── ai-skill-template/
│   ├── SKILL.md
│   ├── agents/
│   ├── references/
│   └── scripts/
└── markdown-to-pdf/
    ├── SKILL.md
    ├── Dockerfile
    ├── template.latex
    └── templates/
        ├── covers/
        └── themes/

Makefile
package.json
README.md
AGENTS.md
```

**Structure Decision**: Use the existing `skills/markdown-to-pdf/` package and keep the feature as a skill-level enhancement. Do not introduce application source directories, services, storage layers, or a second package name.

## Phase 0: Research

Research completed in [research.md](research.md). Decisions resolve the planning questions around package reuse, single-file invocation scope, conversion workflow, container baseline, metadata handling, local asset policy, output collision handling, hard-failure diagnostics, long-table behavior, and validation strategy.

## Phase 1: Design & Contracts

Design artifacts:

- [data-model.md](data-model.md)
- [contracts/skill-contract.md](contracts/skill-contract.md)
- [quickstart.md](quickstart.md)

Agent context updated in `AGENTS.md` to point at this plan.

## Constitution Check: Post-Design

Post-design gate status: PASS.

- The design remains scoped to the existing `skills/markdown-to-pdf/` package.
- The selected workflow follows the user-provided conversion chain and container baseline.
- Validation uses local Docker and repository checks with no external service or account dependency.
- No complexity exceptions are needed.

## Complexity Tracking

No constitution violations or complexity exceptions.
