# Mojo Language Support

## Features

### Language Server Protocol (LSP)
- Uses `mojo-lsp-server` for advanced Mojo language features
- Type checking and inference
- Auto-imports and code actions
- Go to definition, references, implementation
- Hover documentation
- Code lens for running/debugging tests
- Support for Mojo build system and comptime features

### Debugging (DAP)
- Uses `lldb` or `codelldb` for native Mojo debugging
- Support for debugging Mojo-built binaries
- Remote debugging capabilities
- Variable inspection and watches for Mojo types
- Breakpoint management
- Test debugging via `mojo test`

### Formatting
- Uses `mojo format` for code formatting
- Automatic formatting on save

### Linting
- Uses `mojo check` for static analysis
- Syntax and best practices checking

### Testing
- Integration with `neotest` for running tests
- Support for Mojo's built-in testing framework
- Test coverage reports

### Tools and Utilities
- Memory profiling with valgrind
- Security analysis with checksec
- Benchmarking with `mojo bench`
- Documentation generation with `mojo doc`
- Package management with `mojo package`

## Components
- LSP: mojo-lsp-server
- DAP: lldb/codelldb
- Formatters: mojo format
- Linters: mojo check
- Test runner: neotest-mojo (custom)

## Manual installation (if needed)
```bash
# Install LLDB for debugging
# Ubuntu/Debian:
sudo apt install lldb lldb-vscode

# macOS (with Homebrew):
brew install llvm

# Install valgrind for memory analysis
# Ubuntu/Debian:
sudo apt install valgrind

# macOS:
brew install valgrind

# Install checksec for security analysis
# Ubuntu/Debian:
sudo apt install checksec

# macOS:
brew install checksec
```

## Keymaps

### Mojo Commands (`<leader>mo`)
- `<leader>mor` - Run file (:MojoRun)
- `<leader>mob` - Build project (:MojoBuild)
- `<leader>mot` - Run tests (:MojoTest)
- `<leader>mof` - Format code (:MojoFormat)
- `<leader>moc` - Check code (:MojoCheck)
- `<leader>mob` - Run benchmarks (:MojoBench)
- `<leader>mod` - Generate documentation (:MojoDoc)
- `<leader>mop` - Package project (:MojoPackage)
- `<leader>mom` - Memory check (:MojoMemory)
- `<leader>mos` - Security scan (:MojoSecurity)

### Debugging (`<leader>d`)
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue
- `<leader>do` - Step over
- `<leader>di` - Step into
- `<leader>dO` - Step out
- `<leader>dr` - Open REPL
- `<leader>du` - Toggle DAP UI
- `<leader>dq` - Stop debugging
- `<leader>dt` - Terminate session
- `<leader>dp` - Pause execution
- `<leader>dw` - Widget hover

### Testing (`<leader>t`)
- `<leader>tf` - Run file tests
- `<leader>tt` - Run nearest test
- `<leader>to` - Show test output
- `<leader>ts` - Toggle test summary
- `<leader>tc` - Debug nearest test

### Software Engineering (`<leader>se`)
- `<leader>sec` - Coverage/Test
- `<leader>ser` - Reformat
- `<leader>set` - Test
- `<leader>sel` - Lint
- `<leader>ses` - Security scan
- `<leader>sem` - Memory check

### LSP Features (`<leader>l`)
- `<leader>lh` - Hover
- `<leader>lr` - Rename
- `<leader>la` - Code action
- `<leader>ld` - Diagnostics
- `<leader>lf` - Format
- `<leader>lg` - Go to definition
- `<leader>li` - Implementation
- `<leader>ls` - Document symbols
- `<leader>lw` - Workspace symbols
- `<leader>lt` - Run CodeLens

## Usage

### Commands

- `:MojoRun` - Run Mojo file
- `:MojoBuild` - Build Mojo project
- `:MojoTest` - Run tests
- `:MojoFormat` - Format code with mojo format
- `:MojoCheck` - Check code with mojo check
- `:MojoBench` - Run benchmarks
- `:MojoDoc` - Generate documentation
- `:MojoPackage` - Package project
- `:MojoMemory` - Memory check with valgrind
- `:MojoSecurity` - Security scan with checksec