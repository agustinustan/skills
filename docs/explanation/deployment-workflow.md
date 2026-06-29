# Release Strategy

## Versioning

Gunakan semantic versioning:

```text
MAJOR.MINOR.PATCH
```

- `MAJOR`: breaking change pada CLI, format konfigurasi, atau layout data.
- `MINOR`: fitur baru yang backward compatible.
- `PATCH`: bug fix tanpa perubahan kontrak.

## Artifact Naming

```text
ai-skills-<version>-linux-amd64.tar.gz
ai-skills-<version>-linux-arm64.tar.gz
ai-skills-<version>-linux-amd64.tar.gz.sha256
ai-skills-<version>-linux-arm64.tar.gz.sha256
ai-skills-<version>-linux-amd64.tar.gz.asc
ai-skills-<version>-linux-arm64.tar.gz.asc
```

## Release Checklist

1. Update `VERSION` dan `manifest.json`.
2. Update release notes.
3. Jalankan `make release`.
4. Upload tarball, `.sha256`, dan `.asc` ke GitHub Release.
5. Test install via clone lokal.
6. Test install via curl-pipe dari raw `install.sh`.
7. Test upgrade dari versi sebelumnya.
8. Test rollback ke versi sebelumnya.
