# Flutter & Dart Language Support

This module provides comprehensive Flutter and Dart support for Neovim, including LSP, debugging, device management, and various tools.

## Prerequisites

### Install Flutter & Dart

You need to manually install Flutter and Dart SDKs:

#### Arch Linux:
```bash
# MANUAL - DO NOT RUN AUTOMATICALLY
sudo pacman -S --needed flutter dart
```

#### Ubuntu/Debian:
```bash
# MANUAL - DO NOT RUN AUTOMATICALLY
sudo apt update
sudo apt install snapd
sudo snap install flutter --classic
```

#### macOS:
```bash
# MANUAL - DO NOT RUN AUTOMATICALLY
brew install flutter
```

### Install FVM (Flutter Version Management) - Optional

```bash
# MANUAL - DO NOT RUN AUTOMATICALLY
dart pub global activate fvm
```

Make sure to add `~/.pub-cache/bin` to your PATH:
```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### Install dart-debug-adapter

You can install the debug adapter via Mason:
```vim
:MasonInstall dart-debug-adapter
```

Or manually:
```bash
# MANUAL - DO NOT RUN AUTOMATICALLY
dart pub global activate dart-debug-adapter
```

Make sure to add `~/.pub-cache/bin` to your PATH:
```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

## Environment Variables

If you've installed the dart-debug-adapter manually, you may need to set:
```bash
export DART_DEBUG_ADAPTER_PATH="$(which dart-debug-adapter)"
```

## Usage

### Key mappings

Leader key is space by default.

#### Flutter commands
- `<leader>frf` - Run Flutter app (:FlutterRun)
- `<leader>frh` - Hot reload (:FlutterReload)
- `<leader>frR` - Full restart
- `<leader>ft` - Run tests (:FlutterTest)
- `<leader>fd` - Run Flutter doctor (:FlutterDoctor)

#### Debugging
- `<leader>dd` - Continue debugging
- `<leader>db` - Toggle breakpoint
- `<leader>dr` - Open REPL
- `<leader>ds` - Step over
- `<leader>di` - Step into
- `<leader>do` - Step out
- `<leader>du` - Toggle debug UI

#### Devices and DevTools
- `<leader>vd` - Select device
- `<leader>vv` - Open DevTools (:DevTools)

### Commands

- `:FlutterRun` - Run the Flutter app
- `:FlutterTest` - Run Flutter tests
- `:FlutterReload` - Hot reload the app
- `:DartFormat` - Format Dart code
- `:DevTools` - Open Flutter DevTools
- `:MemoryProfile` - Profile memory usage
- `:SecurityAudit` - Audit dependencies for security issues
- `:SecurityScan` - Scan for vulnerabilities
- `:FlutterDoctor` - Run Flutter doctor
- `:FvmUse <version>` - Use specific Flutter version with FVM

## Configuration

To enable FVM support, pass a config table to the setup function:

```lua
require('profile.languages.flutter').setup({
  use_fvm = true
})
```

## Formatting

To enable formatting on save with conform.nvim, add this to your conform setup:

```lua
require("conform").setup({
  formatters_by_ft = {
    dart = { "dart_format" },
  },
})
```

Note: By default, format_on_save is disabled. You can enable it in your conform configuration if desired.