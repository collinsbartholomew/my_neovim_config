local M = {}

local function augroup(name)
    return vim.api.nvim_create_augroup("enhanced_" .. name, { clear = true })
end

function M.setup()
    -- Highlight on yank
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = augroup("highlight_yank"),
        callback = function()
            vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
        end,
    })

    -- Resize splits if window got resized
    vim.api.nvim_create_autocmd({ "VimResized" }, {
        group = augroup("resize_splits"),
        callback = function()
            local current_tab = vim.fn.tabpagenr()
            vim.cmd("tabdo wincmd =")
            vim.cmd("tabnext " .. current_tab)
        end,
    })

    -- Auto create dir when saving a file
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        group = augroup("auto_create_dir"),
        callback = function(event)
            if event.match:match("^%w%w+://") then
                return
            end
            local file = vim.loop.fs_realpath(event.match) or event.match
            vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        end,
    })

    -- Check if file changed when its window is focused
    vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
        group = augroup("checktime"),
        command = "checktime",
    })

    -- Close certain filetypes with q
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup("close_with_q"),
        pattern = {
            "help",
            "man",
            "notify",
            "qf",
            "spectre_panel",
            "startuptime",
            "tsplayground",
            "neotest-output",
            "checkhealth",
            "neotest-summary",
            "neotest-output-panel",
        },
        callback = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", {
                buffer = event.buf,
                silent = true,
            })
        end,
    })

    -- Wrap and check for spell in text filetypes
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup("wrap_spell"),
        pattern = { "gitcommit", "markdown", "text" },
        callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
        end,
    })

    -- Fix conceallevel for json & help files
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup("json_conceal"),
        pattern = { "json", "jsonc", "json5" },
        callback = function()
            vim.opt_local.conceallevel = 0
        end,
    })

    -- Set indent size for specific filetypes
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup("indent_size"),
        pattern = {
            "lua",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "css",
            "scss",
            "html",
            "xml",
            "yaml",
            "json",
            "terraform",
        },
        callback = function()
            vim.opt_local.shiftwidth = 2
            vim.opt_local.tabstop = 2
            vim.opt_local.softtabstop = 2
        end,
    })

    -- Auto format on save if formatter available
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup("auto_format"),
        callback = function(event)
            local filetype = vim.bo[event.buf].filetype
            local formatters = require("core.lsp").get_formatters_for_ft(filetype)
            if #formatters > 0 then
                vim.lsp.buf.format({ timeout_ms = 3000, async = false })
            end
        end,
    })

    -- Enable cursorline in active window only
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
        group = augroup("cursorline_on"),
        callback = function()
            local buftype = vim.bo.buftype
            if buftype ~= "terminal" then
                vim.opt_local.cursorline = true
            end
        end,
    })

    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
        group = augroup("cursorline_off"),
        callback = function()
            vim.opt_local.cursorline = false
        end,
    })

    -- Start git messages in insert mode
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup("git_insert"),
        pattern = { "gitcommit", "gitrebase" },
        command = "startinsert | 1",
    })

    -- Switch to insert mode when terminal is opened
    vim.api.nvim_create_autocmd("TermOpen", {
        group = augroup("terminal_insert"),
        callback = function()
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.cmd("startinsert")
        end,
    })

    -- Automatically reload buffers when files change on disk
    vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
        group = augroup("auto_reload"),
        callback = function()
            if not vim.fn.getcmdwintype() and vim.fn.mode() ~= "c" then
                vim.cmd("checktime")
            end
        end,
    })
end

return M
