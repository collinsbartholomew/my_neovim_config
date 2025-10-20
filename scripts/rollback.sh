#!/bin/sh
set -e
latest_backup=$(ls -dt $HOME/.config/nvim.backup.* | head -n1)
if [ -z "$latest_backup" ]; then
  echo "No backup found."
  exit 1
fi
cp -a "$latest_backup/." "$HOME/.config/nvim/"
echo "Restored ~/.config/nvim from $latest_backup"

