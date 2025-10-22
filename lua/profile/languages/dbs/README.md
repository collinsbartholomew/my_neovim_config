# Database Support

## Components
- Plugins: vim-dadbod, vim-dadbod-ui
- Terminal integration: toggleterm

## Features
- Database UI with DBUI command
- Quick execution of SQL queries
- Support for multiple database connections
- Mongo shell integration
- Postgres integration

## Configuration
Database connections are configured in your init.lua or in a separate configuration file.
See the init.lua file for examples of how to configure connections.

## Keymaps
- `<leader>ds` - Open DB UI
- `<leader>dq` - Toggle DB UI
- `<leader>dr` - Run SQL (normal mode: current line, visual mode: selection)
- `<leader>dm` - Toggle Mongo shell
- `<leader>sm` - Send to Mongo shell (normal mode: current line, visual mode: selection)