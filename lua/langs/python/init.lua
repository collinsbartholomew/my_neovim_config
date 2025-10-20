local M = {}

function M.setup()
    -- Python language support
    vim.filetype.add({
        extension = {
            py = "python",
        },
    })

    -- Set up LSP if available
    local ok, lspconfig = pcall(require, "lspconfig")
    if ok then
        lspconfig.pyright.setup({
            settings = {
                python = {
                    analysis = {
                        autoImportCompletions = true,
                        diagnosticMode = "workspace",
                        inlayHints = {
                            variableTypes = true,
                            functionReturnTypes = true,
                        },
                    },
                },
            },
        })
    end

    -- Set up debugging if available
    local dap_ok, dap_python = pcall(require, "dap-python")
    if dap_ok then
        dap_python.setup("python")
    end
end

return M