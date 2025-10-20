#!/bin/bash
# Zig setup verification script

LOG_FILE="scripts/verify-zig.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec 1> >(tee -a "$LOG_FILE")
exec 2>&1

echo "=== Zig Setup Verification $(date) ==="

# Check Neovim startup
echo "Testing Neovim startup..."
if nvim --headless -u ~/.config/nvim/init.lua -c 'echo "startup_ok"' -c 'qa!'; then
    echo "✓ Neovim startup successful"
else
    echo "× Neovim startup failed"
fi

# Check Mason packages
echo "Checking Mason packages..."
nvim --headless -c "lua require('mason-registry').refresh()" -c "sleep 100m" -c "qa!"
nvim --headless -c "lua for _, pkg in ipairs(require('mason-registry').get_installed_packages()) do print(pkg.name) end" -c "qa!"

# Test LSP attachment
echo "Testing LSP attachment..."
cat > /tmp/test.zig << EOL
const std = @import("std");

pub fn main() void {
    std.debug.print("Hello, World!\n", .{});
}
EOL

nvim --headless /tmp/test.zig -c "lua print(vim.inspect(vim.lsp.get_active_clients()))" -c "sleep 1000m" -c "qa!"

# Test formatting
echo "Testing Zig formatting..."
cat > /tmp/test_fmt.zig << EOL
const std=@import("std");pub fn main()void{std.debug.print("Hello\n",.{});}
EOL

nvim --headless /tmp/test_fmt.zig -c "lua vim.lsp.buf.format()" -c "write" -c "qa!"
cat /tmp/test_fmt.zig

# Check DAP setup
echo "Checking DAP configuration..."
if [ -f "$HOME/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb" ]; then
    echo "✓ codelldb adapter found"
else
    echo "× codelldb adapter not found - manual installation may be needed"
fi

# Check user commands
echo "Checking Zig commands..."
nvim --headless -c "silent verbose command ZigBuild" -c "silent verbose command ZigRun" -c "silent verbose command ZigTest" -c "silent verbose command ZigFmt" -c "qa!"

echo "=== Verification complete ==="
