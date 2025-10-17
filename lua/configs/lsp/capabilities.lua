local M = {}

function M.setup()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
    }

    if vim.fn.has('nvim-0.10') == 1 then
        capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
        capabilities.textDocument.semanticTokens = { multilineTokenSupport = true }
        capabilities.textDocument.inlayHint = { dynamicRegistration = true }
        capabilities.textDocument.codeLens = { dynamicRegistration = true }
        capabilities.textDocument.documentHighlight = { dynamicRegistration = true }
        capabilities.workspace = {
            didChangeWatchedFiles = { dynamicRegistration = true },
            workspaceFolders = true,
            configuration = true,
        }
    end

    local cmp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
    if cmp_ok and cmp_lsp and cmp_lsp.default_capabilities then
        capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
    end

    return capabilities
end

return M