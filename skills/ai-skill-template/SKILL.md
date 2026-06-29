---
name: ai-skill-template
description: Use when creating or reviewing a Codex CLI skill in this repository, including SKILL.md structure, progressive disclosure, scripts, references, and install packaging.
---

# AI Skill Template

Use this skill as the starting point for new OpenAI Codex CLI skills in this repository.

## Workflow

1. Define one focused task for the skill.
2. Keep the `description` concise and trigger-oriented.
3. Put the operational instructions in `SKILL.md`.
4. Put deterministic helper logic in `scripts/`.
5. Put large examples, specs, and background material in `references/`.
6. Keep referenced files scoped to what Codex should load for the selected task.

## Structure

```text
skill-name/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── references/
└── scripts/
```

## Checks

Before releasing a skill:

1. Confirm `SKILL.md` has `name` and `description` frontmatter.
2. Confirm the description clearly states when to use the skill.
3. Run shell syntax checks for scripts.
4. Install locally and verify the skill appears in Codex CLI with `/skills` or `$`.
