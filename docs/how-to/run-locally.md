# Run Locally

Panduan ini menjelaskan cara menjalankan repo dari checkout lokal.

## Validate Installer Requirements

```bash
bash install.sh --check
```

## Install Codex CLI Skills to User Scope

```bash
bash install.sh
```

Installer default memasang skill ke:

```text
$HOME/.agents/skills
```

## Install to a Custom Codex Skills Directory

```bash
bash install.sh --codex-skills-dir "$HOME/.agents/skills"
```

## Install Pi Coding Agent Skills

```bash
bash install.sh --pi-user
```

Untuk hanya memasang skill Pi:

```bash
bash install.sh --pi-only
```

## Preview Changes Without Writing

```bash
bash install.sh --dry-run
```

Gunakan `--dry-run` sebelum menjalankan mode system install atau target custom yang belum pernah dipakai.
