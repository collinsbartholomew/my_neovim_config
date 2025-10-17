local M = {}

function M.setup()
    vim.diagnostic.config({
        virtual_text = {
            enabled = true,
            prefix = "●",
            source = "if_many",
            spacing = 2,
            format = function(diagnostic)
                local source = diagnostic.source or "LSP"
                local message = diagnostic.message
                if source == "clang" then
                    message = string.gsub(message, "^clang: %s*", "")
                end
                return string.format("%s: %s", source, message)
            end,
        },
        signs = { active = true },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
            format = function(diagnostic)
                local source = diagnostic.source or "LSP"
                local message = diagnostic.message
                if source == "clang" then
                    message = string.gsub(message, "^clang: %s*", "")
                end
                return string.format("%s: %s", source, message)
            end,
        },
    })

    -- Enable inlay hints by default for Neovim 0.10+
    if vim.fn.has('nvim-0.10') == 1 then
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
                end
            end,
        })
    end

    local signs = {
        DiagnosticSignError = " ",
        DiagnosticSignWarn = " ",
        DiagnosticSignHint = " ",
        DiagnosticSignInfo = " "
    }
    for name, icon in pairs(signs) do
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    end

    vim.api.nvim_create_user_command("LspSummary", function()
        print("=== LSP Summary ===\n")

        local version = vim.version()
        print("Neovim version: " .. version.major .. "." .. version.minor .. "." .. version.patch)

        if not vim.lsp then
            print("❌ LSP not available")
            return
        end
        print("✅ LSP available")

        local mason_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
        if mason_ok then
            print("✅ Mason available")
            local installed = mason_lspconfig.get_installed_servers()
            print("\nInstalled servers (" .. #installed .. "):")
            for _, server in ipairs(installed) do
                print("- " .. server)
            end
        else
            print("❌ Mason not available")
        end

        local clients = vim.lsp.get_clients()
        print("\nActive clients (" .. #clients .. "):")
        for _, client in ipairs(clients) do
            print("  - " .. client.name)
        end
    end, {})

    _G.current_theme = _G.current_theme or "rose-pine"
end

return M