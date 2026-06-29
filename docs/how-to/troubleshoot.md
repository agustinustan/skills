# Troubleshoot

Panduan ini mengumpulkan langkah diagnosis untuk masalah umum.

## `shellcheck` Not Found

Install `shellcheck` melalui toolchain host atau jalankan lint di environment yang sudah memilikinya.

```bash
make lint
```

## Unsupported Architecture

Installer mendukung arsitektur yang dipetakan dari:

- `x86_64` ke `amd64`
- `aarch64` atau `arm64` ke `arm64`

Jika `install.sh --check` gagal karena arsitektur, build release belum mendukung host tersebut.

## Remote Install Cannot Resolve Latest Version

Set `VERSION` secara eksplisit:

```bash
curl -fsSL https://raw.githubusercontent.com/agustinus/skills/main/install.sh | VERSION=0.1.0 bash
```

## GPG Verification Fails or Is Missing

Remote install akan memverifikasi `.asc` bila file signature tersedia. Jika signature tersedia tetapi `gpg` tidak ada, install dihentikan.

Install `gpg` atau publish release tanpa `.asc` bila signature belum dipakai.

## Skill Does Not Appear in Codex CLI

1. Pastikan folder skill berisi `SKILL.md`.
2. Pastikan skill terpasang di target yang dibaca Codex CLI.
3. Restart Codex CLI.
4. Jalankan `/skills` atau ketik `$` untuk melihat skill yang tersedia.

## Systemd Is Not Required

Skill Codex CLI dan Pi Coding Agent tidak membutuhkan systemd. Gunakan `--systemd` hanya jika repo ini nanti menyertakan daemon atau background service.
