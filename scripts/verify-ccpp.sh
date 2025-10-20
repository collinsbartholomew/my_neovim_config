#!/bin/bash

# added-by-agent: ccpp-setup 20251020
# Verification script for C/C++ Neovim integration

LOG_FILE="verify-ccpp.log"
ERROR_LOG="setup-errors-ccpp.log"

# Start fresh log files
echo "C/C++ Integration Verification - $(date)" > "$LOG_FILE"
echo "C/C++ Setup Errors - $(date)" > "$ERROR_LOG"

# Function to log with timestamps
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check if command exists
check_cmd() {
    if command -v "$1" >/dev/null 2>&1; then
        log "✓ Found $1"
        return 0
    else
        log "✗ Missing $1"
        return 1
    fi
}

# Verify system dependencies
log "=== Checking System Dependencies ==="
deps=(clangd clang-format clang-tidy cppcheck cmake)
for cmd in "${deps[@]}"; do
    check_cmd "$cmd"
done

# Create test files
log "=== Creating Test Files ==="
mkdir -p test_cpp
cat > test_cpp/test.cpp << 'EOL'
#include <iostream>
int main(){std::cout<<"Hello"<<std::endl;return 0;}
EOL

cat > test_cpp/test.qml << 'EOL'
import QtQuick

Rectangle {width: 100;height: 100;color: "red"}
EOL

# Test Neovim startup
log "=== Testing Neovim Startup ==="
if nvim --headless -u ~/.config/nvim/init.lua -c 'q'; then
    log "✓ Neovim starts successfully"
else
    log "✗ Neovim startup failed"
    exit 1
fi

# Test LSP activation
log "=== Testing LSP Activation ==="
nvim --headless test_cpp/test.cpp -c "lua vim.wait(1000, function() return #vim.lsp.get_active_clients() > 0 end)" -c "lua print('Active LSP clients: ' .. #vim.lsp.get_active_clients())" -c 'q' 2>> "$LOG_FILE"

# Test formatting
log "=== Testing Formatting ==="
cp test_cpp/test.cpp test_cpp/test.cpp.bak
nvim --headless test_cpp/test.cpp -c 'lua vim.lsp.buf.format()' -c 'wq' 2>> "$LOG_FILE"
if ! diff test_cpp/test.cpp test_cpp/test.cpp.bak >/dev/null; then
    log "✓ Formatting changed the file"
else
    log "✗ Formatting had no effect"
fi

# Check for compile_commands.json helper
log "=== Testing MakeCompileDB Command ==="
nvim --headless -c 'lua print(vim.api.nvim_get_commands({})["MakeCompileDB"] ~= nil)' -c 'q' 2>> "$LOG_FILE"

# Cleanup
rm -rf test_cpp

log "=== Verification Complete ==="
log "See $LOG_FILE for full results"
