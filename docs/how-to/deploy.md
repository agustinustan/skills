# Deploy

Panduan ini menjelaskan alur release untuk mendistribusikan `ai-skills`.

## Prepare Release Metadata

1. Update `VERSION`.
2. Update `manifest.json`.
3. Update catatan release bila ada perubahan perilaku pengguna.

## Build Release Locally

```bash
make release
```

Output utama:

```text
dist/ai-skills-<version>-linux-<arch>.tar.gz
dist/ai-skills-<version>-linux-<arch>.tar.gz.sha256
dist/ai-skills-<version>-linux-<arch>.tar.gz.asc
```

File `.asc` hanya dibuat bila `gpg` tersedia.

## Publish GitHub Release

1. Buat tag semantic version, misalnya `v0.1.0`.
2. Push tag ke GitHub.
3. Upload tarball, checksum, dan signature ke GitHub Release.
4. Test install dari clone lokal.
5. Test install via curl-pipe dari `install.sh`.
6. Test upgrade dari versi sebelumnya.
7. Test rollback ke versi sebelumnya.

## Install From Release

```bash
curl -fsSL https://raw.githubusercontent.com/agustinus/skills/main/install.sh | APP_REPO=agustinus/skills VERSION=0.1.0 bash
```
