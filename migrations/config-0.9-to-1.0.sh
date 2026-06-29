#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${1:?usage: config-0.9-to-1.0.sh <config-file>}"

if ! grep -q '^config_version:[[:space:]]*"\{0,1\}0\.9"\{0,1\}' "${CONFIG_FILE}"; then
  exit 0
fi

if grep -q '^config_version:' "${CONFIG_FILE}"; then
  sed -i 's/^config_version:.*/config_version: "1.0"/' "${CONFIG_FILE}"
else
  printf '%s\n' 'config_version: "1.0"' >> "${CONFIG_FILE}"
fi
