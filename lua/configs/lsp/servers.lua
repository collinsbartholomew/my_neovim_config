local M = {}

-- Return a table of LSP server configurations (subset of original lsp-unified)
-- Only include data; setup is performed by autostart or lspconfig depending on Neovim version

local util_ok, util = pcall(require, 'lspconfig.util')

M.servers = {
    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
                telemetry = { enable = false },
                hint = { enable = true },
            },
        },
    },

    biome = {
        root_dir = util_ok and util.root_pattern('biome.json', 'biome.jsonc', 'package.json', '.git') or vim.fn.getcwd(),
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
        settings = {
            biome = { linter = { enabled = true }, formatter = { enabled = true }, organizeImports = { enabled = true } },
        },
        cmd = { vim.fn.stdpath('data') .. '/mason/bin/biome', 'lsp-proxy' },
    },

    ts_ls = {
        root_dir = util_ok and util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git') or nil,
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
                suggest = {
                    completeFunctionCalls = true,
                    includeCompletionsForImportStatements = true,
                    includeCompletionsWithSnippetText = true,
                    autoImports = true,
                    includeAutomaticOptionalChainCompletions = true,
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
                suggest = {
                    completeFunctionCalls = true,
                    includeCompletionsForImportStatements = true,
                    includeCompletionsWithSnippetText = true,
                    autoImports = true,
                    includeAutomaticOptionalChainCompletions = true,
                },
            },
        },
    },

    rust_analyzer = { root_dir = util_ok and util.root_pattern('Cargo.toml', '.git') or nil, settings = { ['rust-analyzer'] = {} } },
    gopls = { root_dir = util_ok and util.root_pattern('go.mod', 'go.work', '.git') or nil, settings = {} },

    clangd = (function()
        local cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--completion-style=detailed", "--function-arg-placeholders", "--enable-config" }
        local ndk = os.getenv('ANDROID_NDK_HOME') or os.getenv('ANDROID_NDK_ROOT')
        if ndk and ndk ~= '' then
            local query = table.concat({ ndk .. "/toolchains/llvm/prebuilt/*/bin/*", ndk .. "/toolchains/*/prebuilt/*/bin/*" }, ",")
            table.insert(cmd, "--query-driver=" .. query)
        end
        if vim.loop.os_uname().sysname == 'Darwin' then
            table.insert(cmd, "--header-insertion-decorators=false")
        end
        return { cmd = cmd, root_dir = util_ok and util.root_pattern('CMakeLists.txt', 'compile_commands.json', '.git') or vim.fn.getcwd(), filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp", "h" }, init_options = { usePlaceholders = true, completeUnimported = true, clangdFileStatus = true } }
   end)(),

    pyright = { root_dir = util_ok and util.root_pattern('pyproject.toml', 'setup.py', 'requirements.txt', '.git') or nil, settings = {} },

    html = { filetypes = { 'html', 'htm', 'htmldjango', 'handlebars', 'hbs', 'mustache', 'templ', 'ejs', 'erb', 'twig', 'pug' } },
    cssls = { filetypes = { 'css', 'scss', 'less', 'sass' } },
    zls = { root_dir = util_ok and util.root_pattern('build.zig', 'zig.mod', '.git') or nil, filetypes = { 'zig' } },

    tailwindcss = {
        root_dir = util_ok and util.root_pattern('tailwind.config.js', 'tailwind.config.ts', 'postcss.config.js', 'package.json', '.git') or nil,
        filetypes = { 'html', 'css', 'scss', 'less', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte', 'vue', 'astro' },
        init_options = { userLanguages = { ['javascript'] = 'javascript', ['javascriptreact'] = 'html' } },
        settings = {
            tailwindCSS = {
                includeLanguages = { javascript = 'javascript', typescript = 'typescript', javascriptreact = 'typescriptreact', typescriptreact = 'typescriptreact' },
                lint = { cssConflict = 'warning', invalidApply = 'error' },
                validate = true,
                experimental = { classRegex = { 'class\\s*[:=]\\s*"([^"]*)"', 'className\\s*[:=]\\s*"([^"]*)"', 'tw\\(["\']?([^)"\']*)["\']?\)' } },
            },
        },
    },

    eslint = {
        on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            vim.keymap.set('n', '<leader>le', '<cmd>EslintFixAll<cr>', { buffer = bufnr, desc = 'ESLint Fix All' })
        end,
        settings = {},
    },

    jsonls = {}, yamlls = {}, emmet_ls = { filetypes = {} }, lemminx = { filetypes = {} }, bashls = {},
}

-- Add vtsls as the primary LSP for JS/TS
M.servers.vtsls = {
    root_dir = util_ok and util.root_pattern('package.json', '.git') or vim.fn.getcwd(),
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayVariableTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
            },
        },
    },
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/vtsls' },
}

-- Ensure no formatting conflicts with biome
M.servers.vtsls.settings.typescript.format = { enable = false }
M.servers.ts_ls.settings.typescript.format = { enable = false }

return M
