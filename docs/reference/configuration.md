# Configuration

Halaman ini mencatat konfigurasi yang dibaca oleh script publik.

## Environment Variables

| Variable | Default | Used By | Purpose |
| --- | --- | --- | --- |
| `APP_NAME` | `ai-skills` | `install.sh`, `uninstall.sh`, `Makefile` | Nama aplikasi dan prefix artifact. |
| `VERSION` | file `VERSION` atau latest release | `install.sh`, `upgrade.sh`, `Makefile` | Versi release yang diinstall atau dibangun. |
| `APP_REPO` | `agustinus/skills` | `install.sh` | Repository GitHub untuk remote install. |
| `INSTALL_PREFIX` | `/opt/ai-skills` | `install.sh`, `uninstall.sh` | Root instalasi system. |
| `CONFIG_DIR` | `/etc/ai-skills` | `install.sh`, `uninstall.sh` | Lokasi konfigurasi user. |
| `DATA_DIR` | `/var/lib/ai-skills` | `install.sh`, `uninstall.sh` | Lokasi data aplikasi. |
| `LOG_DIR` | `/var/log/ai-skills` | `install.sh`, `uninstall.sh` | Lokasi log aplikasi. |
| `BIN_DIR` | `/usr/local/bin` | `install.sh`, `uninstall.sh` | Lokasi symlink command. |
| `SERVICE_NAME` | `ai-skills` | `install.sh`, `uninstall.sh` | Nama unit systemd. |
| `SERVICE_USER` | `ai-skills` | `install.sh` | User service untuk mode systemd. |
| `CODEX_SKILLS_DIR` | empty | `install.sh` | Override target install skill Codex. |
| `PI_SKILLS_DIR` | empty | `install.sh` | Override target install skill Pi Coding Agent. |

## Default Install Paths

Codex CLI user scope:

```text
$HOME/.agents/skills
```

Codex CLI system scope:

```text
/etc/codex/skills
```

Pi Coding Agent user scope:

```text
$HOME/.pi/agent/skills
```

Pi Coding Agent system scope:

```text
/etc/pi/agent/skills
```
