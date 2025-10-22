# Java Language Support

This module provides comprehensive Java support for Neovim, including LSP (JDTLS), debugging, and various tools for enterprise development, Android development, and microservices.

## Prerequisites

### Install JDK

You need to manually install a JDK. Recommended versions are JDK 17 or JDK 21.

#### Arch Linux:
```bash
# MANUAL - DO NOT RUN AUTOMATICALLY
sudo pacman -S --needed openjdk-21-jdk openjdk-17-jdk maven gradle --noconfirm
```

#### Ubuntu/Debian:
```bash
# MANUAL - DO NOT RUN AUTOMATICALLY
sudo apt update
sudo apt install openjdk-21-jdk maven gradle
```

#### macOS:
```bash
# MANUAL - DO NOT RUN AUTOMATICALLY
brew install openjdk@21 maven gradle
```

### Install JDTLS

You can install JDTLS via Mason:
```vim
:MasonInstall jdtls
```

Or manually:
1. Download from [Eclipse JDT Language Server](https://download.eclipse.org/jdtls/milestones/)
2. Extract to a directory like `~/.local/share/jdtls`

### Install Debug Bundles

For debugging support, you need to build the required bundles:

```bash
# MANUAL - DO NOT RUN AUTOMATICALLY
mkdir -p ~/.local/share/nvim/java_debug
cd ~/.local/share/nvim/java_debug

# java-debug
git clone https://github.com/microsoft/java-debug.git
cd java-debug
./mvnw -DskipTests clean package
# Copy the jar to the java_debug directory

# vscode-java-test
cd ~/.local/share/nvim/java_debug
git clone https://github.com/microsoft/vscode-java-test.git
cd vscode-java-test
./mvnw -DskipTests clean package
# Copy the produced jars to the java_debug directory
```

### Install Google Java Format (Optional)

For code formatting:
```bash
# MANUAL - DO NOT RUN AUTOMATICALLY
curl -L https://github.com/google/google-java-format/releases/latest/download/google-java-format-*-all-deps.jar -o ~/google-java-format.jar
sudo mv ~/google-java-format.jar /usr/local/bin/
sudo chmod +x /usr/local/bin/google-java-format.jar
```

Or add an alias to your shell profile:
```bash
alias google-java-format='java -jar /usr/local/bin/google-java-format.jar'
```

## Environment Variables

If you've installed JDK in a custom location, set:
```bash
export JDTLS_JAVA_HOME="/path/to/your/jdk"
```

## Features

### Language Server Protocol (LSP)
- Uses `jdtls` for advanced Java language features
- Inlay hints for types, variables, and method parameters
- Code actions and refactoring (extract method/variable, organize imports)
- Go to definition, references, implementation across jars
- Hover documentation
- Code lens for running/debugging tests and other actions
- Support for Maven/Gradle projects, Spring Boot, Jakarta EE

### Debugging (DAP)
- Uses `java-debug-adapter` for native JVM debugging
- Support for debugging console apps, web apps, and unit tests
- Remote debugging capabilities
- Variable inspection and watches with hot swap
- Breakpoint management with conditional breakpoints
- Support for debugging lambdas and streams

### Formatting
- Uses `google-java-format` for code formatting
- Automatic formatting on save

### Linting
- Uses `checkstyle` for static analysis
- PMD/SpotBugs for bug detection
- OWASP Dependency-Check for security vulnerabilities

### Testing
- Integration with `neotest` for running tests
- Support for JUnit 4/5 and TestNG
- Test coverage reports with JaCoCo

### Tools and Utilities
- Memory profiling with jvisualvm or MAT
- Security analysis with OWASP Dependency-Check
- Package management with Maven/Gradle commands
- Dependency analysis with jdeps
- JFR (Java Flight Recorder) profiling

## Keymaps

### Java Commands (`<leader>j`)
- `<leader>job` - Maven build
- `<leader>jot` - Maven test
- `<leader>jor` - Maven run
- `<leader>joc` - Maven clean
- `<leader>jgb` - Gradle build
- `<leader>jgt` - Gradle test
- `<leader>jgr` - Gradle run
- `<leader>jgc` - Gradle clean
- `<leader>jf` - Format code
- `<leader>jo` - Organize imports
- `<leader>jv` - Extract variable
- `<leader>jc` - Extract constant
- `<leader>jm` - Extract method
- `<leader>jt` - Test class
- `<leader>jT` - Test method
- `<leader>ju` - Update project config
- `<leader>jp` - Show memory layout
- `<leader>js` - Security check
- `<leader>jm` - Heap dump

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
- `<leader>sef` - Dependencies
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

## Usage

### Commands

- `:JavaFormat` - Format Java code
- `:MavenBuild` - Build with Maven
- `:MavenTest` - Run Maven tests
- `:MavenRun` - Run with Maven
- `:MavenClean` - Clean with Maven
- `:GradleBuild` - Build with Gradle
- `:GradleTest` - Run Gradle tests
- `:GradleRun` - Run with Gradle
- `:GradleClean` - Clean with Gradle
- `:RunTests` - Run tests
- `:JavaRun` - Run Java program
- `:StartJFR`/:StopJFR - JFR profiling helpers
- `:StartAsyncProfiler` - Async profiler helper
- `:JavaPackageAnalyze` - Analyze package dependencies
- `:JavaCoverage` - Coverage instructions
- `:JavaSecurityCheck` - Security vulnerability scan
- `:JavaHeapDump` - Heap dump instructions
- `:JavaRestartServer` - Restart JDTLS

## Configuration

To configure Java options, you can pass a config table to the setup function:

```lua
require('profile.languages.java').setup({
  -- Custom configuration options
})
```

## Formatting

To enable formatting on save with conform.nvim, add this to your conform setup:

```lua
require("conform").setup({
  formatters_by_ft = {
    java = { "google_java_format" },
  },
})
```

Note: By default, format_on_save is disabled. You can enable it in your conform configuration if desired.