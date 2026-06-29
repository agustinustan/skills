#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
upgrade.sh - upgrade ai-skills to a new release

Usage:
  sudo ./upgrade.sh [options]

Options:
  --version VERSION     Version to install
  --dry-run             Print actions without changing the system
  --no-start            Do not start systemd service after upgrade
  --no-systemd          Skip systemd actions
  --non-interactive     Do not prompt
  -h, --help            Show help
USAGE
}

args=(--upgrade)
while [ "$#" -gt 0 ]; do
  case "$1" in
    --version) shift; export VERSION="${1:?--version requires a value}" ;;
    --dry-run|--no-start|--no-systemd|--non-interactive) args+=("$1") ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

exec bash ./install.sh "${args[@]}"
