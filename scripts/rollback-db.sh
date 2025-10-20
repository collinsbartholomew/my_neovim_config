#!/usr/bin/env bash
set -euo pipefail
BACKUP_DIR="$HOME/.config/nvim.backup.20251020-151229"

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Backup dir $BACKUP_DIR not found. Manual restore required."
  exit 1
fi

echo "Restoring backup from $BACKUP_DIR ..."
rsync -a --delete "$BACKUP_DIR/" "$HOME/.config/nvim/"

# Reset git to pre-setup commit if present
cd "$HOME/.config/nvim" || exit
if [ -d ".git" ]; then
  PRE_COMMIT_FILE=".git/refs/heads/pre-mern-db-backup"
  if [ -f "$PRE_COMMIT_FILE" ]; then
    PRE_HASH=$(cat "$PRE_COMMIT_FILE")
    git reset --hard "$PRE_HASH" || echo "Could not reset git to $PRE_HASH"
    echo "Git reset to $PRE_HASH"
  else
    echo "No pre-setup git ref recorded; please inspect the repo manually"
  fi
fi

echo "Restore complete."