#!/bin/bash

# added-by-agent: ccpp-setup 20251020
# Rollback script for C/C++ Neovim integration

# Find the most recent backup
BACKUP_DIR=$(ls -dt ~/.config/nvim.backup.* | head -n1)

if [ -z "$BACKUP_DIR" ]; then
    echo "No backup directory found!"
    exit 1
fi

echo "Rolling back to backup: $BACKUP_DIR"

# Backup current state just in case
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
mv ~/.config/nvim ~/.config/nvim.pre-rollback.$TIMESTAMP

# Restore from backup
cp -r "$BACKUP_DIR" ~/.config/nvim

echo "Rollback complete. Previous config saved to ~/.config/nvim.pre-rollback.$TIMESTAMP"
