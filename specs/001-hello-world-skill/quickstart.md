# Quickstart: Validate Hello World Skill

## Prerequisites

- Work from the repository root.
- Ensure the active feature is selected:

```bash
cat .specify/feature.json
```

Expected feature directory:

```text
specs/001-hello-world-skill
```

## 1. Inspect the Skill Package

```bash
find skills/hello-world -maxdepth 3 -type f | sort
```

Expected files:

```text
skills/hello-world/SKILL.md
skills/hello-world/agents/openai.yaml
```

## 2. Validate Skill Frontmatter and Agent Metadata

```bash
python3 - <<'PY'
from pathlib import Path

skill = Path("skills/hello-world/SKILL.md").read_text(encoding="utf-8")
assert skill.startswith("---\n"), "SKILL.md must start with YAML frontmatter"
assert "name: hello-world" in skill, "SKILL.md must declare name: hello-world"
assert "description:" in skill, "SKILL.md must include a description"
assert "Hello" in skill or "hello" in skill, "SKILL.md must describe hello-world behavior"

agent = Path("skills/hello-world/agents/openai.yaml").read_text(encoding="utf-8")
assert "display_name:" in agent, "openai.yaml must include display_name"
assert "short_description:" in agent, "openai.yaml must include short_description"
assert "$hello-world" in agent, "openai.yaml should include the skill trigger"

print("hello-world skill metadata OK")
PY
```

Expected output:

```text
hello-world skill metadata OK
```

## 3. Validate YAML Metadata

```bash
yq '.interface.display_name' skills/hello-world/agents/openai.yaml
yq '.interface.short_description' skills/hello-world/agents/openai.yaml
yq '.interface.default_prompt' skills/hello-world/agents/openai.yaml
```

Expected result: each command prints a non-empty value.

## 4. Run Repository Lint

```bash
make lint
```

Expected result: shell scripts pass `shellcheck`.

## 5. Validate Skill Behavior Manually

Invoke the skill in Codex with:

```text
$hello-world
```

Expected behavior:

- The response includes "Hello, world" or an equivalent greeting.
- The response is concise and readable in under 10 seconds.
- No credentials, network access, or project-specific setup are requested.

Invoke with optional context:

```text
$hello-world create a minimal shell example
```

Expected behavior:

- The response remains focused on a minimal hello-world example.
- Any suggested command or file is the smallest useful example for the requested context.
