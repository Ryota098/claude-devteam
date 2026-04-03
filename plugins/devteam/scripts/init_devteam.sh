#!/bin/sh

set -eu

usage() {
  echo "Usage: $0 TARGET_DIR [--overwrite]" >&2
  exit 1
}

[ "$#" -ge 1 ] || usage

TARGET_DIR=$1
OVERWRITE=0

if [ "${2:-}" = "--overwrite" ]; then
  OVERWRITE=1
elif [ "$#" -gt 1 ]; then
  usage
fi

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TEMPLATE_DIR=$SCRIPT_DIR/../templates/.devteam
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
