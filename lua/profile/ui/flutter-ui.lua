-- added-by-agent: flutter-setup 20251020-160000
-- mason: dart-debug-adapter
-- manual: flutter/dart/fvm install commands listed in README

local M = {}

function M.setup()
    -- Configure diagnostics
    vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 2 },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    })

    -- Set update time for CursorHold events
    vim.o.updatetime = 250

    -- Show diagnostics on hover
    vim.api.nvim_create_autocmd("CursorHold", {
        pattern = "*.dart",
        callback = function()
            vim.diagnostic.open_float(nil, { focus = false })
        end,
    })

    -- Enable inlay hints for Dart files when LSP attaches
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and (client.name == "dartls" or client.name == "flutter") then
                local bufnr = args.buf
                pcall(function()
                    if client.supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint(bufnr, true)
                    end
                end)
            end
        end,
    })
end

-- Function to get current device (non-blocking)
function M.get_current_device()
    local Job = require("plenary.job")

    Job:new({
        command = "flutter",
        args = { "devices", "--machine" },
        on_exit = function(job, return_val)
            if return_val == 0 then
                local result = job:result()
                -- Process the result to get current device
                -- This is just a placeholder implementation
                vim.notify("Current device info retrieved", vim.log.levels.INFO)
            else
                vim.notify("Failed to get device info", vim.log.levels.WARN)
            end
        end,
    }) :start()
end

return M