--Autocommands
local api = vim.api

-- Create autocommand group
local profile_augroup = api.nvim_create_augroup("ProfileAutocommands", { clear = true })

-- Autoresizewindows
api.nvim_create_autocmd({ "VimResized" }, {
 group = profile_augroup,
    pattern = "*",
    command = "wincmd =",
})

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
    group = profile_augroup,
    pattern= "*",
    callback = function()
        vim.highlight.on_yank({timeout = 200 })
    end,
})

-- Auto remove trailing whitespace
api.nvim_create_autocmd("BufWritePre", {
    group = profile_augroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Autocreate dir if not exists
api.nvim_create_autocmd("BufWritePre", {
    group = profile_augroup,
    pattern = "*",
    callback = function(args)
        if not vim.fn.expand("%:p"):match("term://") then
            vim.fn.mkdir(vim.fn.expand("%:p:h"), "p")
     end
    end,
})

-- Auto close certain filetypes with q
api.nvim_create_autocmd("FileType", {
    group = profile_augroup,
    pattern = {
        "help",
        "startuptime",
        "qf",
        "lspinfo",
        "man",
        "spectre_panel",
        "dbui",
        "neotest-summary",
        "neotest-output",
        "neotest-output-panel",
        "aerial-nav",
        "PlenaryTestPopup",
        "grug-far",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- Auto close dap floats
api.nvim_create_autocmd("FileType", {
    group = profile_augroup,
    pattern = {
"dap-float",
    },
    callback = function(event)
        vim.keymap.set("n", "<ESC>", "<cmd>close!<cr>", { buffer = event.buf, silent = true })
    end,
})

-- Auto open diagnostics
api.nvim_create_autocmd("DiagnosticChanged", {
    group = profile_augroup,
    pattern = "*",
    callback = function()
        local diagnostics = vim.diagnostic.get(0)
        if #diagnostics > 0 then
            vim.diagnostic.open_float()
        end
    end,
})

-- Auto format on save
api.nvim_create_autocmd("BufWritePre",{
    group = profile_augroup,
    pattern = "*",
    callback = function()
        local conform_ok, conform = pcall(require, "conform")
        if conform_ok then
            conform.format({
                bufnr = 0,
                lsp_fallback = true,
                timeout_ms = 500,
            })
        end
    end,
})

-- Autotogglerelative numbers
api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
    group = profile_augroup,
    pattern = "*",
    callback = function()
        if vim.api.nvim_get_option_value("number", {}) then
            vim.api.nvim_set_option_value("relativenumber", true, {})
        end
    end,
})

api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
    group = profile_augroup,
    pattern ="*",
    callback = function()
        if vim.api.nvim_get_option_value("number", {}) then
            vim.api.nvim_set_option_value("relativenumber", false, {})
        end
    end,
})

-- Auto enable diagnostics for supported filetypes
api.nvim_create_autocmd("FileType",{
    group = profile_augroup,
    pattern = "*",
    callback = function(args)
        if vim.g.diagnostics_enabled == nil then
            vim.g.diagnostics_enabled =true
        end

        if vim.g.diagnostics_enabled then
            vim.diagnostic.enable(true, { bufnr = args.buf })
else
            vim.diagnostic.enable(false, { bufnr = args.buf })
        end
    end,
})

-- Run linter on save for supported filetypes
api.nvim_create_autocmd({ "BufWritePost" }, {
    group = profile_augroup,
    callback = function()
        local lint_ok, lint = pcall(require, "lint")
        if lint_ok then
            lint.try_lint()
            -- Run specific linters for C/C++ files
            localbuf_ft = vim.api.nvim_buf_get_option(0, "filetype")
            if buf_ft == "c" or buf_ft=="cpp" then
                lint.try_lint("clangtidy")
                lint.try_lint("cppcheck")
            elseif buf_ft == "qml" then
                lint.try_lint("qmllint")
            elseif buf_ft == "rust" then
                lint.try_lint("clippy")
           elseif buf_ft == "zig" then
                lint.try_lint("zls")
            elseif buf_ft == "go" then
                lint.try_lint("golangcilint")
            elseif buf_ft == "cs" then
                -- For C# files, we rely on OmniSharp for diagnostics
           elseif buf_ft == "java" then
                lint.try_lint("checkstyle")
            elseif buf_ft == "python" then
                lint.try_lint("ruff")
end
        end
    end,
})

-- Set specific options for Qt/QML files
api.nvim_create_autocmd("FileType",{
group = profile_augroup,
    pattern = { "qml" },
    callback = function()
        vim.api.nvim_buf_set_option(0, "tabstop", 4)
        vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
        vim.api.nvim_buf_set_option(0, "expandtab", true)
    end,
})

-- Set specific options for C/C++ files
api.nvim_create_autocmd("FileType", {
   group = profile_augroup,
    pattern = { "c", "cpp" },
    callback = function()
        vim.api.nvim_buf_set_option(0, "tabstop", 4)
        vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
        vim.api.nvim_buf_set_option(0, "expandtab", true)
       vim.api.nvim_buf_set_option(0, "textwidth", 100)
vim.api.nvim_buf_set_option(0, "colorcolumn", "100")
    end,
})

-- Set specific options for Rust files
api.nvim_create_autocmd("FileType", {
    group =profile_augroup,
    pattern = { "rust" },
    callback = function()
       vim.api.nvim_buf_set_option(0, "tabstop", 4)
        vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
        vim.api.nvim_buf_set_option(0, "expandtab", true)
       vim.api.nvim_buf_set_option(0, "textwidth", 100)
       vim.api.nvim_buf_set_option(0, "colorcolumn", "100")
    end,
})

-- Set specific options for Zigfiles
api.nvim_create_autocmd("FileType", {
    group = profile_augroup,
    pattern = { "zig" },
    callback = function()
        vim.api.nvim_buf_set_option(0, "tabstop", 4)
        vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
        vim.api.nvim_buf_set_option(0, "expandtab", true)
     vim.api.nvim_buf_set_option(0, "textwidth",100)
        vim.api.nvim_buf_set_option(0, "colorcolumn", "100")
    end,
})

-- Set specific options for Gofiles
api.nvim_create_autocmd("FileType", {
    group= profile_augroup,
    pattern = { "go" },
   callback = function()
        vim.api.nvim_buf_set_option(0, "tabstop", 4)
        vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
        vim.api.nvim_buf_set_option(0,"expandtab", false)
        vim.api.nvim_buf_set_option(0, "textwidth", 120)
        vim.api.nvim_buf_set_option(0, "colorcolumn", "120")
    end,
})

-- Set specific options for C# files
api.nvim_create_autocmd("FileType", {
group = profile_augroup,
    pattern = {"cs" },
    callback = function()
        vim.api.nvim_buf_set_option(0, "tabstop", 4)
        vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
        vim.api.nvim_buf_set_option(0, "expandtab", false)
        vim.api.nvim_buf_set_option(0, "textwidth", 120)
        vim.api.nvim_buf_set_option(0, "colorcolumn", "120")
    end,
})

-- Set specific options for Javafiles
api.nvim_create_autocmd("FileType", {
    group = profile_augroup,
    pattern = {"java" },
    callback = function()
        vim.api.nvim_buf_set_option(0, "tabstop", 4)
        vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
        vim.api.nvim_buf_set_option(0, "expandtab", true)
     vim.api.nvim_buf_set_option(0, "textwidth", 100)
        vim.api.nvim_buf_set_option(0, "colorcolumn", "100")
    end,
})

-- Set specific options for Pythonfiles
api.nvim_create_autocmd("FileType", {
    group = profile_augroup,
    pattern = { "python" },
    callback = function()
        vim.api.nvim_buf_set_option(0, "tabstop", 4)
        vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
        vim.api.nvim_buf_set_option(0, "expandtab", true)
    vim.api.nvim_buf_set_option(0, "textwidth", 88)
        vim.api.nvim_buf_set_option(0, "colorcolumn", "88")
    end,
})

--Set specific options for Mojo files
api.nvim_create_autocmd("FileType", {
    group = profile_augroup,
    pattern = { "mojo" },
    callback = function()
vim.api.nvim_buf_set_option(0, "tabstop", 4)
        vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
        vim.api.nvim_buf_set_option(0, "expandtab", true)
        vim.api.nvim_buf_set_option(0, "textwidth", 100)
        vim.api.nvim_buf_set_option(0, "colorcolumn", "100")
    end,
})

-- Setfoldlevel to show all folds by default (disable auto folding)
api.nvim_create_autocmd("BufReadPost", {
    group = profile_augroup,
    pattern = "*",
    callback = function()
        vim.api.nvim_buf_set_option(0, "foldlevel", 99)
    end,
})

--FormatLua files on save
api.nvim_create_autocmd("BufWritePre", {
    group = profile_augroup,
    pattern = { "*.lua"},
    callback = function()
        local conform_ok, conform = pcall(require, "conform")
        if conform_ok then
            conform.format({
                bufnr= 0,
                lsp_fallback = true,
                timeout_ms = 500,
            })
        end
    end,
})

-- Runlinter on save for Lua files
api.nvim_create_autocmd({ "BufWritePost" }, {
    group = profile_augroup,
    pattern = { "*.lua" },
    callback = function()
        local lint_ok, lint = pcall(require, "lint")
        if lint_ok then
            lint.try_lint("luacheck")
        end
    end,
})

--Format web files on save
api.nvim_create_autocmd("BufWritePre", {
    group = profile_augroup,
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.html", "*.css", "*.scss", "*.json" },
    callback = function()
        local conform_ok,conform = pcall(require, "conform")
        if conform_ok then
            conform.format({
                bufnr = 0,
                lsp_fallback = true,
                timeout_ms = 500,
            })
        end
    end,
})

-- Runlinter on save for web files
api.nvim_create_autocmd({ "BufWritePost" }, {
    group = profile_augroup,
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
    callback = function()
        local lint_ok, lint = pcall(require, "lint")
if lint_ok then
            lint.try_lint("eslint_d")
        end
    end,
})

-- Run linter on save for CSS files
api.nvim_create_autocmd({ "BufWritePost" }, {
    group = profile_augroup,
    pattern = { "*.css", "*.scss" },
    callback = function()
        local lint_ok, lint = pcall(require, "lint")
        if lint_ok then
            lint.try_lint("stylelint")
        end
    end,
})

-- Run linter on save for HTML files
api.nvim_create_autocmd({ "BufWritePost" }, {
    group = profile_augroup,
    pattern = { "*.html" },
    callback = function()
        local lint_ok, lint = pcall(require, "lint")
        if lint_ok then
            lint.try_lint("htmlhint")
        end
    end,
})

-- Set specific options for web files
api.nvim_create_autocmd("FileType", {
    group =profile_augroup,
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    callback = function()
        vim.api.nvim_buf_set_option(0, "tabstop", 2)
        vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
      vim.api.nvim_buf_set_option(0, "expandtab", true)
        vim.api.nvim_buf_set_option(0, "textwidth", 80)
    end,
})

-- Set specific options for HTML/CSS files
api.nvim_create_autocmd("FileType", {
    group = profile_augroup,
    pattern = {"html", "css", "scss" },
    callback = function()
        vim.api.nvim_buf_set_option(0, "tabstop", 2)
        vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
        vim.api.nvim_buf_set_option(0, "expandtab",true)
    end,
})

return api