#!/usr/bin/env bash
set -euo pipefail

REPO="tihtai/Paperclip-project"
VERSION="latest"
INSTALL_DIR="$(pwd)/paperclip-project"
TMP_DIR=""

usage() {
  cat <<USAGE
Install Paperclip-project from GitHub Releases.

Usage:
  $0 [--version vX.Y.Z] [--dir /install/path]

Options:
  --version   Release tag to install (default: latest)
  --dir       Install directory (default: ./paperclip-project)
  --repo      Override repo (default: tihtai/Paperclip-project)
  -h, --help  Show help
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      VERSION="$2"
      shift 2
      ;;
    --dir)
      INSTALL_DIR="$2"
      shift 2
      ;;
    --repo)
      REPO="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      usage
      exit 1
      ;;
  esac
done

TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

api_url="https://api.github.com/repos/${REPO}/releases"
if [[ "$VERSION" == "latest" ]]; then
  meta_url="${api_url}/latest"
else
  meta_url="${api_url}/tags/${VERSION}"
fi

echo "Fetching release metadata: $meta_url"
release_json="$(curl -fsSL "$meta_url")"

zip_url="$(printf '%s' "$release_json" | grep -Eo 'https://[^\"]+paperclip-project-v[^\"]+\.zip' | head -n1 || true)"
if [[ -z "$zip_url" ]]; then
  zip_url="$(printf '%s' "$release_json" | grep -Eo 'https://api.github.com/repos/[^\"]+/zipball/[^\"]+' | head -n1 || true)"
fi

if [[ -z "$zip_url" ]]; then
  echo "Could not determine downloadable ZIP asset for release" >&2
  exit 1
fi

zip_file="$TMP_DIR/release.zip"
echo "Downloading: $zip_url"
curl -fsSL "$zip_url" -o "$zip_file"

rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

if unzip -Z1 "$zip_file" | head -n1 | grep -q '/'; then
  unzip -q "$zip_file" -d "$TMP_DIR/unzip"
  top_dir="$(find "$TMP_DIR/unzip" -mindepth 1 -maxdepth 1 -type d | head -n1)"
  cp -R "$top_dir"/. "$INSTALL_DIR"/
else
  unzip -q "$zip_file" -d "$INSTALL_DIR"
fi

echo "Installed ${REPO}@${VERSION} to ${INSTALL_DIR}"
