# Java Language Support

This module provides comprehensive Java support for Neovim, including LSP (JDTLS), debugging, and various tools.

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

## Usage

### Key mappings

Leader key is space by default.

#### Java commands
- `<leader>jb` - Build project (Maven/Gradle)
- `<leader>jt` - Run tests (:RunTests)
- `<leader>jr` - Run program (:JavaRun)
- `<leader>jf` - Format code (:JavaFormat)
- `<leader>jo` - Organize imports
- `<leader>jv` - Extract variable
- `<leader>jc` - Extract constant

#### Debugging
- `<leader>dd` - Continue debugging
- `<leader>db` - Toggle breakpoint
- `<leader>dr` - Restart debugging
- `<leader>dt` - Debug test

#### Tools
- `<leader>vj` - Analyze dependencies (:JavaPackageAnalyze)
- `<leader>vc` - Code coverage (:JavaCoverage)

### Commands

- `:JavaFormat` - Format Java code
- `:MavenBuild` - Build with Maven
- `:GradleBuild` - Build with Gradle
- `:RunTests` - Run tests
- `:JavaRun` - Run Java program
- `:StartJFR`/:StopJFR - JFR profiling helpers
- `:StartAsyncProfiler` - Async profiler helper
- `:JavaPackageAnalyze` - Analyze package dependencies
- `:JavaCoverage` - Coverage instructions
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