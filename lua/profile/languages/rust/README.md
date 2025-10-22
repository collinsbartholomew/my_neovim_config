# Rust Support for Neovim

This module provides comprehensive Rust development support for Neovim, with features rivaling dedicated IDEs like RustRover or VSCode with Rust extensions.

## Features

### Language Server Protocol (LSP)
- Uses `rust-analyzer` for advanced features:
  - Code completion
  - Diagnostics and error reporting
  - Refactorings (extract function, etc.)
  - Inlay hints for types/lifetimes
  - Macro expansion
  - Crate graph visualization
- Integrated with crates.nvim for dependency management (search/update crates.io)
- Support for Cargo workspaces, proc-macros, and build scripts

### Debugging
- Advanced debugging with nvim-dap + dap-ui
- Uses codelldb for better Rust support (pretty-printing enums, async stacks)
- Features:
  - Breakpoints
  - Step-through async code
  - Variable watches with custom formatters for Rust types
  - Test debugging via cargo test
  - Panic handling

### Linting
- Asynchronous linting with nvim-lint
- Uses clippy for pedantic checks (idiomatic Rust, performance warnings)
- Custom rules for software engineering (no unsafe without justification)

### Formatting
- Auto-formatting with conform.nvim using rustfmt
- Configurable editions like 2021/2024

### Memory Analysis
- Integration with tools like valgrind or cargo-valgrind via overseer.nvim tasks
- Keymaps to run heaptrack or miri for undefined behavior detection
- Focus on safe Rust practices

### Security Analysis
- Tasks for cargo-audit (dependency vulnerabilities)
- cargo-deny (license/deny checks)
- Semgrep with Rust rules for static analysis (detecting panics, overflows)
- Emphasis on Rust's safety features with checks for unsafe blocks

### Build/Run Tasks
- Integration with cargo (cargo build/check/run/test/bench)
- Templates for cross-compilation (wasm, embedded)
- Auto-detect targets, support no-std for embedded Rust

### Testing
- Integration with neotest-rust adapter
- Keymaps for running unit/doc/integration tests
- Viewing coverage (via cargo-llvm-cov or tarpaulin reports in quickfix)

### Treesitter
- Enhanced syntax highlighting for Rust
- Code folding for functions/traits/modules

## Keymaps

All Rust-related keymaps are organized under specific prefixes:

- `<leader>r` - Rust operations
- `<leader>c` - Cargo operations
- `<leader>d` - Debug operations
- `<leader>s` - Software engineering operations

### Rust Operations (`<leader>r`)
- `<leader>rr` - Runnables
- `<leader>rt` - Run tests in file
- `<leader>rd` - Debug (DAP continue)
- `<leader>rc` - Cargo clippy
- `<leader>rf` - Format buffer
- `<leader>re` - Expand macros
- `<leader>rh` - Hover actions
- `<leader>rv` - Cargo check

### Debug Operations (`<leader>d`)
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue
- `<leader>do` - Step over
- `<leader>di` - Step into
- `<leader>du` - Toggle DAP UI
- `<leader>dr` - Open REPL
- `<leader>dq` - Stop debugging

### Cargo Operations (`<leader>c`)
- `<leader>cb` - Build
- `<leader>cr` - Run
- `<leader>ct` - Test
- `<leader>cc` - Check
- `<leader>cf` - Format
- `<leader>cd` - Documentation
- `<leader>ca` - Audit
- `<leader>ce` - Expand
- `<leader>cv` - Valgrind
- `<leader>cl` - Coverage
- `<leader>cB` - Benchmark

### Software Engineering Operations (`<leader>s`)
- `<leader>sec` - Coverage
- `<leader>ser` - Reformat
- `<leader>set` - Test
- `<leader>sea` - Audit
- `<leader>sed` - Documentation

## Commands

- `:CargoBuild` - Build project
- `:CargoRun` - Run project
- `:CargoTest` - Run tests
- `:CargoCheck` - Check code
- `:CargoClippy` - Run clippy
- `:CargoDoc` - Generate and open documentation
- `:CargoAudit` - Audit dependencies
- `:CargoExpand` - Expand macros
- `:CargoFmt` - Format code
- `:CargoBench` - Run benchmarks
- `:CargoValgrind` - Run valgrind
- `:CargoCoverage` - Generate coverage report

## Installation Requirements

For full functionality, install these tools:

```bash
# Install Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Add required components
rustup component add rustfmt clippy

# Install additional tools
cargo install cargo-audit cargo-expand cargo-valgrind cargo-llvm-cov

# For embedded or cross-compilation
rustup target add thumbv7m-none-eabi
```

## File Types Supported

- `.rs` - Rust source files
- `Cargo.toml` - Cargo manifest files

## Customization

You can customize the behavior by modifying the files in this directory:
- `lsp.lua` - LSP configuration
- `debug.lua` - Debugging setup
- `tools.lua` - Additional tools and commands
- `mappings.lua` - Keymaps

The configuration automatically integrates with the existing Neovim setup and follows the established patterns of other language modules in this configuration.