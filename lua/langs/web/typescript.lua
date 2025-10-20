local M = {}

function M.setup()
    --Set up file type detection
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
end

return M
