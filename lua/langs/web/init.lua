local M = {}

function M.setup()
    -- Load all web development related configurations
    require("langs.web.typescript").setup()

    -- Set up emmet for HTML/CSS
    require("lspconfig").emmet_ls.setup({
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
    require("lspconfig").cssls.setup({
        settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
        },
    })

    -- Set up HTML language server
    require("lspconfig").html.setup({
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
