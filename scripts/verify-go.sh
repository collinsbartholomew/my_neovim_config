#!/bin/sh
set -e
LOG=~/.config/nvim/scripts/verify-go.log
rm -f "$LOG"

# 1. Headless Neovim startup
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print("ok")' -c 'qa' >> "$LOG" 2>&1 || echo 'FAIL: Neovim startup' >> "$LOG"

# 2. Mason registry: check Go tools
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print(vim.inspect(require("mason-registry").is_installed("gopls")))' -c 'qa' >> "$LOG"
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print(vim.inspect(require("mason-registry").is_installed("delve")))' -c 'qa' >> "$LOG"
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print(vim.inspect(require("mason-registry").is_installed("gofumpt")))' -c 'qa' >> "$LOG"
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print(vim.inspect(require("mason-registry").is_installed("goimports")))' -c 'qa' >> "$LOG"
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print(vim.inspect(require("mason-registry").is_installed("staticcheck")))' -c 'qa' >> "$LOG"

# 3. LSP: open main.go, confirm gopls attached
cat <<EOF > /tmp/main.go
package main
func main() { println("hello") }
EOF
nvim --headless /tmp/main.go -c 'LspInfo' -c 'qa' >> "$LOG"

# 4. Formatting: test gofumpt/goimports via conform.nvim
cat <<EOF > /tmp/test.go
package main
func main( ) {println("hello")}
EOF
nvim --headless /tmp/test.go -c 'lua require("conform").format()' -c 'wqa' >> "$LOG"
diff /tmp/test.go <(gofumpt /tmp/test.go) >> "$LOG" || echo 'FAIL: Formatting' >> "$LOG"

# 5. DAP: test delve adapter
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print(vim.inspect(require("dap").adapters.go))' -c 'qa' >> "$LOG"

# 6. Neotest: test runner loads
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print(require("neotest").run.run)' -c 'qa' >> "$LOG"

cat "$LOG"

