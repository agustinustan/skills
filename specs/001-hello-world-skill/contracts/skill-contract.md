# Skill Contract: Hello World

## Package Contract

The skill package MUST exist at:

```text
skills/hello-world/
```

Required files:

```text
skills/hello-world/
├── SKILL.md
└── agents/
    └── openai.yaml
```

## `SKILL.md` Contract

`SKILL.md` MUST contain YAML frontmatter with:

```yaml
name: hello-world
description: <trigger-oriented description>
```

The Markdown body MUST:

- Explain that the skill creates or returns minimal hello-world output.
- Prefer concise, deterministic output.
- Avoid requiring credentials, network access, or external setup.
- Preserve optional user context without failing.

## OpenAI Agent Metadata Contract

`agents/openai.yaml` MUST contain:

```yaml
interface:
  display_name: "Hello World"
  short_description: <brief discovery text>
  default_prompt: <example prompt using $hello-world>
```

Recommended behavior:

- `display_name` is human-readable and short.
- `short_description` is suitable for a compact skill list.
- `default_prompt` demonstrates the `$hello-world` trigger.

## Invocation Contract

Default invocation:

```text
$hello-world
```

Expected outcome:

- Assistant responds with a concise hello-world greeting.
- No follow-up question is required.
- No file mutation occurs unless the user explicitly asks for a generated example file.

Contextual invocation:

```text
$hello-world create a Python example
```

Expected outcome:

- Assistant keeps the response focused on a minimal hello-world example for the requested context.
- Added files or commands, if any, follow existing repository conventions and remain minimal.

## Non-Goals

- No external service contract.
- No persistent storage contract.
- No authentication or authorization contract.
- No broad starter application scaffolding.
