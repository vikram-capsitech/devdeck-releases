#!/bin/sh
# DevDeck for macOS: install or update with one line.
#
#   curl -fsSL https://raw.githubusercontent.com/vikram-capsitech/devdeck-releases/main/install.sh | sh
#
# Downloads the newest DevDeck for this Mac (Apple Silicon or Intel) from GitHub, checks its SHA-512
# checksum against the release's latest-mac.yml, and puts DevDeck.app in /Applications (or
# ~/Applications if that isn't writable). Running it again updates DevDeck; your settings are kept.
# Published as install.sh in github.com/vikram-capsitech/devdeck-releases (source: scripts/install-mac.sh).
set -eu

REPO="vikram-capsitech/devdeck-releases"
BASE="https://github.com/$REPO/releases/latest/download"

say() { printf '%s\n' "$*"; }
fail() { printf '\n✗ %s\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || fail "This installer is for macOS. On Windows, get DevDeck from the Microsoft Store or https://github.com/$REPO/releases/latest"

# macOS 12 or newer (what DevDeck's Electron version needs)
major=$(sw_vers -productVersion | cut -d. -f1)
[ "$major" -ge 12 ] || fail "DevDeck needs macOS 12 Monterey or newer (this Mac has $(sw_vers -productVersion))."

# Apple Silicon or Intel (a Terminal running under Rosetta still gets the Apple Silicon build)
arch=x64
if [ "$(uname -m)" = "arm64" ] || [ "$(sysctl -in sysctl.proc_translated 2>/dev/null || echo 0)" = "1" ]; then arch=arm64; fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

say "▶ Finding the newest DevDeck…"
curl -fsSL "$BASE/latest-mac.yml" -o "$tmp/latest.yml" || fail "Couldn't reach GitHub, or no Mac version has been published yet."
version=$(awk '/^version:/ { print $2; exit }' "$tmp/latest.yml")
file=$(awk -v a="-$arch.zip" '/^[[:space:]]*- url:/ { u=$3 } u != "" && index(u, a) { print u; exit }' "$tmp/latest.yml")
sha=$(awk -v f="$file" '/^[[:space:]]*- url:/ { u=$3 } u == f && /sha512:/ { print $2; exit }' "$tmp/latest.yml")
[ -n "$version" ] && [ -n "$file" ] && [ -n "$sha" ] || fail "The newest release has no $arch Mac download yet."

say "▶ Downloading DevDeck $version ($([ "$arch" = arm64 ] && echo 'Apple Silicon' || echo 'Intel'))…"
curl -fL --progress-bar "$BASE/$file" -o "$tmp/devdeck.zip" || fail "The download failed. Try again in a minute."

say "▶ Checking the download…"
got=$(openssl dgst -sha512 -binary "$tmp/devdeck.zip" | base64 | tr -d '\n')
[ "$got" = "$sha" ] || fail "The download doesn't match the published checksum, so it wasn't installed. Try again; if it keeps happening, report it at https://github.com/$REPO/issues"

ditto -x -k "$tmp/devdeck.zip" "$tmp/app"
[ -d "$tmp/app/DevDeck.app" ] || fail "The download didn't contain DevDeck.app."

dest="/Applications"
[ -w "$dest" ] || { dest="$HOME/Applications"; mkdir -p "$dest"; }

# Close a running DevDeck first (it saves its settings on quit)
if pgrep -x DevDeck >/dev/null 2>&1; then
  say "▶ Closing DevDeck…"
  osascript -e 'quit app "DevDeck"' >/dev/null 2>&1 || true
  i=0; while pgrep -x DevDeck >/dev/null 2>&1 && [ $i -lt 20 ]; do sleep 0.5; i=$((i+1)); done
fi

say "▶ Installing into $dest…"
rm -rf "$dest/DevDeck.app.old"
[ -d "$dest/DevDeck.app" ] && mv "$dest/DevDeck.app" "$dest/DevDeck.app.old"
if ditto "$tmp/app/DevDeck.app" "$dest/DevDeck.app"; then
  rm -rf "$dest/DevDeck.app.old"
else
  [ -d "$dest/DevDeck.app.old" ] && mv "$dest/DevDeck.app.old" "$dest/DevDeck.app"
  fail "Couldn't copy DevDeck into $dest."
fi
# Downloaded with curl, so macOS hasn't marked it as "from the internet"; clear it anyway.
xattr -dr com.apple.quarantine "$dest/DevDeck.app" 2>/dev/null || true

say ""
say "✓ DevDeck $version is installed in $dest. Opening it…"
say "  It updates itself from now on (or run this command again)."
open "$dest/DevDeck.app"
