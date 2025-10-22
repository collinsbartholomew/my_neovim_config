# Assembly Language Support for Neovim

This module provides comprehensive assembly language support for Neovim, with features rivaling dedicated ASM IDEs.

## Features

### Language Server Protocol (LSP)
- Uses `asm-lsp` for:
  - Go-to-definition for labels and symbols
  - Hover documentation for opcodes
  - Diagnostics and error reporting
  - Code actions

### Debugging
- Advanced debugging with `nvim-dap` + `gdb`/`lldb`
- Features:
  - Breakpoints in assembly code
  - Step-into/over assembly instructions
  - Disassemble view
  - Register watches
  - Memory inspection

### Linting
- Asynchronous linting with `nvim-lint`
- Supports both NASM and GAS syntax
- Checks for syntax errors, unused labels, etc.

### Formatting
- Auto-formatting with `conform.nvim`
- Uses `asmfmt` when available
- Custom formatter included as fallback

### Memory Analysis
- Integration with `valgrind` via `overseer.nvim`
- Keymaps to run memory leak checks
- Cache profiling with `cachegrind`

### Security Analysis
- Binary security checks with `checksec`
- ELF header analysis with `readelf`
- Disassembly with `objdump`
- Dynamic dependency listing with `ldd`

### Build/Run Tasks
- Assembling with `nasm`/`gas`
- Linking with `ld`
- Running executables
- Templates for common assembly patterns

## Keymaps

All assembly-related keymaps are under the `<leader>a` prefix:

- `<leader>a` - Assembly menu
- `<leader>aa` - Assemble/Run submenu
- `<leader>ad` - Debug submenu
- `<leader>am` - Memory analysis submenu
- `<leader>as` - Security analysis submenu
- `<leader>at` - Templates submenu

### Assemble/Run
- `<leader>aaa` - Assemble with NASM and link with LD
- `<leader>aag` - Assemble with GAS and link with LD
- `<leader>aar` - Run current assembly program
- `<leader>aad` - Debug with GDB

### Debugging
- `<leader>adb` - Toggle breakpoint
- `<leader>adc` - Continue execution
- `<leader>adi` - Step into
- `<leader>ado` - Step over
- `<leader>adO` - Step out
- `<leader>adr` - Toggle REPL
- `<leader>adt` - Toggle DAP UI
- `<leader>adR` - Show registers
- `<leader>add` - Disassemble current file

### Memory Analysis
- `<leader>ama` - Analyze memory with Valgrind
- `<leader>amc` - Cache profiling with Cachegrind
- `<leader>amp` - Performance profiling with Perf
- `<leader>amm` - Trace system calls

### Security Analysis
- `<leader>asc` - Check binary security
- `<leader>asr` - Read ELF header
- `<leader>asn` - Disassemble with objdump
- `<leader>asl` - List dynamic dependencies
- `<leader>ash` - Show hexdump

### Templates
- `<leader>atn` - New NASM template
- `<leader>atg` - New GAS template

## Global Keymaps

- `<leader>atc` - Check installed assembly tools
- `<leader>arr` - Quick compile and run for assembly files

## Installation Requirements

For full functionality, install these tools:

```bash
# Essential tools
sudo apt install nasm binutils gdb valgrind

# Optional tools for enhanced features
sudo apt install lldb checksec perf-tools strace

# Formatter (optional)
# Install from: https://github.com/klauspost/asmfmt
```

## File Types Supported

- `.asm` - NASM syntax
- `.s` - GAS syntax
- `.S` - GAS syntax (with preprocessing)

## Customization

You can customize the behavior by modifying the files in this directory:
- `lsp.lua` - LSP configuration
- `debug.lua` - Debugging setup
- `tools.lua` - Formatting and linting
- `mappings.lua` - Keymaps
- `templates.lua` - Code templates
- `formatter.lua` - Custom formatter

The configuration automatically integrates with the existing Neovim setup and follows the established patterns of other language modules in this configuration.