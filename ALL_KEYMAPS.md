# Neovim Keymap Reference

## General
- `<Space>` - Leader key
- `<leader>tt` - Cycle through themes (tokyonight and rose-pine variants)
- `<leader>h` - Clear search highlights

## Navigation
- `<C-h/j/k/l>` - Window navigation
- `<C-Up/Down/Left/Right>` - Resize windows
- `<S-h/l>` - Previous/Next buffer
- `<leader>bd` - Delete buffer

## File Management
- `<leader>e` - Toggle file explorer
- `<leader>o` - Focus file explorer

## Search (Telescope)
- `<leader>ff` - Find files
- `<leader>ft` - Find text (grep)
- `<leader>fp` - Find projects
- `<leader>fb` - Find buffers
- `<leader>fh` - Find help tags
- `<leader>fo` - Find recent files
- `<leader>fm` - Find marks

## Terminal
- `<leader>tf` - Float terminal
- `<leader>th` - Horizontal terminal
- `<leader>tv` - Vertical terminal

## LSP
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Find references
- `gi` - Go to implementation
- `K` - Show hover documentation
- `<C-k>` - Show signature help
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>f` - Format code

## Git
- `<leader>gg` - Toggle Git status
- `<leader>gj/gk` - Next/Previous Git hunk
- `<leader>gs` - Stage hunk
- `<leader>gu` - Undo stage hunk
- `<leader>gp` - Preview hunk
- `<leader>gb` - Blame line
- `<leader>gd` - Show diff

## Snippets
- `<C-j>` - Expand snippet or jump forward
- `<C-k>` - Jump backward in snippet
- `<Tab>` - Next completion item
- `<S-Tab>` - Previous completion item

## Debug
- `<F5>` - Start/Continue debugger
- `<F10>` - Step over
- `<F11>` - Step into
- `<F12>` - Step out
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>dl` - Open debug log
- `<leader>dr` - Toggle REPL

## Diagnostics (Trouble)
- `<leader>xx` - Toggle trouble
- `<leader>xw` - Workspace diagnostics
- `<leader>xd` - Document diagnostics
- `<leader>xq` - Quickfix list
- `<leader>xl` - Location list
