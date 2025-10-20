#!/bin/bash
# Zig setup rollback script

BACKUP_DIR="$HOME/.config/nvim.backup.20251020"
NVIM_DIR="$HOME/.config/nvim"

if [ -d "$BACKUP_DIR" ]; then
    echo "Restoring Neovim configuration from backup..."
    rm -rf "$NVIM_DIR"
    cp -r "$BACKUP_DIR"/* "$NVIM_DIR/"
    echo "Backup restored successfully"
else
    echo "Backup directory not found at $BACKUP_DIR"
    exit 1
fi
