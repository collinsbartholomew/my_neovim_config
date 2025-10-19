local M = {}

function M.setup()
    require("typescript-tools").setup({
        settings = {
            -- Specify typescript server path
            tsserver_path = vim.fn.system("which typescript-language-server"):gsub("\n", ""),
            -- Enable JSX/TSX support
            jsx_close_tag = {
                enable = true,
                filetypes = { "javascriptreact", "typescriptreact" },
            },
            code_completion = {
                enable = true,
                trigger_characters = { ".", ":", "(", "'", '"', "[", ",", "#", "*", "@", "|", "=", "-", "{", " " },
            },
            tsserver_plugins = {
                "@styled/typescript-styled-plugin",
            },
            tsserver_file_preferences = {
                includeCompletionsForModuleExports = true,
                includeCompletionsForImportStatements = true,
                importModuleSpecifierPreference = "relative",
            },
            tsserver_format_options = {
                allowIncompleteCompletions = true,
                allowRenameOfImportPath = true,
            },
        },
    })

    -- Set up file type detection
    vim.filetype.add({
        extension = {
            js = "javascript",
            jsx = "javascriptreact",
            ts = "typescript",
            tsx = "typescriptreact",
        },
        filename = {
            ["package.json"] = "json",
            [".eslintrc.json"] = "json",
            [".prettierrc"] = "json",
        },
        pattern = {
            [".*/%.env.*"] = "sh",
        },
    })

    -- Ensure required npm packages are installed
    vim.fn.system("npm list -g typescript typescript-language-server || npm install -g typescript typescript-language-server")
    vim.fn.system("npm list -g @styled/typescript-styled-plugin || npm install -g @styled/typescript-styled-plugin")
end

return M
