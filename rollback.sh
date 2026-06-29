#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-ai-skills}"
INSTALL_PREFIX="${INSTALL_PREFIX:-/opt/${APP_NAME}}"
SERVICE_NAME="${SERVICE_NAME:-${APP_NAME}}"
NO_START=0
NO_SYSTEMD=0
DRY_RUN=0

usage() {
  cat <<'USAGE'
rollback.sh - switch ai-skills current symlink to a previous release

Usage:
  sudo ./rollback.sh <version> [options]

Options:
  --dry-run        Print actions without changing the system
  --no-start       Do not start systemd service after rollback
  --no-systemd     Skip systemd actions
  -h, --help       Show help
USAGE
}

run() {
  if [ "${DRY_RUN}" = "1" ]; then
    printf '[dry-run] %s\n' "$*"
    return 0
  fi
  "$@"
}

systemd_available() {
  [ "${NO_SYSTEMD}" != "1" ] && command -v systemctl >/dev/null 2>&1 && [ -d /etc/systemd/system ]
}

version=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --no-start) NO_START=1 ;;
    --no-systemd) NO_SYSTEMD=1 ;;
    -h|--help) usage; exit 0 ;;
    -*)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
    *) version="$1" ;;
  esac
  shift
done

[ -n "${version}" ] || { usage >&2; exit 2; }
if [ "${DRY_RUN}" != "1" ] && [ "${EUID:-$(id -u)}" -ne 0 ]; then
  printf '%s\n' "Error: please run as root or with sudo" >&2
  exit 1
fi
[ -d "${INSTALL_PREFIX}/releases/${version}" ] || { printf 'Error: release not found: %s\n' "${version}" >&2; exit 1; }

if systemd_available; then
  run systemctl stop "${SERVICE_NAME}.service" || true
fi
run ln -sfn "${INSTALL_PREFIX}/releases/${version}" "${INSTALL_PREFIX}/current"
if systemd_available && [ "${NO_START}" != "1" ]; then
  run systemctl restart "${SERVICE_NAME}.service"
fi
printf 'Rolled back %s to %s\n' "${APP_NAME}" "${version}"
