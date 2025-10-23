# Web Development Support

This module provides comprehensive web development support for Neovim, including LSP, debugging, and various tools for front-end and fullstack development.

## Features

- TypeScript/JavaScript Language Server (ts_ls)
- HTML, CSS, JSON, and Tailwind CSS language servers
- Debugging support with js-debug-adapter
- Code formatting with prettier
- Linting with eslint
- Emmet support for HTML/CSS
- DAP (Debug Adapter Protocol) integration

## Prerequisites

### Install Node.js and pnpm

You can install Node.js and pnpm using Volta:

```bash
# MANUAL - DO NOT RUN AUTOMATICALLY
curl https://get.volta.sh | bash
volta install node
volta install pnpm
```

Or using your system's package manager.

### Install Development Dependencies

For formatting and linting, install these development dependencies in your project:

```bash
# MANUAL - DO NOT RUN AUTOMATICALLY
pnpm add -D @fsouza/prettierd eslint_d prettier eslint typescript
```

## Mason Packages

The following packages can be installed via Mason:

- `ts_ls` - TypeScript/JavaScript language server
- `tailwindcss-language-server` - Tailwind CSS language server
- `prettier` - Code formatter
- `eslint` - Linter
- `js-debug-adapter` - JavaScript/TypeScript debugger

To install via Mason:
```vim
:MasonInstall ts_ls tailwindcss-language-server prettier eslint js-debug-adapter
```

## Usage

### Key mappings

Leader key is space by default.

#### Web commands
- `<leader>wi` - Install dependencies with pnpm (:PnpmInstall)
- `<leader>wI` - Install dependencies with npm (:NpmInstall)
- `<leader>wd` - Start dev server with pnpm (:StartDevPnpm)
- `<leader>wD` - Start dev server with npm (:StartDev)
- `<leader>wf` - Format code (:WebFormat)

#### Debugging
- `<leader>dt` - Toggle breakpoint
- `<leader>dc` - Continue debugging
- `<leader>do` - Step over
- `<leader>di` - Step into
- `<leader>du` - Step out
- `<leader>dU` - Toggle debug UI
- And many more debug commands (see mappings.lua for full list)

### Commands

- `:NpmInstall` - Run npm install in a terminal buffer
- `:PnpmInstall` - Run pnpm install in a terminal buffer
- `:StartDev` - Run npm run dev in a terminal buffer
- `:StartDevPnpm` - Run pnpm run dev in a terminal buffer
- `:WebFormat` - Format the current buffer using LSP

## Configuration

The web module is automatically loaded as part of the profile system. To customize the setup, you can modify the individual files in this directory:

- `lsp.lua` - Language server configuration
- `dap.lua` - Debug adapter configuration
- `tools.lua` - Development tools and commands
- `mappings.lua` - Key mappings

## Emmet Support

Emmet is enabled for the following filetypes:
- html
- css
- scss
- javascript
- typescript
- jsx
- tsx

Use Ctrl+e to expand abbreviations in insert mode.