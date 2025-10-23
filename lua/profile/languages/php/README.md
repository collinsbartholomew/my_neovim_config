# PHP Language Support

This module provides comprehensive PHP language support including:

- LSP (Language Server Protocol) with intelephense or phpactor
- Debugging with Xdebug via nvim-dap
- Formatting with php-cs-fixer
- Linting with phpstan or phpcs
- Laravel framework support
- Blade template support

## Features

### Language Server Protocol (LSP)
- Code completion
- Go to definition
- Find references
- Rename symbols
- Code actions
- Diagnostics

### Debugging
- Xdebug integration
- Breakpoints
- Variable inspection
- Stack trace navigation

### Formatting
- PSR-12 compliant formatting
- Automatic formatting on save

### Linting
- Static analysis with PHPStan
- Code quality checks

### Framework Support
- Laravel-specific features
- Blade template support
- Artisan command integration

## Keybindings

- `<leader>P` - PHP operations
- `<leader>Pf` - Find file
- `<leader>Pm` - Navigate module
- `<leader>Pc` - Composer operations
- `<leader>Pl` - Laravel operations
- `<leader>Pt` - PHP testing
- `<leader>Pr` - PHP refactoring

## Requirements

- PHP 7.4 or higher
- Composer
- php-cs-fixer for formatting
- phpstan for linting
- Xdebug for debugging (optional)