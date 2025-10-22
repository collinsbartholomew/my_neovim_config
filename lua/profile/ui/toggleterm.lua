-- Toggleterm setup
if not pcall(require, 'toggleterm') then
    return
end

require('toggleterm').setup({
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = 'curved',
        winblend = 3,
        highlights = {
            border = 'Normal',
            background = 'Normal',
        },
    },
})

local Terminal = require('toggleterm.terminal').Terminal

-- Create a table to hold our named terminals
local terminals = {}

-- Function to create or toggle a named terminal
local function toggle_named_terminal(name, cmd)
    if not terminals[name] then
        terminals[name] = Terminal:new({
            cmd = cmd,
            hidden = true,
            direction = "float",
            on_open = function(term)
                vim.cmd("startinsert!")
            end,
        })
    end
    terminals[name]:toggle()
end

-- Named terminal functions
function _lazygit_toggle()
    toggle_named_terminal("lazygit", "lazygit")
end

function _node_toggle()
    toggle_named_terminal("node", "node")
end

function _build_toggle()
    toggle_named_terminal("build", vim.o.shell)
end

function _repl_toggle()
    toggle_named_terminal("repl", vim.o.shell)
end

-- Only set the keymaps, let which-key handle the descriptions in keymaps.lua
vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
vim.keymap.set('n', '<leader>tg', _lazygit_toggle, { desc = 'Toggle lazygit' })
vim.keymap.set('n', '<leader>tb', _build_toggle, { desc = 'Toggle build terminal' })
vim.keymap.set('n', '<leader>tr', _repl_toggle, { desc = 'Toggle REPL terminal' })

-- Remove <leader>tn keymap to avoid conflict with Neotest