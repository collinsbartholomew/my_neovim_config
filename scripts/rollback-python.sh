#!/bin/bash

# Python setup rollback script
TIMESTAMP="20251020-194018"
BACKUP_DIR="/home/collins/.config/nvim.backup.$TIMESTAMP"

echo "=== Python Setup Rollback Script ==="

if [ -d "$BACKUP_DIR" ]; then
    echo "Found backup directory: $BACKUP_DIR"
    echo "This will restore your Neovim configuration to its state before the Python setup."
    echo ""
    echo "Files to be restored:"
    ls -la "$BACKUP_DIR"
    echo ""
    read -p "Do you want to proceed with the rollback? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Rolling back to backup..."
        # Remove the newly created files/directories
        rm -rf /home/collins/.config/nvim/lua/python
        rm -f /home/collins/.config/nvim/lua/ui/ui.lua
        
        # Restore from backup
        cp -r "$BACKUP_DIR"/* /home/collins/.config/nvim/
        
        # Check if we have a git backup
        if [ -f "/home/collins/.config/nvim/.git/refs/heads/pre-python-setup-backup" ]; then
            echo "Git backup found. You can also restore using:"
            echo "  cd /home/collins/.config/nvim"
            echo "  git reset --hard pre-python-setup-backup"
        fi
        
        echo "Rollback completed successfully!"
    else
        echo "Rollback cancelled."
    fi
else
    echo "ERROR: Backup directory not found: $BACKUP_DIR"
    echo "Manual restore required."
    echo "If you have a git backup, you can restore with:"
    echo "  cd /home/collins/.config/nvim"
    echo "  git reset --hard <commit_hash>"
fi