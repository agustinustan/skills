#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-ai-skills}"
VERSION="${VERSION:-}"
APP_REPO="${APP_REPO:-agustinus/skills}"
INSTALL_PREFIX="${INSTALL_PREFIX:-/opt/${APP_NAME}}"
CONFIG_DIR="${CONFIG_DIR:-/etc/${APP_NAME}}"
DATA_DIR="${DATA_DIR:-/var/lib/${APP_NAME}}"
LOG_DIR="${LOG_DIR:-/var/log/${APP_NAME}}"
BIN_DIR="${BIN_DIR:-/usr/local/bin}"
SERVICE_NAME="${SERVICE_NAME:-${APP_NAME}}"
SERVICE_USER="${SERVICE_USER:-${APP_NAME}}"
DRY_RUN=0
NO_START=0
NO_SYSTEMD=1
NON_INTERACTIVE=0
ACTION="install"
CODEX_INSTALL=1
CODEX_SCOPE="user"
CODEX_SKILLS_DIR="${CODEX_SKILLS_DIR:-}"
PI_INSTALL=0
PI_SCOPE="user"
PI_SKILLS_DIR="${PI_SKILLS_DIR:-}"

usage() {
  cat <<'USAGE'
install.sh - install ai-skills

Usage:
  sudo ./install.sh [options]
  curl -fsSL https://raw.githubusercontent.com/agustinustan/skills/main/install.sh | sudo bash

Options:
  --install            Install application (default)
  --upgrade            Install as upgrade, preserving config and data
  --check              Validate dependencies and exit
  --dry-run            Print actions without changing the system
  --prefix PATH        Install prefix (default: /opt/ai-skills)
  --codex-user         Install Codex skills to the invoking user's skill dir (default)
  --codex-system       Install Codex skills to /etc/codex/skills
  --codex-skills-dir PATH
                       Install Codex skills to a custom directory
  --no-codex           Skip Codex skill installation
  --pi-user            Install Pi Coding Agent skills to the invoking user's Pi skill dir
  --pi-system          Install Pi Coding Agent skills to /etc/pi/agent/skills
  --pi-skills-dir PATH Install Pi Coding Agent skills to a custom directory
  --pi-only            Install only Pi Coding Agent skills
  --no-pi              Skip Pi Coding Agent skill installation (default)
  --systemd            Register optional systemd unit
  --no-start           Do not start systemd service after install
  --no-systemd         Skip systemd unit registration (default)
  --non-interactive    Do not prompt
  -h, --help           Show help

Environment:
  APP_REPO             GitHub repo for curl-pipe install (default: agustinus/skills)
  VERSION              Release version to download; defaults to latest
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --install) ACTION="install" ;;
    --upgrade) ACTION="upgrade" ;;
    --check) ACTION="check" ;;
    --dry-run) DRY_RUN=1 ;;
    --prefix) shift; INSTALL_PREFIX="${1:?--prefix requires a path}" ;;
    --codex-user) CODEX_INSTALL=1; CODEX_SCOPE="user" ;;
    --codex-system) CODEX_INSTALL=1; CODEX_SCOPE="system" ;;
    --codex-skills-dir) shift; CODEX_SKILLS_DIR="${1:?--codex-skills-dir requires a path}" ;;
    --no-codex) CODEX_INSTALL=0 ;;
    --pi-user) PI_INSTALL=1; PI_SCOPE="user" ;;
    --pi-system) PI_INSTALL=1; PI_SCOPE="system" ;;
    --pi-skills-dir) shift; PI_INSTALL=1; PI_SKILLS_DIR="${1:?--pi-skills-dir requires a path}" ;;
    --pi-only) PI_INSTALL=1; CODEX_INSTALL=0 ;;
    --no-pi) PI_INSTALL=0 ;;
    --systemd) NO_SYSTEMD=0 ;;
    --no-start) NO_START=1 ;;
    --no-systemd) NO_SYSTEMD=1 ;;
    --non-interactive) NON_INTERACTIVE=1 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

run() {
  if [ "${DRY_RUN}" = "1" ]; then
    printf '[dry-run] %s\n' "$*"
    return 0
  fi
  "$@"
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

detect_arch() {
  case "$(uname -m)" in
    x86_64) printf '%s\n' "amd64" ;;
    aarch64|arm64) printf '%s\n' "arm64" ;;
    *) die "unsupported architecture: $(uname -m)" ;;
  esac
}

download_release_if_needed() {
  if [ -f "./manifest.json" ] && [ -d "./bin" ]; then
    return 0
  fi

  command -v curl >/dev/null 2>&1 || die "curl is required for remote install"
  command -v tar >/dev/null 2>&1 || die "tar is required for remote install"
  command -v sha256sum >/dev/null 2>&1 || die "sha256sum is required for remote install"

  arch="$(detect_arch)"
  if [ -z "${VERSION}" ]; then
    api_url="https://api.github.com/repos/${APP_REPO}/releases/latest"
    VERSION="$(curl -fsSL "${api_url}" | sed -n 's/.*"tag_name": *"v\{0,1\}\([^"]*\)".*/\1/p' | head -n 1)"
  fi
  [ -n "${VERSION}" ] || die "unable to resolve latest release version"

  artifact="${APP_NAME}-${VERSION}-linux-${arch}.tar.gz"
  base_url="https://github.com/${APP_REPO}/releases/download/v${VERSION}"
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "${tmp_dir}"' EXIT

  printf 'Downloading %s\n' "${artifact}"
  curl -fsSL "${base_url}/${artifact}" -o "${tmp_dir}/${artifact}"
  curl -fsSL "${base_url}/${artifact}.sha256" -o "${tmp_dir}/${artifact}.sha256"
  (cd "${tmp_dir}" && sha256sum -c "${artifact}.sha256")

  if curl -fsSL "${base_url}/${artifact}.asc" -o "${tmp_dir}/${artifact}.asc"; then
    if command -v gpg >/dev/null 2>&1; then
      gpg --verify "${tmp_dir}/${artifact}.asc" "${tmp_dir}/${artifact}"
    else
      die "gpg is required to verify ${artifact}.asc"
    fi
  fi

  tar -xzf "${tmp_dir}/${artifact}" -C "${tmp_dir}"
  cd "${tmp_dir}"
  remote_args=("--${ACTION}" "--prefix" "${INSTALL_PREFIX}")
  [ "${DRY_RUN}" = "1" ] && remote_args+=("--dry-run")
  [ "${NO_START}" = "1" ] && remote_args+=("--no-start")
  [ "${NO_SYSTEMD}" = "1" ] && remote_args+=("--no-systemd")
  [ "${NO_SYSTEMD}" = "0" ] && remote_args+=("--systemd")
  [ "${NON_INTERACTIVE}" = "1" ] && remote_args+=("--non-interactive")
  [ "${CODEX_INSTALL}" = "0" ] && remote_args+=("--no-codex")
  [ "${CODEX_SCOPE}" = "system" ] && remote_args+=("--codex-system")
  [ -n "${CODEX_SKILLS_DIR}" ] && remote_args+=("--codex-skills-dir" "${CODEX_SKILLS_DIR}")
  [ "${PI_INSTALL}" = "1" ] && remote_args+=("--pi-user")
  [ "${PI_SCOPE}" = "system" ] && remote_args+=("--pi-system")
  [ -n "${PI_SKILLS_DIR}" ] && remote_args+=("--pi-skills-dir" "${PI_SKILLS_DIR}")
  exec bash ./install.sh "${remote_args[@]}"
}

load_manifest_defaults() {
  if [ -z "${VERSION}" ] && [ -f VERSION ]; then
    VERSION="$(sed -n '1p' VERSION)"
  fi
  [ -n "${VERSION}" ] || VERSION="0.1.0"
}

validate_dependencies() {
  command -v uname >/dev/null 2>&1 || die "uname is required"
  command -v tar >/dev/null 2>&1 || die "tar is required"
  command -v sha256sum >/dev/null 2>&1 || die "sha256sum is required"
  command -v sed >/dev/null 2>&1 || die "sed is required"
  detect_arch >/dev/null
  if [ -r /etc/os-release ]; then
    os_pretty="$(sed -n 's/^PRETTY_NAME=//p' /etc/os-release | head -n 1 | tr -d '"')"
    printf 'Detected OS: %s\n' "${os_pretty:-unknown}"
  fi
  if [ "${CODEX_INSTALL}" = "1" ] && [ ! -d "skills" ]; then
    die "skills directory is required for Codex CLI support"
  fi
  if [ "${PI_INSTALL}" = "1" ] && [ ! -d "skills" ]; then
    die "skills directory is required for Pi Coding Agent support"
  fi
  if [ "${NO_SYSTEMD}" != "1" ] && ! command -v systemctl >/dev/null 2>&1; then
    printf '%s\n' "systemd not found; service registration will be skipped"
  fi
}

need_root() {
  if [ "${DRY_RUN}" = "1" ]; then
    return 0
  fi
  if can_install_without_root; then
    return 0
  fi
  if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    die "please run as root or with sudo"
  fi
}

can_install_without_root() {
  [ "${NO_SYSTEMD}" = "1" ] || return 1
  [ "${ACTION}" != "upgrade" ] || return 1
  [ "${EUID:-$(id -u)}" -ne 0 ] || return 1
  if [ "${CODEX_INSTALL}" = "1" ] && [ "${CODEX_SCOPE}" != "user" ]; then
    return 1
  fi
  if [ "${PI_INSTALL}" = "1" ] && [ "${PI_SCOPE}" != "user" ]; then
    return 1
  fi
  [ "${CODEX_INSTALL}" = "1" ] || [ "${PI_INSTALL}" = "1" ]
}

systemd_available() {
  [ "${NO_SYSTEMD}" != "1" ] && command -v systemctl >/dev/null 2>&1 && [ -d /etc/systemd/system ]
}

ensure_user() {
  if id "${SERVICE_USER}" >/dev/null 2>&1; then
    return 0
  fi
  if command -v useradd >/dev/null 2>&1; then
    run useradd --system --home "${DATA_DIR}" --shell /usr/sbin/nologin "${SERVICE_USER}"
  fi
}

install_config() {
  run mkdir -p "${CONFIG_DIR}"
  if [ -f "${CONFIG_DIR}/config.yaml" ]; then
    if ! cmp -s config/config.yaml.example "${CONFIG_DIR}/config.yaml.example" 2>/dev/null; then
      run cp config/config.yaml.example "${CONFIG_DIR}/config.yaml.new"
    fi
  else
    run cp config/config.yaml.example "${CONFIG_DIR}/config.yaml"
  fi
  run cp config/config.yaml.example "${CONFIG_DIR}/config.yaml.example"
}

migrate_config() {
  [ -f "${CONFIG_DIR}/config.yaml" ] || return 0
  backup="${CONFIG_DIR}/config.yaml.backup-$(date +%Y%m%d%H%M%S)"
  run cp "${CONFIG_DIR}/config.yaml" "${backup}"
  for migration in migrations/config-*.sh; do
    [ -f "${migration}" ] || continue
    run bash "${migration}" "${CONFIG_DIR}/config.yaml"
  done
}

install_release() {
  release_dir="${INSTALL_PREFIX}/releases/${VERSION}"
  run mkdir -p "${release_dir}" "${DATA_DIR}" "${LOG_DIR}"
  run cp -R bin lib scripts migrations docs skills "${release_dir}/"
  run cp manifest.json VERSION LICENSE README.md "${release_dir}/"
  run ln -sfn "${release_dir}" "${INSTALL_PREFIX}/current"
  run ln -sfn "${INSTALL_PREFIX}/current/bin/${APP_NAME}" "${BIN_DIR}/${APP_NAME}"
  run chmod +x "${release_dir}/bin/${APP_NAME}" "${release_dir}"/scripts/*.sh "${release_dir}"/migrations/*.sh
}

codex_user_home() {
  if [ -n "${CODEX_HOME_OVERRIDE:-}" ]; then
    printf '%s\n' "${CODEX_HOME_OVERRIDE}"
    return 0
  fi
  if [ -n "${SUDO_USER:-}" ] && [ "${SUDO_USER}" != "root" ] && command -v getent >/dev/null 2>&1; then
    getent passwd "${SUDO_USER}" | cut -d: -f6
    return 0
  fi
  printf '%s\n' "${HOME}"
}

resolve_codex_skills_dir() {
  if [ -n "${CODEX_SKILLS_DIR}" ]; then
    printf '%s\n' "${CODEX_SKILLS_DIR}"
  elif [ "${CODEX_SCOPE}" = "system" ]; then
    printf '%s\n' "/etc/codex/skills"
  else
    printf '%s\n' "$(codex_user_home)/.agents/skills"
  fi
}

install_codex_skills() {
  [ "${CODEX_INSTALL}" = "1" ] || return 0
  target_dir="$(resolve_codex_skills_dir)"
  install_skill_tree "${target_dir}" "Codex"
}

pi_user_home() {
  if [ -n "${PI_HOME_OVERRIDE:-}" ]; then
    printf '%s\n' "${PI_HOME_OVERRIDE}"
    return 0
  fi
  if [ -n "${SUDO_USER:-}" ] && [ "${SUDO_USER}" != "root" ] && command -v getent >/dev/null 2>&1; then
    getent passwd "${SUDO_USER}" | cut -d: -f6
    return 0
  fi
  printf '%s\n' "${HOME}"
}

resolve_pi_skills_dir() {
  if [ -n "${PI_SKILLS_DIR}" ]; then
    printf '%s\n' "${PI_SKILLS_DIR}"
  elif [ "${PI_SCOPE}" = "system" ]; then
    printf '%s\n' "/etc/pi/agent/skills"
  else
    printf '%s\n' "$(pi_user_home)/.pi/agent/skills"
  fi
}

install_pi_skills() {
  [ "${PI_INSTALL}" = "1" ] || return 0
  target_dir="$(resolve_pi_skills_dir)"
  install_skill_tree "${target_dir}" "Pi Coding Agent"
}

install_skill_tree() {
  target_dir="${1:?target directory required}"
  agent_label="${2:?agent label required}"
  run mkdir -p "${target_dir}"
  for skill_dir in skills/*; do
    [ -d "${skill_dir}" ] || continue
    [ -f "${skill_dir}/SKILL.md" ] || die "missing SKILL.md in ${skill_dir}"
    skill_name="$(basename "${skill_dir}")"
    run rm -rf "${target_dir}/${skill_name}.tmp"
    run cp -R "${skill_dir}" "${target_dir}/${skill_name}.tmp"
    run rm -rf "${target_dir}/${skill_name}.previous"
    if [ -e "${target_dir}/${skill_name}" ]; then
      run mv "${target_dir}/${skill_name}" "${target_dir}/${skill_name}.previous"
    fi
    run mv "${target_dir}/${skill_name}.tmp" "${target_dir}/${skill_name}"
  done
  printf '%s skills installed to %s\n' "${agent_label}" "${target_dir}"
}

install_systemd() {
  systemd_available || return 0
  run cp "systemd/${SERVICE_NAME}.service" "/etc/systemd/system/${SERVICE_NAME}.service"
  run systemctl daemon-reload
  run systemctl enable "${SERVICE_NAME}.service"
}

start_service() {
  systemd_available || return 0
  [ "${NO_START}" = "1" ] && return 0
  run systemctl restart "${SERVICE_NAME}.service"
}

main() {
  download_release_if_needed
  load_manifest_defaults
  validate_dependencies
  if [ "${ACTION}" = "check" ]; then
    printf '%s\n' "Dependency check passed"
    exit 0
  fi
  need_root
  [ -x scripts/preinstall.sh ] && run bash scripts/preinstall.sh
  if can_install_without_root; then
    install_codex_skills
    install_pi_skills
    [ -x scripts/postinstall.sh ] && run bash scripts/postinstall.sh
    printf '%s %s installed for local coding agents\n' "${APP_NAME}" "${VERSION}"
    exit 0
  fi
  if systemd_available; then
    run systemctl stop "${SERVICE_NAME}.service" || true
  fi
  ensure_user
  install_config
  if [ "${ACTION}" = "upgrade" ]; then
    migrate_config
  fi
  install_codex_skills
  install_pi_skills
  install_release
  install_systemd
  start_service
  [ -x scripts/postinstall.sh ] && run bash scripts/postinstall.sh
  printf '%s %s installed\n' "${APP_NAME}" "${VERSION}"
}

main "$@"
