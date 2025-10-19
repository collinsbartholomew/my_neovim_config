#!/usr/bin/env zsh
# Validate Neovim config: run checkhealth and the lightweight diagnostics runner
# Outputs are written to /tmp/nvim_checkhealth.txt and /tmp/nvim_diagnostics.txt

CONFIG_INIT="$HOME/.config/nvim/init.lua"

echo "Running Neovim checkhealth (this may take a few seconds)..."
nvim --headless -u "$CONFIG_INIT" -c "checkhealth" -c "qall!" > /tmp/nvim_checkhealth.txt 2>&1

echo "Running diagnostics runner (tools.diagnostics.run)..."
nvim --headless -u "$CONFIG_INIT" -c "lua local ok, diag = pcall(require, 'tools.diagnostics'); if not ok then print('require tools.diagnostics failed:', diag) else diag.run() end" -c "qall!" > /tmp/nvim_diagnostics.txt 2>&1

echo "Outputs written to /tmp/nvim_checkhealth.txt and /tmp/nvim_diagnostics.txt"
exit 0

