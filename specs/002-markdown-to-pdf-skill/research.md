# Phase 0 Research: Markdown to PDF Skill

## Decision: Reuse the Existing `skills/markdown-to-pdf/` Package

**Rationale**: The repository already contains `skills/markdown-to-pdf/SKILL.md`, `Dockerfile`, `template.latex`, and theme/cover fragments. Reusing and hardening that package avoids duplicate skill names and keeps packaging aligned with `package.json`, which exposes `./skills`.

**Alternatives considered**:

- Create a new skill directory: rejected because the required skill name already exists and duplicate names would confuse discovery.
- Move the skill outside `skills/`: rejected because repository packaging and installer conventions use `skills/` as the source of distributed skill packages.

## Decision: Implement the Requested Conversion Chain as the Primary Path

**Rationale**: The feature explicitly requests `markdown -> pandoc -> html -> Playwright Chromium -> pdf`. Planning should move the existing Pandoc/XeLaTeX-oriented instructions toward the requested HTML and browser-rendered PDF path while preserving PDF-quality requirements such as metadata, table of contents, math, diagrams, and long tables.

**Alternatives considered**:

- Keep a direct Pandoc to PDF path as the only path: rejected because it does not match the requested workflow.
- Use a hosted rendering service: rejected because the feature targets local report generation and should not require external accounts or secret handling.

## Decision: Support One Markdown Source File per Invocation

**Rationale**: The clarified v1 scope is exactly one Markdown source file producing one PDF. This keeps output naming, validation, and failure handling deterministic while the core renderer is hardened.

**Alternatives considered**:

- Multiple Markdown files in one invocation: rejected because it requires batch progress reporting, partial-failure semantics, and per-file output collision rules.
- Recursive folder conversion: rejected because it expands scope beyond the report-generation workflow and complicates asset resolution.

## Decision: Keep `pandoc/latex:3.10-debian` as the Container Baseline

**Rationale**: The user specified this image. It provides a stable Pandoc/LaTeX base while allowing the image to add Chromium, Playwright-compatible runtime dependencies, and Mermaid tooling.

**Alternatives considered**:

- Use a Playwright base image: rejected because it would ignore the requested Pandoc image baseline.
- Run directly on the host: rejected because local host dependency drift would make repeatable conversions harder.

## Decision: Treat Metadata Resolution as a Contracted Skill Behavior

**Rationale**: The spec requires metadata preservation and sensible fallbacks. The skill should define predictable precedence for source metadata, user-specified values, and derived defaults, then report the resolved metadata before conversion.

**Alternatives considered**:

- Require all metadata from the user every time: rejected because it creates unnecessary friction for Markdown files with frontmatter.
- Ignore missing metadata: rejected because professional reports need useful title and document metadata.

## Decision: Support Only Local Relative Assets in v1

**Rationale**: The clarified asset policy keeps conversion local, private, and repeatable. Remote HTTP/HTTPS assets should be rejected with actionable diagnostics instead of fetched implicitly.

**Alternatives considered**:

- Fetch remote assets automatically: rejected because it introduces privacy, network reliability, and reproducibility risks.
- Fetch remote assets after confirmation: rejected for v1 because it complicates non-interactive usage and validation.

## Decision: Generate a Unique Filename When Output Exists

**Rationale**: The clarified output policy protects existing PDFs without requiring an interactive prompt or overwrite flag. The skill must report the actual generated path so users know which file to share.

**Alternatives considered**:

- Fail when output exists: rejected by clarification in favor of successful unique naming.
- Ask interactively before overwrite: rejected because interactive prompts are awkward in automated or scripted validation flows.
- Overwrite with an explicit flag: rejected because v1 should avoid destructive output behavior.

## Decision: Validate Long Tables and Rich Content with a Representative Sample

**Rationale**: Metadata, table of contents, math, Mermaid diagrams, local images, and multi-page tables are the core differentiators of this skill. A representative sample conversion is the most direct way to prove the feature works end-to-end.

**Alternatives considered**:

- Validate only static files and metadata: rejected because it would not prove rendering behavior.
- Depend only on manual visual inspection: rejected because automated smoke checks should catch blank or missing outputs before review.

## Decision: Prefer Hard Failure Diagnostics Over Partial Success

**Rationale**: The specification requires actionable messages and no misleading success state. Missing assets, invalid diagrams, malformed math, unavailable tools, unwritable outputs, and missing major source sections should fail visibly instead of producing a degraded PDF.

**Alternatives considered**:

- Continue conversion with warnings when major content fails: rejected because a shareable report with missing diagrams, math, or major sections is misleading.
- Surface raw command output only: rejected because tool logs can be noisy and may expose irrelevant environment detail.

## Decision: Expose a Skill Invocation Contract, Not a Service API

**Rationale**: This repository distributes AI assistant skills. The public interface is the skill package and its documented invocation behavior, not an HTTP API, daemon, or persistent service.

**Alternatives considered**:

- Define a web API contract: rejected because no web service is in scope.
- Define a database schema: rejected because the feature stores no persistent application data.
