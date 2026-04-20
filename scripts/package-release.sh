#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION_INPUT="${1:-}"
VERSION_FILE="$ROOT_DIR/VERSION"

if [[ -n "$VERSION_INPUT" ]]; then
  VERSION="$VERSION_INPUT"
elif [[ -f "$VERSION_FILE" ]]; then
  VERSION="v$(tr -d '[:space:]' < "$VERSION_FILE")"
else
  echo "Missing VERSION file and no version argument provided" >&2
  exit 1
fi

if [[ "$VERSION" != v* ]]; then
  VERSION="v$VERSION"
fi

OUT_DIR="$ROOT_DIR/release-build"
ZIP_NAME="paperclip-project-${VERSION}.zip"
ZIP_PATH="$OUT_DIR/$ZIP_NAME"

mkdir -p "$OUT_DIR"
rm -f "$ZIP_PATH"

(
  cd "$ROOT_DIR"
  # Archive tracked files only for reproducible release packages.
  git archive --format=zip --output "$ZIP_PATH" HEAD
)

echo "$ZIP_PATH"
