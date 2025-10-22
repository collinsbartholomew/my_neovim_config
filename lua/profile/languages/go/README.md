# Go Integration for Neovim

This module provides full Go development support: LSP (gopls), DAP (delve), formatting (gofumpt, goimports), linting (staticcheck, golangci-lint), and test running (neotest-go).

## Features

### Language Server Protocol (LSP)
- Uses `gopls` for advanced Go language features
- Inlay hints for types, variables, and function parameters
- Code actions and refactoring
- Go to definition, references, implementation
- Hover documentation
- Code lens for running tests, benchmarks, and other actions

### Debugging (DAP)
- Uses `delve` for native Go debugging
- Support for debugging programs, tests, and benchmarks
- Remote debugging capabilities
- Goroutine and variable inspection
- Breakpoint management

### Formatting
- Uses `goimports` to manage imports automatically
- Uses `gofumpt` for stricter formatting than `gofmt`
- Automatic formatting on save

### Linting
- Uses `golangci-lint` for comprehensive code analysis
- Staticcheck integration
- Asynchronous linting on file save

### Testing
- Integration with `neotest` for running tests
- Test coverage reports
- Benchmark running

### Tools and Utilities
- Memory profiling with `pprof`
- Security scanning with `gosec`
- Race condition detection
- Dependency management with `go mod tidy`
- Documentation viewer with `go doc`

## Mason Packages
- gopls
- delve
- gofumpt
- goimports
- staticcheck

## Manual Installs (if not in Mason)
- golangci-lint: `sudo pacman -S golangci-lint` or `go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest`
- goimports-reviser: `go install github.com/incu6us/goimports-reviser/v2@latest`
- gosec: `go install github.com/securego/gosec/v2/cmd/gosec@latest`

## Keymaps

### Go Commands (`<leader>go`)
- `<leader>gob` - Build project
- `<leader>gor` - Run project
- `<leader>got` - Run tests
- `<leader>goB` - Run benchmarks
- `<leader>gof` - Format buffer
- `<leader>goc` - Coverage report
- `<leader>gov` - Run go vet
- `<leader>gom` - Run go mod tidy
- `<leader>gog` - Run go generate
- `<leader>gol` - Run go lint
- `<leader>god` - Show go doc
- `<leader>gop` - Run go pprof
- `<leader>gos` - Run security scan (gosec)
- `<leader>goR` - Run race detector

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
- `<leader>sef` - Tidy
- `<leader>sel` - Lint
- `<leader>ses` - Security scan
- `<leader>seR` - Race detector

### LSP Features (`<leader>l`)
- `<leader>lh` - Hover
- `<leader>lr` - Rename
- `<leader>la` - Code action
- `<leader>ld` - Diagnostics
- `<leader>lf` - Format
- `<leader>lg` - Go doc
- `<leader>li` - Implementation
- `<leader>ls` - Document symbols
- `<leader>lw` - Workspace symbols
- `<leader>lt` - Run CodeLens

## Common Commands
- Format: `<leader>gof` or `<leader>rf`
- Lint: `<leader>gol` (runs GoLint)
- Test: `<leader>got` (package), `<leader>rtf` (single)
- Debug: `<leader>dc` (continue), `<leader>d*` (DAP controls)

## Troubleshooting
- If gopls or delve are missing, run `:Mason` and install them.
- If formatting fails, ensure gofumpt/goimports are installed and on PATH.
- For DAP, ensure delve is installed and up-to-date.
- For linting, ensure golangci-lint is installed and on PATH.

## Settings
- See lsp.lua for gopls tuning (staticcheck, gofumpt, analyses, hints).
- See tools.lua for formatter and test runner setup.
- See debug.lua for delve configuration.

## Manual Steps
- Install missing tools via Mason, pacman, or go install as listed above.
- Ensure $GOBIN is on your PATH for Go tools.