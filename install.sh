
#!/usr/bin/env bash
set -Eeuo pipefail

REPO="https://github.com/apkclub051/PenguTunnel"
ZIP_URL="$REPO/raw/refs/heads/main/PenguTunnel-v5.0.4-Offline.zip"

if [[ $EUID -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

for cmd in curl sha256sum unzip; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing dependency: $cmd"
    exit 1
  fi
done

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

curl -fL --retry 2 "$ZIP_URL" -o "$WORK/PenguTunnel.zip"

unzip -q "$WORK/PenguTunnel.zip" -d "$WORK"

INSTALLER="$WORK/PenguTunnel-5.0.4-Offline/install.sh"

if [[ ! -f "$INSTALLER" ||
      ! -f "$WORK/PenguTunnel-5.0.4-Offline/pengutunnel" ]]; then
  echo "Required files are missing."
  exit 1
fi

bash "$INSTALLER"
