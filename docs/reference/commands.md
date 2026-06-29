# Commands

## Make Targets

| Command | Purpose |
| --- | --- |
| `make help` | Menampilkan target Makefile. |
| `make lint` | Menjalankan `shellcheck` untuk script shell. |
| `make package` | Membuat tarball release di `dist/`. |
| `make source-checksums` | Memperbarui `checksums.sha256` untuk source files utama. |
| `make checksums` | Membuat source checksum, package, dan checksum tarball. |
| `make sign` | Membuat GPG detached signature bila `gpg` tersedia. |
| `make verify` | Memverifikasi checksum dan signature bila ada. |
| `make release` | Menjalankan checksum dan signing opsional. |
| `make clean` | Menghapus `dist/`. |

## Installer Commands

| Command | Purpose |
| --- | --- |
| `bash install.sh --check` | Validasi dependency dan struktur repo. |
| `bash install.sh` | Install skill Codex ke user scope. |
| `bash install.sh --dry-run` | Preview tindakan tanpa menulis perubahan. |
| `bash install.sh --codex-system` | Install skill Codex ke system scope. |
| `bash install.sh --codex-skills-dir PATH` | Install skill Codex ke target custom. |
| `bash install.sh --pi-user` | Install skill Pi ke user scope. |
| `bash install.sh --pi-only` | Install hanya skill Pi. |
| `bash install.sh --pi-skills-dir PATH` | Install skill Pi ke target custom. |
| `sudo bash install.sh --systemd` | Register optional systemd unit. |
| `sudo bash upgrade.sh --version VERSION` | Upgrade ke versi tertentu. |
| `sudo bash rollback.sh VERSION` | Rollback ke release tertentu. |
| `sudo bash uninstall.sh` | Uninstall aplikasi. |
| `sudo bash uninstall.sh --purge` | Uninstall dan hapus config, data, serta log. |
