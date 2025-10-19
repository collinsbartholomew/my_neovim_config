local M = {}

function M.setup()
    require("toggleterm").setup({
        size = function(term)
            if term.direction == "horizontal" then
                return 15
            elseif term.direction == "vertical" then
                return vim.o.columns * 0.4
            end
        end,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = false,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'horizontal',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
            border = 'curved',
            winblend = 0,
        }
    })

    -- Custom terminal configurations
    local Terminal = require('toggleterm.terminal').Terminal

    -- Python REPL
    local python = Terminal:new({
        cmd = "python",
        direction = "float",
        hidden = true,
    })

    -- Node.js REPL
    local node = Terminal:new({
        cmd = "node",
        direction = "float",
        hidden = true,
    })

    -- Lazygit terminal
    local lazygit = Terminal:new({
        cmd = "lazygit",
        direction = "float",
        hidden = true,
    })

    -- Custom keymaps
    vim.keymap.set("n", "<leader>Th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Toggle horizontal terminal" })
    vim.keymap.set("n", "<leader>Tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Toggle vertical terminal" })
    vim.keymap.set("n", "<leader>Tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Toggle floating terminal" })
    vim.keymap.set("n", "<leader>Tg", function() lazygit:toggle() end, { desc = "Toggle lazygit" })
    vim.keymap.set("n", "<leader>Tp", function() python:toggle() end, { desc = "Toggle Python REPL" })
    vim.keymap.set("n", "<leader>Tn", function() node:toggle() end, { desc = "Toggle Node REPL" })

    -- Terminal mode mappings
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { desc = "Go to left window" })
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { desc = "Go to lower window" })
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { desc = "Go to upper window" })
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { desc = "Go to right window" })
end

return M
