# C/C++ and Qt/QML Support for Neovim

This module provides comprehensive C/C++ and Qt/QML development support for Neovim, with features rivaling dedicated IDEs like Qt Creator or Visual Studio.

## Features

### Language Server Protocol (LSP)
- Uses `clangd` for C/C++ with:
  - Code completion
  - Diagnostics and error reporting
  - Refactorings (like include fixes)
  - Auto-imports
  - Code actions for Qt signals/slots
  - Hover with Qt documentation
- Uses `qmlls` for QML with:
  - Property bindings support
  - Component navigation
  - Code completion

### Debugging
- Advanced debugging with `nvim-dap` + `gdb`/`codelldb`
- Features:
  - Breakpoints in C++/QML code
  - Step-through mixed C++/QML code
  - Variable watches
  - Stack traces
  - Attach to Qt apps or emulators
  - Cross-platform debugging (Windows/Linux/macOS)

### Linting
- Asynchronous linting with `nvim-lint`
- Uses `clang-tidy` and `cppcheck` for C/C++ static analysis
- Uses `qmllint` for QML syntax/compatibility checks
- Detects undefined behavior and Qt best practices

### Formatting
- Auto-formatting with `conform.nvim`
- Uses `clang-format` for C/C++ with configurable styles
- Uses `qmlformat` for QML alignment/indentation

### Memory Analysis
- Integration with `valgrind` for memory leak detection
- AddressSanitizer (ASan) build support
- Keymaps to run valgrind on binaries for leaks/race conditions

### Security Analysis
- Static security analysis with `cppcheck` and `clang-tidy`
- Check for cross-platform issues (e.g., path handling)

### Build/Run Tasks
- Integration with `cmake-tools.nvim` for CMake-based projects
- Cross-platform build support (Linux, Windows, macOS, Android)
- QML scene preview with `qmlscene`
- Qt application deployment

### Testing
- Integration with test frameworks (Google Test, Catch2, Qt Test)
- CTest support for running unit/integration tests
- Code coverage visualization

### Treesitter
- Enhanced syntax highlighting for C, C++, and QML
- Code folding for classes/methods in C++, components in QML

## Keymaps

All C/C++ and Qt/QML related keymaps are organized under specific prefixes:

- `<leader>c` - C/C++ operations
- `<leader>q` - Qt/QML operations
- `<leader>b` - Build operations
- `<leader>d` - Debug operations
- `<leader>t` - Test operations
- `<leader>s` - Software engineering operations

### C/C++ Operations (`<leader>c`)
- `<leader>cc` - Run clang-tidy
- `<leader>cC` - Run cppcheck
- `<leader>cf` - Format buffer
- `<leader>ch` - Switch header/source
- `<leader>cm` - Generate compile_commands.json
- `<leader>cv` - Run valgrind
- `<leader>ca` - Build with AddressSanitizer

### Build Operations (`<leader>b`)
- `<leader>bb` - Build project
- `<leader>bd` - Generate compile_commands.json
- `<leader>ba` - Build with AddressSanitizer

### Debug Operations (`<leader>d`)
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue execution
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>dO` - Step out
- `<leader>dr` - Open REPL
- `<leader>dt` - Toggle DAP UI

### Qt/QML Operations (`<leader>q`)
- `<leader>qf` - Format QML
- `<leader>qn` - Edit QML config
- `<leader>qr` - Run QML scene
- `<leader>qd` - Deploy Qt application

### Test Operations (`<leader>t`)
- `<leader>tt` - Run nearest test
- `<leader>tf` - Run test file
- `<leader>ts` - Run test suite
- `<leader>tl` - Run last test
- `<leader>tv` - Visit last test file

### Software Engineering Operations (`<leader>s`)
- `<leader>se` - Run CTest suite
- `<leader>sc` - Generate coverage report
- `<leader>sf` - Check code formatting
- `<leader>st` - Run static analysis

## Commands

- `:MakeCompileDB` - Generate compile_commands.json
- `:ClangTidy` - Run clang-tidy on current file
- `:CppCheck` - Run cppcheck on project
- `:Valgrind` - Run valgrind on executable
- `:ASanBuild` - Build with AddressSanitizer
- `:QtDeploy` - Deploy Qt application
- `:CTest` - Run CTest suite
- `:CTestCoverage` - Generate coverage report
- `:ClangFormatCheck` - Check code formatting

## Qt-Specific Functions

- `generate_signal_slot()` - Generate Qt signal/slot connections
- `create_qt_class()` - Create a basic Qt class with header and implementation files

## Installation Requirements

For full functionality, install these tools:

```bash
# Arch Linux
sudo pacman -S --needed base-devel cmake ninja git gcc clang llvm lld lldb gdb clang-tools-extra valgrind qt6-base qt6-declarative bear cppcheck

# Ubuntu/Debian
sudo apt install build-essential cmake ninja-build git gcc clang llvm lld lldb gdb clang-tools valgrind qt6-base-dev qt6-declarative-dev bear cppcheck

# macOS with Homebrew
brew install cmake ninja llvm lldb gdb clang-tools valgrind bear cppcheck
# For Qt, download from https://www.qt.io/download
```

## File Types Supported

- `.c`, `.h` - C source and header files
- `.cpp`, `.cxx`, `.cc`, `.hpp`, `.hxx` - C++ source and header files
- `.qml` - QML files
- `.qmlproject` - QML project files

## Customization

You can customize the behavior by modifying the files in this directory:
- `lsp.lua` - LSP configuration
- `qmlls.lua` - QML LSP configuration
- `debug.lua` - Debugging setup
- `tools.lua` - Additional tools
- `qt.lua` - Qt-specific functionality
- `mappings.lua` - Keymaps

The configuration automatically integrates with the existing Neovim setup and follows the established patterns of other language modules in this configuration.