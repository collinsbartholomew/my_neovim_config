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
    local emmet_ok, _ = pcall(function() return lspconfig.emmet_ls end)
    if emmet_ok then
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
    end

    -- Set up CSS language server
    local css_ok, _ = pcall(function() return lspconfig.cssls end)
    if css_ok then
        lspconfig.cssls.setup({
            settings = {
                css = { validate = true },
                scss = { validate = true },
                less = { validate = true },
            },
        })
    end

    -- Set up HTML language server
    local html_ok, _ = pcall(function() return lspconfig.html end)
    if html_ok then
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
end

return M