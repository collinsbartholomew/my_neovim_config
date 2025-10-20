# Rust Integration for Neovim

-- added-by-agent: rust-setup 20251020

## Mason Packages
- rust-analyzer
- codelldb
- rustfmt (if available)

## Manual Installs (if not in Mason)
- rustup component add rust-src rustfmt clippy llvm-tools-preview miri
- cargo install cargo-audit cargo-flamegraph cargo-nextest cargo-fuzz cargo-bloat

## Usage
- <leader>rr: Rust runnables
- <leader>rt: Run tests in file
- <leader>rd: Debug (DAP continue)
- <leader>rc: Cargo clippy
- <leader>rf: Format buffer
- <leader>cb/ct/cr: Cargo build/test/run
- <leader>ca: Cargo audit

## Troubleshooting
- If rust-analyzer or codelldb are missing, run :Mason and install them.
- If formatting fails, ensure rustfmt is installed (see above).
- For DAP, ensure codelldb is installed and up-to-date.
- For test running, ensure neotest and neotest-rust are installed.

## Settings
- See lsp.lua for rust-analyzer tuning (clippy, inlay hints, etc).
- See tools.lua for formatter and cargo helpers.

## Manual Steps
- Install missing tools via Mason or rustup/cargo as listed above.
- Ensure $HOME/.cargo/bin is on your PATH for Rust tools.
-- added-by-agent: rust-setup 20251020
-- Mason: rust-analyzer, codelldb, rustfmt
-- Manual: rustup component add rust-src rustfmt clippy llvm-tools-preview miri
local M = {}
local already_setup = false
function M.setup()
  if already_setup then return end
  already_setup = true
  require('profile.languages.rust.lsp').setup()
  require('profile.languages.rust.debug').setup()
  require('profile.languages.rust.tools').setup()
  require('profile.languages.rust.mappings').setup()
  require('profile.ui.rust-ui').setup()
  require('profile.ui.diagnostics').setup()
end
return M

