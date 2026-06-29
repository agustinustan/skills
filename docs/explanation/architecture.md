# Linux Distribution Practices

Installer mengikuti layout berikut:

```text
/opt/ai-skills       aplikasi dan release versioned
/etc/ai-skills       konfigurasi user
/var/lib/ai-skills   data aplikasi
/var/log/ai-skills   log aplikasi
/usr/local/bin       symlink command
```

Prinsip:

- Installer idempotent dan aman dijalankan berulang kali.
- Upgrade membuat release directory baru, lalu mengubah symlink atomik.
- Konfigurasi user tidak dioverwrite.
- Upgrade membuat backup konfigurasi sebelum migrasi.
- Rollback tidak menghapus release baru.
- Uninstall biasa mempertahankan config, data, dan log.
- Purge menghapus config, data, dan log setelah diminta eksplisit.
- Dependency, OS, arsitektur, permission, checksum, dan signature divalidasi.
