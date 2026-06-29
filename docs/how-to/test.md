# Test

Panduan ini menjelaskan pemeriksaan lokal yang tersedia saat ini.

## Run Shell Lint

```bash
make lint
```

Target ini menjalankan `shellcheck` untuk script publik, script migrasi, dan script pendukung.

## Build Package

```bash
make package
```

Package dibuat di `dist/` menggunakan metadata dari `VERSION` dan arsitektur host.

## Generate Checksums

```bash
make checksums
```

Target ini memperbarui `checksums.sha256`, membuat package, lalu membuat checksum untuk tarball.

## Verify Release Artifact

```bash
make verify
```

Target ini memverifikasi checksum tarball dan signature GPG bila file `.asc` tersedia.

## Full Release Check

```bash
make release
```

Target ini menjalankan checksum dan signing opsional.
