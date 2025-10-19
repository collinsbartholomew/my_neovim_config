local M = {}

-- Utility function for mapping keys
local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and opts.noremap ~= false then
        opts.noremap = false
    end
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- LSP keymaps setup function
function M.setup_lsp_keymaps(bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings
    local opts = { buffer = bufnr, desc = "LSP" }

    -- LSP actions
    map('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    map('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    map('n', 'K', vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover documentation" }))
    map('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    map('n', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Show signature help" }))
    map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
    map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
    map('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
    map('n', '<space>D', vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Type definition" }))
    map('n', '<space>rn', vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    map('n', '<space>ca', vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
    map('n', 'gr', vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
    map('n', '<space>f', function()
        vim.lsp.buf.format { async = true }
    end, vim.tbl_extend("force", opts, { desc = "Format code" }))
end

function M.setup()
    -- Leader key
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    -- Better window navigation
    map("n", "<C-h>", "<C-w>h", { desc = "Navigate left window" })
    map("n", "<C-j>", "<C-w>j", { desc = "Navigate down window" })
    map("n", "<C-k>", "<C-w>k", { desc = "Navigate up window" })
    map("n", "<C-l>", "<C-w>l", { desc = "Navigate right window" })

    -- Resize with arrows
    map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize window up" })
    map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize window down" })
    map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
    map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })

    -- Better indenting
    map("v", "<", "<gv", { desc = "Indent left" })
    map("v", ">", ">gv", { desc = "Indent right" })

    -- Move text up and down
    map("v", "<A-j>", ":m .+1<CR>==", { desc = "Move text down" })
    map("v", "<A-k>", ":m .-2<CR>==", { desc = "Move text up" })
    map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move text down" })
    map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move text up" })
    map("x", "<A-j>", ":move '>+1<CR>gv-gv", { desc = "Move text down" })
    map("x", "<A-k>", ":move '<-2<CR>gv-gv", { desc = "Move text up" })

    -- Buffers
    map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
    map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
    map("n", "<leader>bd", ":Bdelete!<CR>", { desc = "Delete buffer" })

    -- Clear highlights
    map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

    -- File explorer
    map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle file explorer" })
    map("n", "<leader>o", ":Neotree focus<CR>", { desc = "Focus file explorer" })

    -- Telescope
    map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
    map("n", "<leader>ft", ":Telescope live_grep<CR>", { desc = "Find text" })
    map("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Find projects" })
    map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
    map("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Find help" })
    map("n", "<leader>fo", ":Telescope oldfiles<CR>", { desc = "Find recent files" })
    map("n", "<leader>fm", ":Telescope marks<CR>", { desc = "Find marks" })

    -- Terminal
    map("n", "<leader>tf", ":ToggleTerm direction=float<CR>", { desc = "Float terminal" })
    map("n", "<leader>th", ":ToggleTerm size=10 direction=horizontal<CR>", { desc = "Horizontal terminal" })
    map("n", "<leader>tv", ":ToggleTerm size=80 direction=vertical<CR>", { desc = "Vertical terminal" })

    -- Git
    map("n", "<leader>gg", ":Neogit<CR>", { desc = "Toggle Git status" })
    map("n", "<leader>gj", "]c", { desc = "Next Git hunk" })
    map("n", "<leader>gk", "[c", { desc = "Previous Git hunk" })
    map("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
    map("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk" })
    map("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
    map("n", "<leader>gb", ":Gitsigns blame_line<CR>", { desc = "Blame line" })
    map("n", "<leader>gd", ":Gitsigns diffthis<CR>", { desc = "Diff this" })

    -- Debug
    map("n", "<F5>", ":lua require'dap'.continue()<CR>", { desc = "Start/Continue debugger" })
    map("n", "<F10>", ":lua require'dap'.step_over()<CR>", { desc = "Step over" })
    map("n", "<F11>", ":lua require'dap'.step_into()<CR>", { desc = "Step into" })
    map("n", "<F12>", ":lua require'dap'.step_out()<CR>", { desc = "Step out" })
    map("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
    map("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { desc = "Set conditional breakpoint" })
    map("n", "<leader>dl", ":lua require'dap'.repl.open()<CR>", { desc = "Open debug log" })
    map("n", "<leader>dr", ":lua require'dap'.repl.toggle()<CR>", { desc = "Toggle REPL" })

    -- Testing
    map("n", "<leader>tt", ":lua require('neotest').run.run()<CR>", { desc = "Run nearest test" })
    map("n", "<leader>tf", ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = "Run test file" })
    map("n", "<leader>ts", ":lua require('neotest').run.run({ suite = true })<CR>", { desc = "Run test suite" })
    map("n", "<leader>tl", ":lua require('neotest').run.run_last()<CR>", { desc = "Run last test" })
    map("n", "<leader>to", ":lua require('neotest').output.open({ enter = true })<CR>", { desc = "Show test output" })

    -- Trouble
    map("n", "<leader>xx", ":TroubleToggle<CR>", { desc = "Toggle trouble" })
    map("n", "<leader>xw", ":TroubleToggle workspace_diagnostics<CR>", { desc = "Workspace diagnostics" })
    map("n", "<leader>xd", ":TroubleToggle document_diagnostics<CR>", { desc = "Document diagnostics" })
    map("n", "<leader>xq", ":TroubleToggle quickfix<CR>", { desc = "Quickfix list" })
    map("n", "<leader>xl", ":TroubleToggle loclist<CR>", { desc = "Location list" })

    -- Code Formatting
    map("n", "<leader>cf", ":lua vim.lsp.buf.format()<CR>", { desc = "Format file" })
    map("n", "<leader>cr", ":lua vim.lsp.buf.code_action({ source = { organizeImports = true } })<CR>", { desc = "Organize imports" })

    -- Theme cycling
    map("n", "<leader>tt", function()
        local themes = {
            "tokyonight",
            "rose-pine",
        }
        local current = vim.g.colors_name
        local next_index = 1
        for i, theme in ipairs(themes) do
            if theme == current then
                next_index = (i % #themes) + 1
                break
            end
        end
        vim.cmd.colorscheme(themes[next_index])
    end, { desc = "Cycle theme" })
end

return M
