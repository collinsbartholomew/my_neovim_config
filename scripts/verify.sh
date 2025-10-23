#!/bin/sh
set -e

# Headless Neovim startup check
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print("OK")' -c 'qa'

# Mason package check
ls ~/.local/share/nvim/mason/bin/

# LSP attach test (Rust)
echo 'fn main() {}' > /tmp/test.rs
nvim --headless /tmp/test.rs -c 'lua print(vim.lsp.buf.server_ready and "LSP OK" or "LSP FAIL")' -c 'qa'

# Telescope basic search
nvim --headless -c 'lua require("telescope.builtin").find_files()' -c 'qa'

# Treesitter parser check
nvim --headless -c 'TSInstallInfo' -c 'qa'

# DAP adapter check (Rust)
if [ -x "$(command -v codelldb)" ]; then echo "DAP OK"; else echo "DAP FAIL"; fi

