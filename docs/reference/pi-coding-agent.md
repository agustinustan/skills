# Pi Coding Agent Support

This repository can also install its skill folders for Pi Coding Agent from `https://pi.dev/`.

Pi supports Agent Skills and loads directories that contain `SKILL.md`.

Default user install:

```bash
bash install.sh --pi-user
```

The default target is:

```text
$HOME/.pi/agent/skills
```

Install only Pi skills and skip Codex:

```bash
bash install.sh --pi-only
```

Install to a custom Pi skill directory:

```bash
bash install.sh --pi-skills-dir /path/to/pi/skills
```

Machine-wide install:

```bash
sudo bash install.sh --pi-system
```

Pi also loads skills from `$HOME/.agents/skills`, so the default Codex install target can be shared by Pi. Use `--pi-user` when you want the skills in Pi's own global agent directory.

Pi can also consume this repository as a package because it has a conventional `skills/` directory and a `package.json` `pi.skills` entry:

```bash
pi install git:github.com/agustinus/skills@v0.1.0
pi install /absolute/path/to/skills
```

The installer copies every folder under `skills/` that contains a `SKILL.md`. Existing skill folders are moved to `<skill>.previous` and replaced atomically through a temporary directory.
