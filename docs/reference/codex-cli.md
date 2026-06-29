# OpenAI Codex CLI Support

This repository distributes skills for OpenAI Codex CLI.

Codex discovers skills from these locations:

```text
$REPO_ROOT/.agents/skills
$HOME/.agents/skills
/etc/codex/skills
```

This installer defaults to user scope:

```bash
bash install.sh
```

The default target is:

```text
$HOME/.agents/skills
```

For a machine-wide install:

```bash
sudo bash install.sh --codex-system
```

For a custom target:

```bash
bash install.sh --codex-skills-dir /path/to/.agents/skills
```

Systemd is not required for Codex CLI skills. Use `--systemd` only if this repository later ships a daemon or background service.

After install, restart Codex if a new skill does not appear immediately. In the CLI, use `/skills` or type `$` to invoke an installed skill.
