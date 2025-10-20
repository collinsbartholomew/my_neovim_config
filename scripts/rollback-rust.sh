#!/bin/sh
set -e
latest_backup=$(ls -dt $HOME/.config/nvim.backup.* | grep rust-setup | head -n1)
if [ -z "$latest_backup" ]; then
  echo "No backup found."
  exit 1
fi
cp -a "$latest_backup/." "$HOME/.config/nvim/"
cd ~/.config/nvim && git reset --hard
#!/bin/sh
set -e
LOG=~/.config/nvim/scripts/verify-rust.log
rm -f "$LOG"

# 1. Headless Neovim startup
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print("startup_ok")' -c 'qa!' >> "$LOG" 2>&1 || echo 'FAIL: Neovim startup' >> "$LOG"

# 2. Mason registry: check Rust tools
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print(vim.inspect(require("mason-registry").is_installed("rust-analyzer")))' -c 'qa' >> "$LOG"
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print(vim.inspect(require("mason-registry").is_installed("codelldb")))' -c 'qa' >> "$LOG"
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print(vim.inspect(require("mason-registry").is_installed("rustfmt")))' -c 'qa' >> "$LOG"

# 3. LSP: open tmp_test.rs, confirm rust-analyzer attached
cat <<EOF > /tmp/tmp_test.rs
fn main() { println!("hello"); }
EOF
nvim --headless /tmp/tmp_test.rs -c 'LspInfo' -c 'qa' >> "$LOG"

# 4. Formatting: test rustfmt via conform.nvim
cat <<EOF > /tmp/tmp_fmt.rs
fn main( ) {println!("hello")}
EOF
nvim --headless /tmp/tmp_fmt.rs -c 'lua require("conform").format()' -c 'wqa' >> "$LOG"
diff /tmp/tmp_fmt.rs <(rustfmt /tmp/tmp_fmt.rs) >> "$LOG" || echo 'FAIL: Formatting' >> "$LOG"

# 5. DAP: test codelldb adapter
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print(vim.inspect(require("dap").adapters.codelldb))' -c 'qa' >> "$LOG"

# 6. Neotest: test runner loads
nvim --headless -u ~/.config/nvim/init.lua -c 'lua print(require("neotest").run.run)' -c 'qa' >> "$LOG"

cat "$LOG"

