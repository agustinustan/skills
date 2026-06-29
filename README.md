# AI Skills

Repository ini adalah template distribusi tarball untuk skill-skill AI assistant, dengan dukungan awal untuk OpenAI Codex CLI dan Pi Coding Agent. Struktur ini memisahkan source skill, installer, metadata release, migration, dan dokumentasi agar aman untuk dikembangkan menjadi distribusi production.

## Install

Dari GitHub release untuk OpenAI Codex CLI user install:

```bash
curl -fsSL https://raw.githubusercontent.com/agustinustan/skills/main/install.sh | bash
```

Dari clone lokal:

```bash
git clone https://github.com/agustinustan/skills.git
cd skills
bash install.sh
```

Installer idempotent. Menjalankannya berkali-kali akan memastikan skill di target Codex CLI berada pada state yang benar tanpa merusak instalasi sebelumnya.

Codex CLI membaca skill dari beberapa lokasi. Installer ini default ke user scope:

```text
$HOME/.agents/skills
```

Untuk install machine-wide:

```bash
sudo bash install.sh --codex-system
```

Untuk Pi Coding Agent:

```bash
bash install.sh --pi-user
bash install.sh --pi-only
bash install.sh --pi-skills-dir "$HOME/.pi/agent/skills"
sudo bash install.sh --pi-system
```

## Layout Instalasi

```text
/opt/ai-skills/releases/<version>/  aplikasi versi tertentu
/opt/ai-skills/current              symlink ke release aktif
/etc/ai-skills/                     konfigurasi user
/var/lib/ai-skills/                 data aplikasi
/var/log/ai-skills/                 log aplikasi
/usr/local/bin/ai-skills            symlink command
/etc/systemd/system/ai-skills.service
```

## Perintah Installer

```bash
sudo ./install.sh --check
bash ./install.sh --install
bash ./install.sh --dry-run
bash ./install.sh --codex-skills-dir "$HOME/.agents/skills"
sudo ./install.sh --codex-system
bash ./install.sh --pi-user
bash ./install.sh --pi-only
bash ./install.sh --pi-skills-dir "$HOME/.pi/agent/skills"
sudo ./install.sh --systemd --prefix /opt/ai-skills
bash ./install.sh --non-interactive
sudo ./upgrade.sh
sudo ./rollback.sh 0.1.0
sudo ./uninstall.sh
sudo ./uninstall.sh --purge
```

Mode curl-pipe menggunakan GitHub release. Override repository atau versi:

```bash
curl -fsSL https://raw.githubusercontent.com/agustinustan/skills/main/install.sh | APP_REPO=agustinustan/skills VERSION=0.1.0 bash
```

Systemd tidak diperlukan untuk skill Codex CLI. Gunakan `--systemd` hanya jika repo ini nanti menyertakan daemon/background service.

## Upgrade dan Rollback

Upgrade tidak overwrite folder aktif. Release baru ditempatkan di:

```text
/opt/ai-skills/releases/<version>
```

Lalu `/opt/ai-skills/current` diarahkan ke versi baru. Rollback hanya mengubah symlink `current` ke release sebelumnya dan restart service bila systemd aktif.

## Migrasi Konfigurasi

Konfigurasi user berada di `/etc/ai-skills/config.yaml` dan tidak dioverwrite saat upgrade. Upgrade membuat backup:

```text
/etc/ai-skills/config.yaml.backup-YYYYMMDDHHMMSS
/etc/ai-skills/config.yaml.new
```

Script migration berada di `migrations/config-<from>-to-<to>.sh`.

## Release

Gunakan semantic versioning `MAJOR.MINOR.PATCH`.

```bash
make package
make checksums
make sign
make release
```

GitHub Actions akan membuat tarball dan SHA256 saat tag `v*.*.*` dipush. Untuk GPG signing otomatis, isi secret repository `GPG_PRIVATE_KEY`.

Artifact release:

```text
dist/ai-skills-0.1.0-linux-amd64.tar.gz
dist/ai-skills-0.1.0-linux-amd64.tar.gz.sha256
dist/ai-skills-0.1.0-linux-amd64.tar.gz.asc
```

SHA256 memvalidasi integritas file. GPG detached signature memvalidasi publisher.

## CLI

CLI mengikuti prinsip utama dari Command Line Interface Guidelines:

- `--help` tersedia pada semua script publik.
- Perintah aman memiliki mode `--check` dan `--dry-run`.
- Mode non-interactive tersedia untuk automation.
- Output jelas, singkat, dan exit code bermakna.
- Konfigurasi user tidak dioverwrite tanpa tindakan eksplisit.

## Development

```bash
make help
make package
make release
```
