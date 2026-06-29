#!/usr/bin/env bash

APP_NAME="${APP_NAME:-ai-skills}"
VERSION="${VERSION:-0.1.0}"
CONFIG_VERSION="${CONFIG_VERSION:-1.0}"
INSTALL_PREFIX="${INSTALL_PREFIX:-/opt/${APP_NAME}}"
CONFIG_DIR="${CONFIG_DIR:-/etc/${APP_NAME}}"
DATA_DIR="${DATA_DIR:-/var/lib/${APP_NAME}}"
LOG_DIR="${LOG_DIR:-/var/log/${APP_NAME}}"
BIN_DIR="${BIN_DIR:-/usr/local/bin}"
SERVICE_NAME="${SERVICE_NAME:-${APP_NAME}}"
SERVICE_USER="${SERVICE_USER:-${APP_NAME}}"
DRY_RUN="${DRY_RUN:-0}"
NO_START="${NO_START:-0}"
NO_SYSTEMD="${NO_SYSTEMD:-0}"
NON_INTERACTIVE="${NON_INTERACTIVE:-0}"

log() {
  printf '%s\n' "$*"
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

run() {
  if [ "${DRY_RUN}" = "1" ]; then
    printf '[dry-run] %s\n' "$*"
    return 0
  fi
  "$@"
}

need_root() {
  if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    die "please run as root or with sudo"
  fi
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || die "$1 is required"
}

detect_arch() {
  case "$(uname -m)" in
    x86_64) printf '%s\n' "amd64" ;;
    aarch64|arm64) printf '%s\n' "arm64" ;;
    *) die "unsupported architecture: $(uname -m)" ;;
  esac
}

detect_os() {
  if [ -r /etc/os-release ]; then
    os_pretty="$(sed -n 's/^PRETTY_NAME=//p' /etc/os-release | head -n 1 | tr -d '"')"
    log "Detected OS: ${os_pretty:-unknown}"
  else
    log "Detected OS: unknown"
  fi
}

systemd_available() {
  [ "${NO_SYSTEMD}" != "1" ] && command -v systemctl >/dev/null 2>&1 && [ -d /etc/systemd/system ]
}

stop_service() {
  if systemd_available && systemctl list-unit-files "${SERVICE_NAME}.service" >/dev/null 2>&1; then
    run systemctl stop "${SERVICE_NAME}.service" || true
  fi
}

start_service() {
  if systemd_available && [ "${NO_START}" != "1" ]; then
    run systemctl daemon-reload
    run systemctl enable "${SERVICE_NAME}.service"
    run systemctl restart "${SERVICE_NAME}.service"
  fi
}

current_version() {
  if [ -L "${INSTALL_PREFIX}/current" ]; then
    basename "$(readlink -f "${INSTALL_PREFIX}/current")"
  fi
}

timestamp() {
  date +%Y%m%d%H%M%S
}
