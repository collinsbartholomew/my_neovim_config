local M = {}

function M.setup()
    -- Set up Hyprland specific configuration
    vim.filetype.add({
        pattern = {
            [".*/hypr/.*%.conf"] = "hyprlang",
            [".*hyprland%.conf"] = "hyprlang",
        },
    })

    -- Set up treesitter parser if available
    pcall(function()
        require("nvim-treesitter.parsers").get_parser_configs().hyprlang = {
            install_info = {
                url = "https://github.com/luckasRanarison/tree-sitter-hyprlang",
                files = { "src/parser.c" },
                branch = "master",
            },
        }
    end)

    -- Configure LSP if available
    local lsp_ok, lspconfig = pcall(require, "lspconfig")
    if lsp_ok then
        -- Check if the hypr LSP is available before trying to set it up
        local hypr_ok, _ = pcall(function() return lspconfig.hypr end)
        if hypr_ok then
            lspconfig.hypr.setup({
                capabilities = require("core.lsp").get_capabilities(),
                on_attach = function(client, bufnr)
                    require("core.lsp").on_attach(client, bufnr)
                end,
            })
        end
    end
end

return M