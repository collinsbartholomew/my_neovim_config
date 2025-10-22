-- Conform.nvim setup (formatters)
local conform_status, conform = pcall(require, "conform")
if not conform_status then
    vim.notify("Conform.nvim not available", vim.log.levels.WARN)
    return
end

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff", "black" },
        java = { "google-java-format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        go = { "goimports", "gofumpt" },
        html = { "prettier" },
        jsx = { "prettier" },
        tsx = { "prettier" },
        xml = { "xmllint" },
        css = { "prettier" },
        scss = { "prettier" },
        sass = { "prettier" },
        less = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        handlebars = { "prettier" },
        hbs = { "prettier" },
        php = { "php_cs_fixer", "phpcbf" },
        vue = { "prettier" },
        svelte = { "prettier" },
        astro = { "prettier" },
        mdx = { "prettier" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        ruby = { "rubocop" },
        dart = { "dart_format" },
        zig = { "zigfmt" },
        csharp = { "csharpier" },
        sql = { "sqlfluff" },
        graphql = { "prettier" },
        yaml = { "yamlfix" },
        toml = { "taplo" },
        fish = { "fish_indent" },
        elixir = { "mix_format" },
        erlang = { "erlfmt" },
        haskell = { "fourmolu" },
        ocaml = { "ocamlformat" },
        scala = { "scalafmt" },
        asm = { "asmfmt" },
        nasm = { "asmfmt" },
        gas = { "asmfmt" },
        qml = { "qmlformat" },
        -- Add more
    },
    format_on_save = { timeout_ms = 500, lsp_fallback = true },

    -- Add formatter definitions with command validation
    formatters = {
        injected = { options = { ignore_errors = true } },
        prettier = {
            condition = function(_, ctx)
                -- Check for package.json in the current directory or its parents
                local found = vim.fs.find({ "package.json" }, { path = ctx.dirname, upward = true })[1]
                -- If no package.json found, still allow prettier to run (fallback to global installation)
                return found or vim.fn.executable("prettier") == 1
            end,
            -- Configure prettier with dynamic args based on file type
            prepend_args = function(ctx)
                local args = { "--tab-width", "2", "--use-tabs" }
                -- For XML/HTML-like files, use 2-character indentation
                local xml_html_files = {
                    html = true, jsx = true, tsx = true, xml = true,
                    css = true, scss = true, sass = true, less = true,
                    handlebars = true, hbs = true, php = true,
                    vue = true, svelte = true, astro = true, mdx = true
                }
                if xml_html_files[vim.bo[ctx.buf].ft] then
                    args = { "--tab-width", "2", "--use-tabs" }
                end
                return args
            end,
        },
        ["clang-format"] = {
            -- Configure clang-format to use tabs and 4-character indentation
            prepend_args = { "--style=file" },
        },
        rustfmt = {
            -- Configure rustfmt to use tabs and 4-character indentation
            prepend_args = { "--config-path", vim.fn.expand("~/.config/nvim/rustfmt.toml") },
        },
        xmllint = {
            -- xmllint doesn't have specific indentation options, but we'll keep the default behavior
        },
        shfmt = {
            -- Configure shfmt to use tabs and 4-character indentation
            prepend_args = { "-i", "4", "-ci", "-sr" },
        },
        rubocop = {
            -- Configure RuboCop to use tabs and 4-character indentation
            prepend_args = { "-c", vim.fn.expand("~/.config/nvim/.rubocop.yml") },
        },
        dart_format = {
            -- Dart formatter
            command = "dart",
            args = { "format" },
        },
        zigfmt = {
            -- Zig formatter
            command = "zig",
            args = { "fmt", "--stdin" },
        },
        csharpier = {
            -- C# formatter
            command = "dotnet",
            args = { "csharpier", "--config", vim.fn.expand("~/.config/nvim/.csharpierrc"), "-" },
        },
        sqlfluff = {
            -- SQL formatter
            command = "sqlfluff",
            args = { "format", "--config", vim.fn.expand("~/.config/nvim/.sqlfluff"), "-" },
        },
        yamlfix = {
            -- YAML formatter
            command = "yamlfix",
            args = { "--config-file", vim.fn.expand("~/.config/nvim/.yamlfix.toml"), "-" },
        },
        taplo = {
            -- TOML formatter
            command = "taplo",
            args = { "format", "--config", vim.fn.expand("~/.config/nvim/.taplo.toml"), "-" },
        },
        fish_indent = {
            -- Fish shell formatter
            command = "fish_indent",
            args = { "-" },
        },
        mix_format = {
            -- Elixir formatter
            command = "mix",
            args = { "format", "-" },
        },
        erlfmt = {
            -- Erlang formatter
            command = "erlfmt",
            args = { "--config-file", vim.fn.expand("~/.config/nvim/.erlfmt"), "-" },
        },
        fourmolu = {
            -- Haskell formatter
            command = "fourmolu",
            args = { "--config-file", vim.fn.expand("~/.config/nvim/fourmolu.yaml"), "-" },
        },
        ocamlformat = {
            -- OCaml formatter
            command = "ocamlformat",
            args = { "--enable-outside-detected-project", "--name", "stdin", "--impl", "--config-file", vim.fn.expand("~/.config/nvim/.ocamlformat") },
        },
        scalafmt = {
            -- Scala formatter
            command = "scalafmt",
            args = { "--config-str", "{indentSize=4, style=defaultWithAlign}", "--stdin" },
        },
        asmfmt = {
            -- Assembly formatter
            command = "asmfmt",
            args = { "-" },
        },
        qmlformat = {
            -- QML formatter
            command = "qmlformat",
            args = { "-" },
        },
        gofumpt = {
            -- Go formatter
            command = "gofumpt",
            args = { "-" },
        },
        goimports = {
            -- Go imports formatter
            command = "goimports",
            args = { "-" },
        },
        ["google-java-format"] = {
            -- Java formatter
            command = "google-java-format",
            args = { "-" },
        },
        black = {
            -- Python formatter
            command = "black",
            args = { "-" },
        },
        ruff = {
            -- Python formatter/linter
            command = "ruff",
            args = { "check", "--fix", "-" },
        },
    },
})

-- Add a function to check if formatters are available
local function validate_formatters()
    local formatters = {
        stylua = "stylua",
        black = "black",
        ["google-java-format"] = "google-java-format",
        prettier = "prettier",
        ["clang-format"] = "clang-format",
        xmllint = "xmllint",
        rustfmt = "rustfmt",
        shfmt = "shfmt",
        rubocop = "rubocop",
        dart_format = "dart",
        zigfmt = "zig",
        csharpier = "dotnet",
        sqlfluff = "sqlfluff",
        yamlfix = "yamlfix",
        taplo = "taplo",
        fish_indent = "fish_indent",
        mix_format = "mix",
        erlfmt = "erlfmt",
        fourmolu = "fourmolu",
        ocamlformat = "ocamlformat",
        scalafmt = "scalafmt",
        asmfmt = "asmfmt",
        qmlformat = "qmlformat",
        gofumpt = "gofumpt",
        goimports = "goimports",
        htmlhint = "htmlhint",
        stylelint = "stylelint",
    }

    for name, cmd in pairs(formatters) do
        local found = vim.fn.executable(cmd) == 1
        if not found then
            vim.notify("Formatter '" .. cmd .. "' not found. Install it to enable formatting for this language.", vim.log.levels.WARN)
        end
    end
end

-- Run validation after a short delay to not block startup
vim.defer_fn(validate_formatters, 1000)

return {}