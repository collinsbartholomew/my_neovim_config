-- added-by-agent: csharp-setup 20251020-153000
-- mason: omnisharp
-- manual: dotnet-sdk installation required

local M = {}

-- Function to find OmniSharp binary
local function get_omnisharp_cmd()
    -- Check OMNISHARP_PATH environment variable first
    local omnisharp_path = os.getenv("OMNISHARP_PATH")
    if omnisharp_path and vim.fn.executable(omnisharp_path) == 1 then
        return { omnisharp_path, "-lsp" }
    end

    -- Check for Mason installed OmniSharp
    local mason_registry = package.loaded["mason-registry"]
    if mason_registry and mason_registry.is_installed("omnisharp") then
        local omnisharp_pkg = mason_registry.get_package("omnisharp")
        local install_path = omnisharp_pkg:get_install_path()

        -- Different paths based on OS and OmniSharp distribution
        local possible_paths = {
            install_path .. "/OmniSharp.exe", -- Windows
            install_path .. "/omnisharp/OmniSharp.exe", -- Linux/OmniSharp-mono
            install_path .. "/OmniSharp", -- Linux/OmniSharp-Roslyn
            install_path .. "/bin/omnisharp", -- Potential future path
        }

        for _, path in ipairs(possible_paths) do
            if vim.fn.executable(path) == 1 then
                -- For OmniSharp.exe, we might need to use mono
                if path:match("%.exe$") then
                    if vim.fn.executable("mono") == 1 then
                        return { "mono", path, "-lsp" }
                    end
                else
                    return { path, "-lsp" }
                end
            end
        end
    end

    -- Check system OmniSharp
    if vim.fn.executable("omnisharp") == 1 then
        return { "omnisharp", "-lsp" }
    end

    -- Fallback - notify user
    vim.notify(
            "OmniSharp not found. Please install OmniSharp via Mason or set OMNISHARP_PATH.",
            vim.log.levels.WARN
    )

    return nil
end

function M.setup(config)
    config = config or {}

    local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
    if not lspconfig_ok then
        vim.notify("lspconfig not available for C# setup", vim.log.levels.ERROR)
        return
    end

    local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if not cmp_nvim_lsp_status_ok then
        vim.notify("cmp_nvim_lsp not available", vim.log.levels.WARN)
        return
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    local cmd = get_omnisharp_cmd()
    if not cmd then
        return
    end

    -- Override cmd if provided in config
    if config.cmd then
        cmd = config.cmd
    end

    lspconfig.omnisharp.setup({
        cmd = cmd,
        root_dir = lspconfig.util.root_pattern(".sln", ".csproj", "global.json", ".git"),
        on_attach = function(client, bufnr)
            -- Standard LSP keymaps
            local function buf_set_keymap(...)
                vim.api.nvim_buf_set_keymap(bufnr, ...)
            end
            local opts = { noremap = true, silent = true }

            buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
            buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
            buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
            buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
            buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
            buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
            buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
            buf_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
            buf_set_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)
            buf_set_keymap('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
            buf_set_keymap('n', '<leader>lw', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)

            -- Enable inlay hints if available
            pcall(function()
                if client.supports_method("textDocument/inlayHint") then
                    vim.lsp.inlay_hint(bufnr, true)
                end
            end)

            -- Format on save
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = bufnr })
                    end,
                })
            end

            -- Register language specific keymaps
            require("profile.languages.csharp.mappings").lsp(bufnr)
        end,
        capabilities = capabilities,
        settings = {
            FormattingOptions = {
                EnableEditorConfigSupport = true,
                OrganizeImports = true,
            },
            MsBuild = {
                LoadProjectsOnDemand = true,
                UseLegacySdkResolver = false,
            },
            RoslynExtensionsOptions = {
                EnableAnalyzersSupport = true,
                AnalyzersSupport = true,
                EnableImportCompletion = true,
                EnableAsyncCompletion = true,
                DocumentAnalysisTimeoutMs = 30000,
            },
            OmniSharp = {
                UseModernNet = true,
                EnableDecompilationSupport = true,
                EnableLspEditorSupport = true,
                EnableCSharp7Support = true,
                EnableCSharp8Support = true,
                EnableCSharp9Support = true,
                EnableCSharp10Support = true,
                EnableCSharp11Support = true,
            }
        },
    })
end

return M