APP_NAME ?= ai-skills
VERSION ?= $(shell sed -n '1p' VERSION)
DIST_DIR ?= dist
ARCH ?= $(shell uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
TARBALL := $(DIST_DIR)/$(APP_NAME)-$(VERSION)-linux-$(ARCH).tar.gz
RELEASE_FILES := install.sh uninstall.sh upgrade.sh rollback.sh manifest.json checksums.sha256 README.md LICENSE VERSION package.json bin lib config systemd scripts docs migrations skills

.PHONY: help lint package source-checksums checksums sign verify clean release

help:
	@printf '%s\n' "Targets:"
	@printf '%s\n' "  make package    Build release tarball"
	@printf '%s\n' "  make checksums  Generate SHA256 files"
	@printf '%s\n' "  make sign       Create GPG detached signature"
	@printf '%s\n' "  make verify     Verify checksum and GPG signature when present"
	@printf '%s\n' "  make release    package + checksums + optional GPG signing"
	@printf '%s\n' "  make clean      Remove dist artifacts"

lint:
	@shellcheck install.sh uninstall.sh upgrade.sh rollback.sh scripts/*.sh migrations/*.sh

package:
	@mkdir -p "$(DIST_DIR)"
	@tar --sort=name --owner=0 --group=0 --numeric-owner -czf "$(TARBALL)" $(RELEASE_FILES)
	@printf 'Created %s\n' "$(TARBALL)"

source-checksums:
	@sha256sum install.sh uninstall.sh upgrade.sh rollback.sh manifest.json package.json > checksums.sha256

checksums: source-checksums package
	@sha256sum "$(TARBALL)" > "$(TARBALL).sha256"
	@printf 'Created %s.sha256 and checksums.sha256\n' "$(TARBALL)"

sign: checksums
	@if command -v gpg >/dev/null 2>&1; then \
		gpg --armor --detach-sign "$(TARBALL)"; \
		printf 'Created %s.asc\n' "$(TARBALL)"; \
	else \
		printf 'gpg not found; skipping signature\n'; \
	fi

verify:
	@sha256sum -c "$(TARBALL).sha256"
	@if [ -f "$(TARBALL).asc" ]; then gpg --verify "$(TARBALL).asc" "$(TARBALL)"; fi

release: checksums sign

clean:
	@rm -rf "$(DIST_DIR)"
