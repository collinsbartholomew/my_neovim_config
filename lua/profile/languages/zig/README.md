# Zig Support for Neovim

This module provides comprehensive Zig development support for Neovim, with features rivaling dedicated IDEs like VSCode with Zig extensions.

## Features

### Language Server Protocol (LSP)
- Uses `zls` for advanced features:
  - Code completion
  - Diagnostics and error reporting
  - Refactorings (extract function, etc.)
  - Inlay hints for types/inferences
  - Support for Zig build system (build.zig)
  - Comptime evaluation support
- Integrated with zig-tools.nvim for additional commands

### Debugging
- Advanced debugging with nvim-dap + dap-ui
- Uses codelldb for better Zig support (pretty-printing structs, async if applicable)
- Features:
  - Breakpoints
  - Step-through code
  - Variable watches with custom formatters for Zig types
  - Test debugging via zig test
  - Handling of comptime code

### Linting
- Asynchronous linting with nvim-lint
- Uses zig check for syntax/static checks
- Integrates zls for deeper analysis (unused code, safety warnings)

### Formatting
- Auto-formatting with conform.nvim using zig fmt
- Configurable for style preferences

### Memory Analysis
- Integration with valgrind or Zig's built-in sanitizers (-fsanitize) via overseer.nvim tasks
- Keymaps to run valgrind on binaries for leaks/race conditions
- Miri-like tools for undefined behavior detection

### Security Analysis
- Tasks for binary security tools like checksec (RELRO, PIE, NX)
- Static analysis with zls warnings for vulnerabilities (buffer overflows in unsafe code)
- Semgrep with Zig rules if supported

### Build/Run Tasks
- Integration with zig build/run/test
- Templates for cross-compilation (Windows/Linux/Wasm/embedded)
- Auto-detect targets, support no-std for embedded Zig

### Testing
- Keymaps for running unit/integration tests
- Viewing coverage (via zig coverage tools or lcov integration)

### Treesitter
- Enhanced syntax highlighting for Zig
- Code folding for functions/structs/modules

## Keymaps

All Zig-related keymaps are organized under specific prefixes:

- `<leader>z` - Zig operations
- `<leader>s` - Software engineering operations

### Zig Operations (`<leader>z`)
- `<leader>zb` - Build Project
- `<leader>zr` - Run Current File
- `<leader>zt` - Run Tests
- `<leader>zf` - Format Buffer
- `<leader>zc` - Check Code
- `<leader>zd` - Generate Docs
- `<leader>zB` - Run Benchmarks
- `<leader>zv` - Coverage Report
- `<leader>zs` - Sanitize Build

### Debug Operations (`<leader>z d`)
- `<leader>zdb` - Toggle breakpoint
- `<leader>zdc` - Continue
- `<leader>zds` - Step over
- `<leader>zdi` - Step into
- `<leader>zdo` - Step out
- `<leader>zdr` - Open REPL
- `<leader>zdu` - Toggle UI
- `<leader>zdq` - Stop debugging

### Software Engineering Operations (`<leader>s`)
- `<leader>sec` - Coverage
- `<leader>ser` - Reformat
- `<leader>set` - Test
- `<leader>sed` - Documentation

## Commands

- `:ZigBuild` - Build project
- `:ZigRun` - Run current file
- `:ZigTest` - Run tests
- `:ZigFmt` - Format code
- `:ZigCheck` - Check code
- `:ZigDoc` - Generate documentation
- `:ZigBench` - Run benchmarks
- `:ZigCoverage` - Generate coverage report
- `:ZigSanitize` - Build with sanitizers

## Installation Requirements

For full functionality, install these tools:

```bash
# Install Zig
# Visit https://ziglang.org/download/ for the latest version

# Install ZLS (Zig Language Server)
# Visit https://github.com/zigtools/zls for installation instructions

# Install codelldb for debugging
# Can be installed via Mason: :MasonInstall codelldb
```

## File Types Supported

- `.zig` - Zig source files
- `build.zig` - Zig build files

## Customization

You can customize the behavior by modifying the files in this directory:
- `lsp.lua` - LSP configuration
- `debug.lua` - Debugging setup
- `tools.lua` - Additional tools and commands
- `mappings.lua` - Keymaps

The configuration automatically integrates with the existing Neovim setup and follows the established patterns of other language modules in this configuration.