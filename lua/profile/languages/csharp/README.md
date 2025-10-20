# C# Language Support

This module provides comprehensive C# support for Neovim, including LSP (OmniSharp), debugging (netcoredbg), and various tools.

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

## Usage

### Key mappings

Leader key is space by default.

#### C# commands
- `<leader>cb` - Build project (:DotnetBuild)
- `<leader>ct` - Run tests (:DotnetTest)
- `<leader>cr` - Run project (:DotnetRun)
- `<leader>cf` - Format code (:DotnetFormat)

#### Debugging
- `<leader>dd` - Continue debugging
- `<leader>db` - Toggle breakpoint
- `<leader>dr` - Restart debugging
- `<leader>ds` - Step over
- `<leader>di` - Step into
- `<leader>do` - Step out
- `<leader>du` - Toggle debug UI

#### OmniSharp
- `<leader>or` - Reload OmniSharp server
- `<leader>op` - Pick project/solution

### Commands

- `:DotnetBuild` - Build the project
- `:DotnetTest` - Run tests
- `:DotnetRun` - Run the project
- `:DotnetFormat` - Format code
- `:OmniReload` - Restart OmniSharp server

## Configuration

To configure OmniSharp options, you can pass a config table to the setup function:

```lua
require('profile.languages.csharp').setup({
  cmd = { "path/to/omnisharp", "-lsp" } -- Custom OmniSharp command
})
```