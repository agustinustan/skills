# Documentation

Dokumentasi repo ini mengikuti prinsip Diataxis: tutorial untuk belajar, how-to untuk menyelesaikan tugas, reference untuk lookup faktual, dan explanation untuk memahami desain serta tradeoff.

## Tutorials

- [Getting Started](tutorials/getting-started.md): walkthrough pertama untuk memahami repo dan mencoba instalasi lokal.

## How-To Guides

- [Run Locally](how-to/run-locally.md): menjalankan installer dan validasi lokal.
- [Test](how-to/test.md): menjalankan lint, build package, checksum, dan verifikasi release artifact.
- [Deploy](how-to/deploy.md): membuat dan menerbitkan release.
- [Troubleshoot](how-to/troubleshoot.md): diagnosis masalah umum saat install, package, dan release.

## Reference

- [API](reference/api.md): kontrak publik script dan entrypoint repo.
- [Configuration](reference/configuration.md): environment variable, path, dan konfigurasi install.
- [Commands](reference/commands.md): daftar command Makefile dan script publik.
- [Database Schema](reference/database-schema.md): status schema database repo.
- [OpenAI Codex CLI](reference/codex-cli.md): lokasi dan opsi instalasi skill untuk Codex CLI.
- [Pi Coding Agent](reference/pi-coding-agent.md): lokasi dan opsi instalasi skill untuk Pi Coding Agent.

## Explanation

- [Architecture](explanation/architecture.md): layout distribusi Linux dan prinsip installer.
- [Domain Model](explanation/domain-model.md): konsep domain dalam repo distribusi skill.
- [Deployment Workflow](explanation/deployment-workflow.md): strategi versioning, artifact, dan release.
- [Decisions](explanation/decisions.md): catatan keputusan arsitektur dan operasional.

## Placement Rules

- Tambahkan halaman baru ke kategori yang paling sesuai dengan kebutuhan pembaca.
- Update indeks ini saat menambah, memindahkan, atau menghapus dokumen.
- Gunakan `how-to/` untuk prosedur, `reference/` untuk lookup, dan `explanation/` untuk alasan desain.
