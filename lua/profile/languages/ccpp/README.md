# C/C++ and Qt/QML Development Integration

This module provides a comprehensive C/C++ and Qt/QML development environment for Neovim.

## Features

- LSP support via clangd and qmlls
- Debug integration with codelldb (or lldb/gdb)
- Format and lint with clang-format, clang-tidy, and cppcheck
- Compilation database support
- Qt/QML language server integration

## Prerequisites

Install these dependencies via your package manager:

```bash
# Arch Linux
sudo pacman -S --needed base-devel cmake ninja git gcc clang llvm lld lldb gdb \
    clang-tools-extra clang-format clang-tidy cppcheck \
    qt6-base qt6-declarative
```

## Setting up compile_commands.json

For CMake projects:
```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -sf build/compile_commands.json .
```

For Make-based projects:
```bash
bear -- make
```

## Key Mappings

- `<leader>c` - Code actions
  - `cc` - Run clang-tidy
  - `cf` - Format buffer
  - `ch` - Switch header/source
- `<leader>b` - Build
  - `bb` - Build project
  - `bd` - Generate compile_commands.json
- `<leader>d` - Debug
  - `db` - Toggle breakpoint
  - `dc` - Continue
  - `di` - Step into
  - `do` - Step over
  - `dr` - Open REPL
  - `dt` - Toggle debug UI
- `<leader>q` - QML
  - `qf` - Format QML
  - `qn` - Edit QML config

## QML Language Server

If qmlls is not in your PATH, set the QT_QMLLS_BIN environment variable:
```bash
export QT_QMLLS_BIN=/path/to/qt/bin/qmlls
```

## Troubleshooting

1. If clangd complains about missing compile_commands.json:
   - Run `:MakeCompileDB` and select your build system
   
2. If QML LSP is not working:
   - Ensure Qt is installed and qmlls is in PATH
   - Set QT_QMLLS_BIN if needed
