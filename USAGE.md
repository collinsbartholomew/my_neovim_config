# Development Environment Usage Guide

## Quick Start

### Required Tools

#### Rust Development
- rust-analyzer (via Mason)
- rustc and cargo (via system package manager)
- Optional tools: rustfmt, clippy (usually included with rust installation)

#### Go Development
- gopls (via Mason)
- go (via system package manager)
- delve for debugging (via Mason)

#### C/C++ Development
- clangd (via Mason)
- clang/gcc compiler (via system package manager)
- cmake for project building
- Optional: ninja, valgrind for advanced features

## Common Keybindings

### LSP (All Languages)
- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover information
- `<C-k>` - Signature help
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions

### Debugging (All Languages)
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>dO` - Step out
- `<leader>dr` - Open REPL
- `<leader>du` - Toggle DAP UI

### Testing
- `<leader>tt` - Run nearest test
- `<leader>tf` - Run file tests
- `<leader>ta` - Run all tests
- `<leader>ts` - Toggle test summary
- `<leader>to` - Show test output

### Rust-Specific
- `<leader>rh` - Hover actions
- `<leader>ra` - Code actions
- `<leader>rr` - Run runnables
- `<leader>rm` - Expand macro
- `<leader>rc` - Open Cargo.toml

Crates.nvim (in Cargo.toml):
- `<leader>ct` - Toggle versions
- `<leader>cu` - Update crate
- `<leader>ca` - Update all crates

### Go-Specific
- `<leader>gt` - Run tests
- `<leader>gi` - Go implementations
- `<leader>gr` - Run current file
- `<leader>gb` - Build project
- `<leader>gc` - Toggle coverage
- `<leader>gf` - Fill struct

### C/C++-Specific
CMake:
- `<leader>cg` - Generate
- `<leader>cb` - Build
- `<leader>cr` - Run
- `<leader>cd` - Debug
- `<leader>ct` - Select target

Memory Tools:
- `<leader>dm` - Run valgrind check
- `<leader>da` - Run AddressSanitizer

Code Generation:
- `<leader>ch` - Switch header/source
- `<leader>ci` - Generate implementation
- `<leader>cp` - Generate Rule of 3
- `<leader>c5` - Generate Rule of 5

## Features by Language

### Rust
- Intelligent code completion via rust-analyzer
- Inline type hints and parameter suggestions
- Automatic import management
- Cargo integration
- Test running and debugging
- Clippy diagnostics
- Macro expansion
- Dependency management (crates.nvim)

### Go
- Smart completion with gopls
- Auto import organization
- Test coverage visualization
- Delve debugging integration
- GolangCI-lint integration
- Struct tag management
- Interface implementation generation
- Package/workspace symbol search

### C/C++
- Intelligent completion with clangd
- CMake integration
- Header/source switching
- Memory leak detection
- ASan/UBSan integration
- Class member generation
- Rule of 3/5 generation
- Include organization

## Project Configuration

### Rust
- Place a `rust-toolchain.toml` in your project root for toolchain management
- Configure `.cargo/config.toml` for build settings
- Use `.clippy.toml` for linting rules

### Go
- Place a `.golangci.yml` in your project for linting rules
- Configure `go.mod` for dependency management
- Use `.goimports` for import organization

### C/C++
- Place a `compile_commands.json` in your project root
- Configure `.clang-format` for formatting rules
- Use `.clang-tidy` for static analysis configuration
- Set up `CMakeLists.txt` for build configuration

## Performance Tips
1. Use sccache for Rust compilation caching
2. Enable background index in clangd
3. Configure gopls memory settings for large projects
4. Use proper .gitignore to avoid indexing build artifacts
5. Configure format-on-save per project needs

## Troubleshooting
1. Run `:checkhealth` to verify plugin health
2. Check Mason for tool installation status
3. Verify compile_commands.json for C/C++ projects
4. Check LSP logs with `:LspLog`
5. Use `:Mason` to manage tool installations
