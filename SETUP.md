# Neovim Configuration Setup Guide

## Prerequisites

Ensure you have the following installed:
- Neovim >= 0.8.0 (0.9.0+ recommended)
- git
- gcc/clang
- node/npm
- python3/pip
- rust/cargo
- go

## Installation

1. Back up your existing configuration:
```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

2. Install this configuration:
```bash
git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
```

3. First Run:
- Launch Neovim and wait for lazy.nvim to install plugins
- Mason will automatically install required language servers
- Run `:checkhealth` to verify your setup

## Features

### Language Support

- Web Development (JavaScript/TypeScript/HTML/CSS)
- System Programming (C/C++/Rust/Go)
- Python Development
- Lua Development
- Configuration Languages (JSON/YAML)

### Key Features

- Modern LSP configuration with inlay hints
- Treesitter-based syntax highlighting
- Efficient fuzzy finding with Telescope
- Git integration with advanced features
- Debugging support for multiple languages
- Task running and project management
- Smart code completion

### Key Mappings

- Space is the leader key
- Leader + f: File operations
- Leader + l: LSP operations
- Leader + g: Git operations
- Leader + b: Buffer operations
- Leader + t: Terminal/Task operations
- Leader + x: Trouble/Diagnostics

## Troubleshooting

If you encounter issues:

1. Run `:checkhealth` to identify problems
2. Ensure all required dependencies are installed
3. Check Mason package installation status with `:Mason`
4. Verify LSP servers with `:LspInfo`

## Updates

To update:

1. Update plugins: `:Lazy update`
2. Update tools: `:MasonUpdate`
3. Update Treesitter parsers: `:TSUpdate`

## Additional Notes

- The configuration uses modern Neovim features
- LSP servers are configured to provide rich IDE features
- Code formatting is set up to run on save
- Diagnostic information is displayed in real-time
