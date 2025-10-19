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
    if pcall(require, "lspconfig") then
        require("lspconfig").hypr.setup({
            capabilities = require("core.lsp").get_capabilities(),
            on_attach = function(client, bufnr)
                require("core.lsp").on_attach(client, bufnr)
            end,
        })
    end
end

return M
