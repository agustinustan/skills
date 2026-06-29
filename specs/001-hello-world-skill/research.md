# Phase 0 Research: Hello World Skill

## Decision: Use the Existing `skills/hello-world/` Package

**Rationale**: The repository already contains `skills/hello-world/SKILL.md` and `skills/hello-world/agents/openai.yaml`. Reusing that package avoids duplicate skill names and keeps the implementation aligned with the distribution layout.

**Alternatives considered**:

- Create a new directory under a different name: rejected because the specification requires the exact skill name `hello-world`.
- Create files outside `skills/`: rejected because repository packaging and `package.json` identify `./skills` as the skill source.

## Decision: Keep the Skill Instruction-Only

**Rationale**: The requested behavior is a deterministic greeting demonstration. A `SKILL.md` with focused instructions and metadata is sufficient; scripts would add unnecessary moving parts and validation burden.

**Alternatives considered**:

- Add a helper script: rejected because no computation, file generation, or external command is required for the default greeting.
- Add reference files: rejected because the skill purpose is small enough to fit directly in `SKILL.md`.

## Decision: Use Existing Agent Metadata Shape

**Rationale**: `skills/ai-skill-template/agents/openai.yaml` shows the local metadata convention: `interface.display_name`, `interface.short_description`, and `interface.default_prompt`. `skills/hello-world/agents/openai.yaml` already follows that shape.

**Alternatives considered**:

- Add new metadata keys: rejected because the existing convention is sufficient for discovery and prompt display.
- Remove agent metadata: rejected because discoverability is part of the specification.

## Decision: Validate with Local Repository Checks and Manual Invocation Criteria

**Rationale**: This repository has `make lint`, `shellcheck`, `python3`, and `yq` available. The skill itself is Markdown/YAML, so validation should combine repository linting, metadata parsing, and manual invocation/discovery checks.

**Alternatives considered**:

- Add a full automated skill test harness: rejected as disproportionate for a minimal deterministic skill.
- Depend on network or external account checks: rejected because the specification requires no external setup for default behavior.

## Decision: No External Interface Beyond Skill Invocation

**Rationale**: The public contract is the skill package itself: name, description, optional invocation text, and greeting response behavior. No web API, database, or service contract is involved.

**Alternatives considered**:

- Define an HTTP or CLI API contract: rejected because the repository distributes assistant skills, not a standalone service for this feature.
