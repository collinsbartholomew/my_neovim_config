#!/bin/bash

# Python setup verification script
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
LOG_FILE="/home/collins/.config/nvim/scripts/verify-python.log"

echo "=== Python Setup Verification Report - $TIMESTAMP ===" > "$LOG_FILE"
echo "=================================================" >> "$LOG_FILE"

# Check if nvim is available
if ! command -v nvim &> /dev/null; then
    echo "ERROR: Neovim is not installed or not in PATH" | tee -a "$LOG_FILE"
    exit 1
fi

echo "✓ Neovim is available" >> "$LOG_FILE"

# Check for Python-related tools in PATH
echo "Checking for Python tools in PATH:" >> "$LOG_FILE"

if command -v python3 &> /dev/null; then
    echo "✓ python3 found: $(python3 --version)" >> "$LOG_FILE"
else
    echo "✗ python3 not found" >> "$LOG_FILE"
fi

if command -v pipx &> /dev/null; then
    echo "✓ pipx found: $(pipx --version)" >> "$LOG_FILE"
else
    echo "✗ pipx not found" >> "$LOG_FILE"
fi

if command -v pyenv &> /dev/null; then
    echo "✓ pyenv found: $(pyenv --version)" >> "$LOG_FILE"
else
    echo "✗ pyenv not found" >> "$LOG_FILE"
fi

if command -v ruff &> /dev/null; then
    echo "✓ ruff found: $(ruff --version)" >> "$LOG_FILE"
else
    echo "✗ ruff not found" >> "$LOG_FILE"
fi

if command -v black &> /dev/null; then
    echo "✓ black found: $(black --version)" >> "$LOG_FILE"
else
    echo "✗ black not found" >> "$LOG_FILE"
fi

if command -v debugpy &> /dev/null; then
    echo "✓ debugpy found" >> "$LOG_FILE"
else
    echo "✗ debugpy not found" >> "$LOG_FILE"
fi

# Check Mason packages directory
MASON_DIR="$HOME/.local/share/nvim/mason/packages"
echo "Checking Mason packages directory: $MASON_DIR" >> "$LOG_FILE"

if [ -d "$MASON_DIR" ]; then
    echo "✓ Mason packages directory exists" >> "$LOG_FILE"
    
    # Check for Python-related packages
    if [ -d "$MASON_DIR/pyright" ]; then
        echo "✓ pyright installed" >> "$LOG_FILE"
    else
        echo "✗ pyright not installed" >> "$LOG_FILE"
    fi
    
    if [ -d "$MASON_DIR/debugpy" ]; then
        echo "✓ debugpy installed" >> "$LOG_FILE"
    else
        echo "✗ debugpy not installed" >> "$LOG_FILE"
    fi
    
    if [ -d "$MASON_DIR/ruff" ]; then
        echo "✓ ruff installed" >> "$LOG_FILE"
    else
        echo "✗ ruff not installed" >> "$LOG_FILE"
    fi
    
    if [ -d "$MASON_DIR/black" ]; then
        echo "✓ black installed" >> "$LOG_FILE"
    else
        echo "✗ black not installed" >> "$LOG_FILE"
    fi
    
    if [ -d "$MASON_DIR/isort" ]; then
        echo "✓ isort installed" >> "$LOG_FILE"
    else
        echo "✗ isort not installed" >> "$LOG_FILE"
    fi
else
    echo "✗ Mason packages directory does not exist" >> "$LOG_FILE"
fi

# Test requiring Python module in headless nvim
echo "Testing Python module require in headless nvim:" >> "$LOG_FILE"
cd /home/collins/.config/nvim

if timeout 10 nvim --headless -c "lua require('python')" -c "qa!" &> /dev/null; then
    echo "✓ Python module can be required successfully" >> "$LOG_FILE"
else
    echo "✗ Failed to require Python module" >> "$LOG_FILE"
fi

echo "=================================================" >> "$LOG_FILE"
echo "Verification complete. Check $LOG_FILE for details." | tee -a "$LOG_FILE"