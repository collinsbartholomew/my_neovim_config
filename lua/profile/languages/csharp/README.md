# C# Language Support

This module provides comprehensive C# support for Neovim, including LSP (OmniSharp), debugging (netcoredbg), and various tools for game development (Unity), GUI applications (WPF, WinForms, MAUI), and backend services (ASP.NET Core).

## Prerequisites

1. Install .NET SDK:
   ```bash
   # Arch Linux
   sudo pacman -S dotnet-sdk dotnet-runtime
   
   # Ubuntu/Debian
   sudo apt install dotnet-sdk-6.0
   
   # macOS
   brew install dotnet
   ```

## Mason Packages

The following packages can be installed via Mason:

- `omnisharp` - C# language server
- `netcoredbg` - Debugger for .NET Core applications

To install via Mason:
```vim
:MasonInstall omnisharp netcoredbg
```

## Manual Installation

If Mason doesn't provide the correct binaries, you can install manually:

### OmniSharp

1. Download from [OmniSharp releases](https://github.com/OmniSharp/omnisharp-roslyn/releases)
2. Extract to a directory of your choice
3. Set `OMNISHARP_PATH` environment variable to point to the OmniSharp executable

Example:
```bash
# Download and extract OmniSharp
curl -L https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v1.39.11/omnisharp-linux-x64.tar.gz | tar xz -C ~/.local/share/nvim/mason/packages/

# Add to your shell profile (.bashrc, .zshrc, etc.)
export OMNISHARP_PATH="$HOME/.local/share/nvim/mason/packages/omnisharp/OmniSharp"
```

### netcoredbg

On Arch Linux:
```bash
yay -S netcoredbg-bin
```

Or download from [netcoredbg releases](https://github.com/Samsung/netcoredbg/releases):
```bash
# Download and extract netcoredbg
wget https://github.com/Samsung/netcoredbg/releases/download/2.0.0-895/netcoredbg-linux-amd64.tar.gz
tar xzvf netcoredbg-linux-amd64.tar.gz -C ~/.local/bin/

# Add to your shell profile
export NETCOREDBG_PATH="$HOME/.local/bin/netcoredbg"
```

## Features

### Language Server Protocol (LSP)
- Uses `omnisharp` for advanced C# language features
- Inlay hints for types, variables, and function parameters
- Code actions and refactoring
- Go to definition, references, implementation
- Hover documentation
- Code lens for running tests and other actions
- Support for .csproj, .sln files, NuGet packages, Unity scripts

### Debugging (DAP)
- Uses `netcoredbg` for native .NET debugging
- Support for debugging console apps, web apps, and unit tests
- Remote debugging capabilities
- Variable inspection and watches
- Breakpoint management
- Support for async/await debugging

### Formatting
- Uses `dotnet format` for code formatting
- Automatic formatting on save

### Linting
- Uses `dotnet build` for compile-time errors
- Roslyn analyzers for style/performance/security checks

### Testing
- Integration with `neotest` for running tests
- Support for xUnit, NUnit, and MSTest
- Test coverage reports

### Tools and Utilities
- Memory profiling with `dotnet-trace` and `dotnet-counters`
- Package management with `dotnet add/remove/list package`
- Project management with build, run, publish, watch commands
- Vulnerability scanning with `dotnet list package --vulnerable`

## Keymaps

### C# Commands (`<leader>cs`)
- `<leader>csb` - Build project
- `<leader>cst` - Run tests
- `<leader>csr` - Run project
- `<leader>csf` - Format code
- `<leader>csw` - Watch project
- `<leader>csp` - Publish project
- `<leader>csc` - Clean project
- `<leader>csR` - Restore packages

### Game/Unity Development (`<leader>csg`)
- `<leader>csgb` - Build Unity project
- `<leader>csgr` - Run Unity project
- `<leader>csgp` - Publish Unity (Windows)

### GUI Development (`<leader>csgui`)
- `<leader>csguib` - Build GUI project
- `<leader>csguir` - Run GUI project
- `<leader>csguiw` - Watch GUI project
- `<leader>csguip` - Publish GUI (Windows)
- `<leader>csguim` - Publish GUI (macOS)
- `<leader>csguil` - Publish GUI (Linux)

### Backend Development (`<leader>csb`)
- `<leader>csbb` - Build backend
- `<leader>csbr` - Run backend
- `<leader>csbw` - Watch backend
- `<leader>csbm` - Run migrations
- `<leader>csbs` - Update database

### Package Management (`<leader>csp`)
- `<leader>cspa` - Add package
- `<leader>cspr` - Remove package
- `<leader>cspl` - List packages
- `<leader>cspo` - List outdated packages
- `<leader>cspv` - Check vulnerabilities

### Memory/Performance (`<leader>csm`)
- `<leader>csmt` - Collect trace
- `<leader>csmc` - Monitor counters

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

### Software Engineering (`<leader>se`)
- `<leader>sec` - Coverage
- `<leader>ser` - Reformat
- `<leader>set` - Test
- `<leader>sef` - Restore packages
- `<leader>sel` - Lint/Build

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

### OmniSharp
- `<leader>or` - Reload OmniSharp server
- `<leader>op` - Pick project/solution

## Usage

### Commands

- `:DotnetBuild` - Build the project
- `:DotnetTest` - Run tests
- `:DotnetRun` - Run the project
- `:DotnetFormat` - Format code
- `:DotnetWatch` - Watch project for changes
- `:DotnetPublish` - Publish the project
- `:DotnetClean` - Clean the project
- `:DotnetRestore` - Restore packages
- `:DotnetAddPackage` - Add a NuGet package
- `:DotnetRemovePackage` - Remove a NuGet package
- `:DotnetListPackages` - List NuGet packages
- `:DotnetOutdated` - List outdated packages
- `:DotnetVulnerabilities` - Check for vulnerable packages
- `:DotnetTrace` - Collect performance trace
- `:DotnetCounters` - Monitor performance counters
- `:OmniReload` - Restart OmniSharp server

## Configuration

To configure OmniSharp options, you can pass a config table to the setup function:

```lua
require('profile.languages.csharp').setup({
  cmd = { "path/to/omnisharp", "-lsp" } -- Custom OmniSharp command
})
```