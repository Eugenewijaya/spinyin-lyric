#!/usr/bin/env sh
# One-line installer for Spinyin-lyric for Spotify (Spicetify Extension)
# Install:   curl -fsSL https://raw.githubusercontent.com/Eugenewijaya/spinyin-lyric/main/install.sh | sh
# Uninstall: curl -fsSL https://raw.githubusercontent.com/Eugenewijaya/spinyin-lyric/main/install.sh | sh -s -- --uninstall

set -eu

REPO_RAW_BASE="https://raw.githubusercontent.com/Eugenewijaya/spinyin-lyric/main"
EXTENSION_FILE="spinyin-lyric.js"
LEGACY_FILE="mandarinPinyin.js"
UNINSTALL=0

for arg in "$@"; do
  case "$arg" in
    --uninstall|-u)
      UNINSTALL=1
      ;;
    --help|-h)
      printf 'Usage: install.sh [--uninstall]\n'
      exit 0
      ;;
    *)
      printf '[!] Unknown option: %s\n' "$arg" >&2
      printf '    Usage: install.sh [--uninstall]\n' >&2
      exit 1
      ;;
  esac
done

if [ "${SPINYIN_UNINSTALL:-0}" = "1" ]; then
  UNINSTALL=1
fi

printf '\n'
printf '  Spinyin-lyric for Spotify (v2.0.0)\n'
printf '  Standalone Liquid Glass & Offline Mandarin Pinyin Lyrics\n'
printf '\n'

# 1. Verify Spicetify CLI is installed
if ! command -v spicetify >/dev/null 2>&1; then
  printf '[!] Spicetify CLI was not found on this machine.\n' >&2
  printf '    Install Spicetify first:\n' >&2
  printf '    curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh\n' >&2
  exit 1
fi

# 2. Resolve exact Spicetify Extensions directory dynamically
CONFIG_PATH="$(spicetify -c 2>/dev/null | tr -d '\r\n' || true)"
if [ -z "$CONFIG_PATH" ]; then
  CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/spicetify/config-xpui.ini"
fi

SPICETIFY_DIR="$(dirname "$CONFIG_PATH")"
EXT_DIR="$SPICETIFY_DIR/Extensions"
mkdir -p "$EXT_DIR"
TARGET_PATH="$EXT_DIR/$EXTENSION_FILE"

# Handle uninstall mode
if [ "$UNINSTALL" -eq 1 ]; then
  printf '[*] Removing %s...\n' "$EXTENSION_FILE"
  spicetify config extensions "${EXTENSION_FILE}-" >/dev/null 2>&1 || true
  if [ -f "$TARGET_PATH" ]; then
    rm -f "$TARGET_PATH"
  fi
  printf '[*] Applying Spicetify changes...\n'
  spicetify apply
  printf '[+] Spinyin-lyric for Spotify has been uninstalled.\n\n'
  exit 0
fi

# 3. Verify curl is available
if ! command -v curl >/dev/null 2>&1; then
  printf '[!] curl is required to download %s.\n' "$EXTENSION_FILE" >&2
  exit 1
fi

# 4. Download latest spinyin-lyric.js directly into Spicetify Extensions
DOWNLOAD_URL="$REPO_RAW_BASE/$EXTENSION_FILE"
TMP_PATH="${TARGET_PATH}.tmp.$$"

cleanup() {
  if [ -f "$TMP_PATH" ]; then
    rm -f "$TMP_PATH"
  fi
}
trap cleanup EXIT INT TERM

printf '[*] Downloading %s...\n' "$EXTENSION_FILE"
if ! curl -fsSL "$DOWNLOAD_URL" -o "$TMP_PATH"; then
  printf '[!] Download failed from %s\n' "$DOWNLOAD_URL" >&2
  exit 1
fi

FILE_SIZE="$(wc -c < "$TMP_PATH" | tr -d '[:space:]')"
if [ -z "$FILE_SIZE" ] || [ "$FILE_SIZE" -lt 10000 ]; then
  printf '[!] Downloaded file appears incomplete (%s bytes).\n' "${FILE_SIZE:-0}" >&2
  exit 1
fi

mv -f "$TMP_PATH" "$TARGET_PATH"

# 5. Clean up legacy filename if present & register spinyin-lyric.js
if [ -f "$CONFIG_PATH" ] && grep -Fq "$LEGACY_FILE" "$CONFIG_PATH"; then
  spicetify config extensions "${LEGACY_FILE}-" >/dev/null 2>&1 || true
fi
spicetify config extensions "$EXTENSION_FILE" >/dev/null

# 6. Apply to Spotify
printf '[*] Applying to Spotify via Spicetify...\n'
spicetify apply

printf '\n'
printf '[+] Spinyin-lyric for Spotify installed successfully!\n'
printf '    Click the Spinyin Lyrics button on the Spotify playbar to open the Liquid Glass stage.\n'
printf '    Website: https://eugenewijaya.github.io/spinyin-lyric/\n'
printf '    Repo:    https://github.com/Eugenewijaya/spinyin-lyric\n'
printf '\n'
