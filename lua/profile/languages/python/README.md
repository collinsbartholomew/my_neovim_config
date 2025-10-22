# Python Language Support

## Features

### Language Server Protocol (LSP)
- Uses `pyright` for advanced Python language features
- Type checking and inference
- Auto-imports and code actions
- Go to definition, references, implementation
- Hover documentation
- Code lens for running/debugging tests
- Support for virtual environments, Poetry, and Pipenv

### Debugging (DAP)
- Uses `debugpy` for native Python debugging
- Support for debugging scripts, Flask/Django/FastAPI apps, and Jupyter notebooks
- Remote debugging capabilities
- Variable inspection and watches for complex types
- Breakpoint management

### Formatting
- Uses `ruff` and `black` for code formatting
- Automatic formatting on save

### Linting
- Uses `ruff` for static analysis
- PEP8 compliance checking
- Performance and bug detection

### Testing
- Integration with `neotest` for running tests
- Support for pytest and unittest
- Test coverage reports

### Tools and Utilities
- Memory profiling with memory_profiler
- CPU profiling with cProfile
- Security analysis with bandit
- Dependency vulnerability scanning with pip-audit
- Virtual environment management
- Dependency management with pip
- Dependency visualization with pipdeptree

## Components
- LSP: pyright (Mason)
- DAP: debugpy (Mason)
- Formatters: black, ruff, isort (Mason/pipx)
- Linters: ruff (Mason/pipx)
- Test runner: neotest-python

## Mason packages
- pyright
- debugpy
- black
- ruff
- isort

## Manual installation (if needed)
```bash
# Using pipx (recommended)
pipx install black
pipx install ruff
pipx install isort
pipx install debugpy
pipx install pytest
pipx install coverage
pipx install bandit
pipx install memory-profiler
pipx install snakeviz
pipx install pip-audit
pipx install pipdeptree

# Or using pip in a virtual environment
pip install black ruff isort debugpy pytest coverage bandit memory-profiler snakeviz pip-audit pipdeptree
```

## Keymaps

### Python Commands (`<leader>py`)
- `<leader>pyb` - Run file (:PythonRun)
- `<leader>pyt` - Run tests (:PythonTest)
- `<leader>pyc` - Coverage report (:PythonCoverage)
- `<leader>pyf` - Format code (:PythonFormat)
- `<leader>pyl` - Lint code (:PythonLint)
- `<leader>pys` - Security scan (:PythonSecurity)
- `<leader>pym` - Memory profile (:PythonMemory)
- `<leader>pyP` - CPU profile (:PythonProfile)
- `<leader>pyv` - Create virtual env (:PythonVenv)
- `<leader>pyr` - Generate requirements (:PythonRequirements)
- `<leader>pyi` - Install requirements (:PythonInstall)
- `<leader>pya` - Audit dependencies (:PythonAudit)
- `<leader>pyd` - Show dependencies (:PythonDeps)

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

### Testing (`<leader>t`)
- `<leader>tf` - Run file tests
- `<leader>tt` - Run nearest test
- `<leader>to` - Show test output
- `<leader>ts` - Toggle test summary
- `<leader>tc` - Debug nearest test

### Software Engineering (`<leader>se`)
- `<leader>sec` - Coverage
- `<leader>ser` - Reformat
- `<leader>set` - Test
- `<leader>sel` - Lint
- `<leader>ses` - Security scan

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

## Virtual Environment Support
The Python configuration will automatically detect and use your virtual environment if you have one activated (VIRTUAL_ENV environment variable).

## Usage

### Commands

- `:PythonRun` - Run Python file
- `:PythonTest` - Run tests
- `:PythonCoverage` - Generate coverage report
- `:PythonFormat` - Format code with black
- `:PythonLint` - Lint code with ruff
- `:PythonSecurity` - Security scan with bandit
- `:PythonMemory` - Memory profile with memory_profiler
- `:PythonProfile` - CPU profile with cProfile
- `:PythonVenv` - Create virtual environment
- `:PythonRequirements` - Generate requirements.txt
- `:PythonInstall` - Install from requirements.txt
- `:PythonAudit` - Audit dependencies for security vulnerabilities
- `:PythonDeps` - Show dependency tree