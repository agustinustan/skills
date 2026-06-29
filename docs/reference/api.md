# API

Repo ini tidak mengekspos HTTP API atau library API. Kontrak publiknya adalah script shell, Makefile target, layout distribusi, dan struktur folder skill.

## Public Entrypoints

- `install.sh`: install, upgrade, dependency check, user-scope skill install, system-scope install, optional systemd registration.
- `upgrade.sh`: wrapper untuk `install.sh --upgrade`.
- `rollback.sh`: mengarahkan symlink `current` ke release sebelumnya.
- `uninstall.sh`: menghapus instalasi dan optional purge untuk config, data, dan log.
- `Makefile`: build, checksum, signature, verify, lint, dan cleanup.

## Skill Contract

Setiap skill yang akan didistribusikan berada di bawah `skills/` dan harus memiliki:

```text
skills/<skill-name>/SKILL.md
```

Folder tambahan seperti `references/`, `scripts/`, dan `agents/` bersifat opsional dan bergantung pada kebutuhan skill.

## Release Contract

Artifact release mengikuti pola:

```text
ai-skills-<version>-linux-<arch>.tar.gz
ai-skills-<version>-linux-<arch>.tar.gz.sha256
ai-skills-<version>-linux-<arch>.tar.gz.asc
```

`<arch>` saat ini dipetakan ke `amd64` atau `arm64`.
