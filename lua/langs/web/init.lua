local M = {}

function M.setup()
    -- Load all web development related configurations
    require("langs.web.typescript").setup()

    -- Set up LSP if available
    local ok, lspconfig = pcall(require, "lspconfig")
    if not ok then
        return
    end

    -- Set up emmet for HTML/CSS
    lspconfig.emmet_ls.setup({
        filetypes = {
            "html",
            "css",
            "scss",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
        },
    })

    -- Set up CSS language server
    lspconfig.cssls.setup({
        settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
        },
    })

    -- Set up HTML language server
    lspconfig.html.setup({
        filetypes = { "html", "htmldjango" },
        init_options = {
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = {
                css = true,
                javascript = true,
            },
        },
    })
end

return M