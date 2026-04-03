#!/bin/sh

set -eu

usage() {
  echo "Usage: $0 [TARGET_DIR] [--overwrite]" >&2
  exit 1
}

TARGET_DIR="."
OVERWRITE=0

for arg in "$@"; do
  case "$arg" in
    --overwrite)
      OVERWRITE=1
      ;;
    *)
      if [ "$TARGET_DIR" = "." ]; then
        TARGET_DIR=$arg
      else
        usage
      fi
      ;;
  esac
done

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
TEMPLATE_DIR=$REPO_ROOT/plugins/devteam/templates/.devteam
DEST_DIR=$TARGET_DIR/.devteam

[ -d "$TEMPLATE_DIR" ] || {
  echo "Template directory not found: $TEMPLATE_DIR" >&2
  exit 1
}

mkdir -p "$DEST_DIR"

find "$TEMPLATE_DIR" -type d | while IFS= read -r dir; do
  rel=${dir#"$TEMPLATE_DIR"/}
  [ "$dir" = "$TEMPLATE_DIR" ] && rel=""
  mkdir -p "$DEST_DIR/$rel"
done

find "$TEMPLATE_DIR" -type f | while IFS= read -r file; do
  rel=${file#"$TEMPLATE_DIR"/}
  dest=$DEST_DIR/$rel

  if [ -f "$dest" ] && [ "$OVERWRITE" -ne 1 ]; then
    continue
  fi

  cp "$file" "$dest"
done

echo "Initialized $DEST_DIR from $TEMPLATE_DIR"
