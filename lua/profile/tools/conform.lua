--Conform.nvim setup (formatters)
--This file configures the formatting engine for Neovim using conform.nvim
local conform_status, conform = pcall(require, "conform")
if not conform_status then
    -- If conform.nvim is not available, show a warning and exit
    vim.notify("Conform.nvim not available", vim.log.levels.WARN)
    return
end

-- Main conform.nvim setup
conform.setup({
    -- Map filetypes to their respective formatters
    -- Each filetype can have multiple formatters that will be tried in order
    formatters_by_ft = {
        lua = { "stylua" }, --Lua files use stylua
        python = { "ruff", "black" }, -- Python files use ruff then black
        java = { "google-java-format" }, -- Java files use google-java-format
        javascript = { "prettier", "eslint_d" }, -- JavaScript files use prettier then eslint_d
        typescript = { "prettier", "eslint_d" }, -- TypeScript files use prettier then eslint_d
        go = { "goimports", "gofumpt" }, -- Go files use goimports then gofumpt
        html = { "prettier" }, -- HTML files use prettier
        jsx = { "prettier" }, -- JSX files use prettier
        tsx = { "prettier" }, -- TSX files use prettier
        xml = { "prettier_xml" }, -- XML filesuse prettier with XML parser
        css = { "prettier" }, -- CSS files use prettier
        scss = { "prettier" }, -- SCSS files use prettier
        sass = { "prettier" }, -- SASS filesuse prettier
        less = { "prettier" }, -- LESS files use prettier
        json = { "prettier" }, -- JSON files use prettier
        yaml = { "prettier" }, -- YAML files use prettier
        markdown = { "prettier" }, -- Markdown files use prettier
        handlebars = { "prettier" }, -- Handlebars files use prettier
        hbs = { "prettier" }, -- Handlebars files use prettier
        php = { "phpcbf" }, -- PHP files use phpcbf
        vue = { "prettier" }, -- Vuefiles use prettier
        svelte = { "prettier" }, -- Svelte files use prettier
        astro = { "prettier" }, -- Astrofiles use prettier
        mdx = { "prettier" }, -- MDX files use prettier
        c = { "clang-format" }, -- C files use clang-format
        cpp = { "clang-format" }, -- C++ files use clang-format
        rust = { "rustfmt" }, -- Rust filesuse rustfmt
        sh = { "shfmt" }, -- Shell files use shfmt
        bash = { "shfmt" }, -- Bash files use shfmt
        ruby = { "rubocop" }, -- Ruby files use rubocop
        dart = { "dart_format" }, -- Dart files use dart_format
        zig = { "zigfmt" }, -- Zig files use zigfmt
        csharp = { "csharpier" }, -- C# files use csharpier
        sql = { "sqlfluff" }, --SQL files use sqlfluff
        graphql = { "prettier" }, -- GraphQL files use prettier
        yaml = { "yamlfix" }, -- YAML files use yamlfix
        toml = { "taplo" }, -- TOML files use taplo
        fish = { "fish_indent" }, -- Fishshell files use fish_indent
        elixir = { "mix_format" }, -- Elixir files use mix_format
        erlang = { "erlfmt" }, -- Erlang files use erlfmt
        ocaml = { "ocamlformat" }, -- OCaml files use ocamlformat
        scala = { "scalafmt" }, -- Scala files use scalafmt
        asm = { "asmfmt" }, -- Assembly files use asmfmt
        nasm = { "asmfmt" }, -- NASM files use asmfmt
        gas = { "asmfmt" }, -- GAS files use asmfmt
        qml = { "qmlformat" }, -- QML files use qmlformat
        -- Add more filetypes and their formatters as needed},

        -- Configure format-on-save behavior
        format_on_save = {
            timeout_ms = 500, -- Timeout after 500ms
            lsp_fallback = true    -- Fall back to LSP formatting if no conform formatter is available
        },

        -- Add formatter definitions with commandvalidation-- Customize how specific formatters behave
        formatters = {
            injected = { options = { ignore_errors = true }  -- Ignore errors in injected code
            },

            prettier = {
                -- Condition to check if prettier should run
                condition = function(_, ctx)
                    -- Check for package.jsonin the current directory or its parents
                    local found = false
                    if ctx and ctx.dirname then
                        found = vim.fs.find({ "package.json" }, { path = ctx.dirname, upward = true })[1]
                    end
                    -- If no package.json found, still allow prettier to run(fallback to global installation)
                    return found or vim.fn.executable("prettier") == 1
                end,

                -- Configure prettier with dynamic args based on file type
                prepend_args = function(ctx)
                    local args = { "--tab-width", "4", "--use-tabs" }
                    --ForXML/HTML-like files, use 3-space indentation as per user preference
                    local xml_html_files = {
                        html = true, jsx = true, tsx = true, xml = true,
                        css = true, scss = true, sass = true, less = true,
                        handlebars = true, hbs = true, php = true,
                        vue = true, svelte = true, astro = true, mdx = true
                    }
                    if ctx and ctx.ft and xml_html_files[ctx.ft] then
                        -- Use 4-space indentation with tabs for XML/HTML-like files
                        args = { "--tab-width", "4", "--use-tabs" }
                    end
                    return args
                end,
            },

            ["clang-format"] = {
                -- Configure clang-format to use tabs and 4-character indentation
                prepend_args = { "--style=file" }, -- Use .clang-format configuration file
            },

            rustfmt = {
                -- Configure rustfmt to use tabs and 4-character indentation
                prepend_args = { "--config-path", vim.fn.expand("~/.config/nvim/rustfmt.toml") }, -- Use custom config
            },

            xmllint = {
                -- xmllint doesn't have specific indentation options, but we'll keep the default behavior
            },

            prettier_xml = {
                command = "prettier",
                args = { "--tab-width", "3", "--no-use-tabs", "--parser", "xml" },
                condition = function()
                    return vim.fn.executable("prettier") == 1
                end,
            },

            shfmt = {
                -- Configure shfmt to use tabs and 4-character indentation
                prepend_args = { "-i", "4", "-ci", "-sr" }, -- 4-space indent, switch case indent, redirect spaces
            },

            rubocop = {
                -- Configure RuboCop to use tabs and 4-character indentation
                prepend_args = { "-c", vim.fn.expand("~/.config/nvim/.rubocop.yml") }, -- Use custom config
            },

            dart_format = {
                -- Dart formatter
                command = "dart", -- Use dart command
                args = { "format" }, -- Format subcommand
            },

            zigfmt = {
                -- Zigformatter
                command = "zig", -- Use zig command
                args = { "fmt", "--stdin" }, -- Format from stdin
            },

            csharpier = {
                -- C# formatter
                command = "dotnet", -- Use dotnet command
                args = { "csharpier", "--config", vim.fn.expand("~/.config/nvim/.csharpierrc"), "-" }, -- Use custom config
            },

            sqlfluff = {
                -- SQL formatter
                command = "sqlfluff", -- Use sqlfluff command
                args = { "format", "--config", vim.fn.expand("~/.config/nvim/.sqlfluff"), "-" }, -- Use custom config
                condition = function()
                    -- Check if sqlfluff is available
                    return vim.fn.executable("sqlfluff") == 1
                end,
            },

            yamlfix = {
                -- YAML formatter
                command = "yamlfix", -- Use yamlfix command
                args = { "--config-file", vim.fn.expand("~/.config/nvim/.yamlfix.toml"), "-" }, -- Use custom config
            },

            taplo = {
                -- TOML formatter
                command = "taplo", -- Use taplocommand
                args = { "format", "--config", vim.fn.expand("~/.config/nvim/.taplo.toml"), "-" }, -- Use custom config
            },

            fish_indent = {
                -- Fishshell formatter
                command = "fish_indent", -- Use fish_indent command
                args = { "-" }, -- Format from stdin
            },

            mix_format = {
                -- Elixir formatter
                command = "mix", -- Use mix command
                args = { "format", "-" }, -- Format from stdin
            },

            erlfmt = {
                -- Erlang formatter
                command = "erlfmt", -- Use erlfmt command
                args = { "--config-file", vim.fn.expand("~/.config/nvim/.erlfmt"), "-" }, -- Use custom config
            },
            fourmolu = {
                -- Haskell formatter
                command = "fourmolu", -- Use fourmolu command
                args = { "--config-file", vim.fn.expand("~/.config/nvim/fourmolu.yaml"), "-" }, -- Use custom config
            },

            ocamlformat = {
                -- OCaml formatter
                command = "ocamlformat", -- Use ocamlformat command
                args = { "--enable-outside-detected-project", "--name", "stdin", "--impl", "--config-file", vim.fn.expand("~/.config/nvim/.ocamlformat") }, -- Use custom config
            },

            scalafmt = {
                -- Scala formatter
                command = "scalafmt", -- Use scalafmt command
                args = { "--config-str", "{indentSize=4, style=defaultWithAlign}", "--stdin" }, -- Use inline config
            },

            asmfmt = {
                -- Assembly formatter
                command = "asmfmt", -- Use asmfmt command
                args = { "-" }, -- Format from stdin},
            },
            qmlformat = {
                -- QML formatter
                command = "qmlformat", -- Use qmlformat command
                args = { "-" }, -- Format from stdin
            },

            gofumpt = {
                -- Go formatter
                command = "gofumpt", -- Use gofumpt command
                args = { "-" }, -- Format from stdin
            },

            goimports = {
                -- Go imports formatter
                command = "goimports", -- Use goimports command
                args = { "-" }, -- Format from stdin
            },

            ["google-java-format"] = {
                -- Java formatter
                command = "google-java-format", -- Use google-java-format command
                args = { "-" }, -- Format from stdin
            },

            black = {
                -- Python formatter
                command = "black", -- Use black command
                args = { "-" }, -- Format from stdin
            },

            ruff = {
                --Python formatter/linter
                command = "ruff", -- Use ruff command
                args = { "check", "--fix", "-" }, -- Check and fix from stdin
            },

            eslint_d = {
                -- JavaScript/TypeScript linter
                command = "eslint_d", -- Use eslint_d command(daemon version)
                args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
                condition = function(_, ctx)
                    -- Check if eslint_d is available
                    local found = vim.fn.executable("eslint_d") == 1
                    if not found then
                        return false
                    end

                    -- Try to start eslint_d if not running
                    vim.fn.system("eslint_d start")

                    return true
                end,
                -- Increase timeout for eslint_d
                timeout_ms = 10000,
            },

            phpcbf = {
                -- PHP formatter (PHP_CodeSniffer)
                command = "phpcbf",
                args = { "--standard=PSR12", "-" },
            },
        }
    }

})

-- Add a function to check if formatters are available
-- This function validates that required formatters are installed
local function validate_formatters()
    -- List of formatters and theircorresponding commands to check
    local formatters = {
        stylua = "stylua", -- Lua formatter
        black = "black", -- Python formatter
        ["google-java-format"] = "google-java-format", -- Java formatter
        prettier = "prettier", -- JavaScript/TypeScript/HTML/CSS formatter
        ["clang-format"] = "clang-format", -- C/C++ formatter
        xmllint = "xmllint", -- XML linter
        rustfmt = "rustfmt", -- Rust formatter
        shfmt = "shfmt", -- Shell formatter
        rubocop = "rubocop", -- Ruby formatter
        dart_format = "dart", -- Dart formatter
        zigfmt = "zig", -- Zig formatter
        csharpier = "dotnet", -- C# formatter
        sqlfluff = "sqlfluff", -- SQL formatter
        yamlfix = "yamlfix", --YAML formatter
        taplo = "taplo", -- TOML formatter
        fish_indent = "fish_indent", -- Fish shell formatter
        mix_format = "mix", -- Elixir formatter
        erlfmt = "erlfmt", -- Erlang formatter
        fourmolu = "fourmolu", -- Haskell formatter
        ocamlformat = "ocamlformat", -- OCaml formatter
        scalafmt = "scalafmt", -- Scala formatter
        asmfmt = "asmfmt", -- Assembly formatter
        qmlformat = "qmlformat", -- QML formatter
        gofumpt = "gofumpt", --Go formatter
        goimports = "goimports", -- Go imports formatter
        htmlhint = "htmlhint", -- HTML linter
        stylelint = "stylelint", -- CSS/SCSS linter
        eslint_d = "eslint_d", -- JavaScript/TypeScript linter
    }

    -- Check each formatter and notify if not found
    for name, cmd in pairs(formatters) do
        local found = vim.fn.executable(cmd) == 1
        if not found then
            -- Notify user that a formatter is not installed
            vim.notify("Formatter '" .. cmd .. "' not found. Install it to enable formatting for this language.", vim.log.levels.WARN)
        end
    end
end

-- Run validation after a short delay to not block startup
-- This prevents the validation from slowing down Neovim startup
vim.defer_fn(validate_formatters, 1000)


-- Return empty table to satisfy module requirements
return {}
