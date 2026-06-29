#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-ai-skills}"
INSTALL_PREFIX="${INSTALL_PREFIX:-/opt/${APP_NAME}}"
CONFIG_DIR="${CONFIG_DIR:-/etc/${APP_NAME}}"
DATA_DIR="${DATA_DIR:-/var/lib/${APP_NAME}}"
LOG_DIR="${LOG_DIR:-/var/log/${APP_NAME}}"
BIN_DIR="${BIN_DIR:-/usr/local/bin}"
SERVICE_NAME="${SERVICE_NAME:-${APP_NAME}}"
DRY_RUN=0
PURGE=0
NON_INTERACTIVE=0

usage() {
  cat <<'USAGE'
uninstall.sh - remove ai-skills

Usage:
  sudo ./uninstall.sh [options]

Options:
  --purge             Remove app, service, config, data, and logs
  --dry-run           Print actions without changing the system
  --non-interactive   Do not prompt
  -h, --help          Show help
USAGE
}

run() {
  if [ "${DRY_RUN}" = "1" ]; then
    printf '[dry-run] %s\n' "$*"
    return 0
  fi
  "$@"
}

confirm_purge() {
  [ "${PURGE}" = "1" ] || return 0
  [ "${NON_INTERACTIVE}" = "1" ] && return 0
  printf 'Purge will remove %s, %s, and %s. Continue? [y/N] ' "${CONFIG_DIR}" "${DATA_DIR}" "${LOG_DIR}"
  read -r answer
  case "${answer}" in
    y|Y|yes|YES) ;;
    *) printf '%s\n' "Cancelled"; exit 1 ;;
  esac
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --purge) PURGE=1 ;;
    --dry-run) DRY_RUN=1 ;;
    --non-interactive) NON_INTERACTIVE=1 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

if [ "${DRY_RUN}" != "1" ] && [ "${EUID:-$(id -u)}" -ne 0 ]; then
  printf '%s\n' "Error: please run as root or with sudo" >&2
  exit 1
fi
confirm_purge

if [ -x "${INSTALL_PREFIX}/current/scripts/preuninstall.sh" ]; then
  run bash "${INSTALL_PREFIX}/current/scripts/preuninstall.sh"
fi
if command -v systemctl >/dev/null 2>&1; then
  run systemctl stop "${SERVICE_NAME}.service" || true
  run systemctl disable "${SERVICE_NAME}.service" || true
fi
run rm -f "/etc/systemd/system/${SERVICE_NAME}.service"
if command -v systemctl >/dev/null 2>&1; then
  run systemctl daemon-reload
fi
run rm -f "${BIN_DIR}/${APP_NAME}"
run rm -rf "${INSTALL_PREFIX}"

if [ "${PURGE}" = "1" ]; then
  run rm -rf "${CONFIG_DIR}" "${DATA_DIR}" "${LOG_DIR}"
fi

if [ -x scripts/postuninstall.sh ]; then
  run bash scripts/postuninstall.sh
fi
printf '%s uninstalled\n' "${APP_NAME}"
