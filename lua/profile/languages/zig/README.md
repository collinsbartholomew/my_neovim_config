# Zig Integration for Neovim

## Features
- LSP support via zls
- Debugging support via codelldb
- Build, Run, and Test commands
- Auto-formatting
- Treesitter integration
- Which-key mappings

## Keybindings
- `<leader>zb` - Build project
- `<leader>zr` - Run current file
- `<leader>zt` - Run tests
- `<leader>zf` - Format buffer
- `<leader>zd` subcommands:
  - `b` - Toggle breakpoint
  - `c` - Continue
  - `s` - Step over
  - `i` - Step into
  - `o` - Step out
  - `u` - Toggle debug UI

## Manual Installation Steps
If using Zig nightly, you may need to build zls from source:
```bash
git clone https://github.com/zigtools/zls
cd zls
zig build -Drelease-safe
# Copy the binary to ~/.local/bin or configure zls.zig_exe_path
```

If Mason's codelldb installation fails:
```bash
# On Arch Linux:
sudo pacman -S --needed codelldb lldb llvm
# Or via AUR:
yay -S codelldb-vscode
```
