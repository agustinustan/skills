# Domain Model

Repo ini mendistribusikan skill AI assistant sebagai artifact release yang dapat dipasang ke beberapa agent runtime.

## Core Concepts

| Concept | Meaning |
| --- | --- |
| Skill | Folder di bawah `skills/` yang memiliki `SKILL.md` sebagai entrypoint instruksi. |
| Agent Runtime | Aplikasi yang membaca skill, seperti OpenAI Codex CLI atau Pi Coding Agent. |
| Installer | Script yang menyalin skill dan optional runtime files ke lokasi target. |
| Release | Snapshot versioned yang dikemas sebagai tarball dengan checksum dan optional signature. |
| Install Scope | Target user, system, atau custom directory untuk folder skill. |
| Migration | Script perubahan konfigurasi antar versi. |

## Skill Distribution Flow

1. Developer menambahkan atau mengubah folder di `skills/`.
2. Release dibuat melalui Makefile.
3. User menjalankan installer dari clone lokal atau GitHub release.
4. Installer menyalin skill ke target runtime.
5. Runtime membaca `SKILL.md` dari folder skill yang sudah dipasang.

## Boundaries

Repo ini tidak menjalankan model AI, tidak menyimpan state percakapan, dan tidak menyediakan API server. Tanggung jawab repo terbatas pada packaging, install, upgrade, rollback, uninstall, dan dokumentasi distribusi skill.
