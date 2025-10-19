# Modern Neovim Configuration

A modern, fast, and feature-rich Neovim configuration focused on development productivity.

## Features

- 🎨 Multiple theme support (tokyonight and rose-pine variants)
- 🚀 Fast startup with lazy loading
- 📦 Automatic LSP configuration
- ⚡ Instant file navigation with Telescope
- 🔍 Native LSP support with automatic server installation
- 📝 Smart snippets and completion
- 🎯 Git integration
- 🐛 Built-in debugging support
- 📊 Status line and buffer line
- 🌲 File tree with git status

## Requirements

- Neovim >= 0.9.0
- Git
- A C compiler for TreeSitter
- Node.js for LSP servers
- Ripgrep for Telescope
- A Nerd Font for icons

## Installation

1. Back up your existing Neovim configuration:
```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

2. Clone this repository:
```bash
git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
```

3. Start Neovim:
```bash
nvim
```

The configuration will automatically:
- Install the package manager (lazy.nvim)
- Install all plugins
- Set up LSP servers
- Configure TreeSitter parsers

## Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── core/               # Core configuration
│   ├── plugins/            # Plugin specifications
│   ├── langs/              # Language-specific settings
│   └── tools/              # Development tools
└── ALL_KEYMAPS.md         # Keybinding reference
```

## Key Features

### LSP Support
- Automatic server installation
- Intelligent code completion
- Real-time diagnostics
- Code actions and refactoring
- Symbol search and navigation

### Snippets
- Built-in snippet support
- VS Code snippet compatibility
- Custom snippet creation
- Tab completion and navigation

### File Navigation
- Fuzzy finding
- Live grep
- File tree
- Buffer management

### Development Tools
- Integrated terminal
- Git integration
- Debugging support
- Testing framework

### Theme Support
- Multiple theme variants
- Easy theme switching (`<leader>tt`)
- Customizable UI elements

## Customization

The configuration uses tabs by default for indentation. To modify:
1. Edit `lua/core/options.lua` for global settings
2. Edit `lua/core/lsp.lua` for language-specific settings

## Troubleshooting

If you encounter issues:
1. Run `:checkhealth` for diagnostics
2. Ensure all requirements are installed
3. Update plugins with `:Lazy sync`
4. Update LSP servers with `:Mason`

## Keybindings

See [ALL_KEYMAPS.md](ALL_KEYMAPS.md) for a complete reference of keybindings.

## License

MIT License
