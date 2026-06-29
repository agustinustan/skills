# Getting Started

Tutorial ini membantu pengguna baru memahami repo `ai-skills`, menjalankan pemeriksaan dasar, dan mencoba instalasi lokal ke direktori skill user.

## Prerequisites

- Bash shell.
- `tar`, `sha256sum`, `sed`, dan `uname`.
- `shellcheck` untuk lint script shell.
- `gpg` bila ingin membuat atau memverifikasi signature release.

Di mesin ini, gunakan:

```bash
angkrang doctor
```

## 1. Clone Repository

```bash
git clone https://github.com/agustinustan/skills.git
cd skills
```

## 2. Lihat Command yang Tersedia

```bash
make help
```

## 3. Validasi Dependency Installer

```bash
bash install.sh --check
```

## 4. Coba Install ke User Scope

Default installer menyalin skill ke user scope Codex CLI:

```bash
bash install.sh
```

Target default:

```text
$HOME/.agents/skills
```

## 5. Build Release Artifact

```bash
make release
```

Artifact dibuat di `dist/` dengan checksum SHA256. Signature GPG dibuat bila `gpg` tersedia.

## 6. Langkah Berikutnya

- Gunakan [Run Locally](../how-to/run-locally.md) untuk prosedur lokal yang lebih spesifik.
- Gunakan [Commands](../reference/commands.md) sebagai lookup command.
- Baca [Architecture](../explanation/architecture.md) untuk memahami layout instalasi Linux.
