# Decisions

Halaman ini mencatat keputusan desain yang perlu tetap terlihat saat repo berkembang.

## ADR-001: Documentation Uses Diataxis

Status: accepted

Documentation is organized by reader intent:

- tutorials for learning,
- how-to guides for task completion,
- reference for factual lookup,
- explanation for context and rationale.

Consequences:

- `docs/README.md` is the canonical documentation index.
- New docs must be placed in the matching category.
- Coding assistants must update the index when they add, move, or remove docs.

## ADR-002: User-Scope Skill Install Is the Default

Status: accepted

Default install targets Codex CLI user scope at `$HOME/.agents/skills`.

Consequences:

- Users can install without root when systemd and system install are not requested.
- Systemd remains optional.
- System install paths require explicit options.

## ADR-003: Release Artifacts Are Checksummed

Status: accepted

Release artifacts include SHA256 checksums and may include GPG detached signatures.

Consequences:

- Remote install validates checksums.
- Signature verification is performed when `.asc` is published.
- Release workflows must preserve artifact naming consistency.
