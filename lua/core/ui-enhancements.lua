-- Additional Neovim highlights for better UI
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Ensure Neotree loads with proper padding
        vim.cmd([[
            hi NeoTreeEndOfBuffer guibg=NONE ctermbg=NONE
            hi NeoTreeNormal guibg=NONE ctermbg=NONE
            hi NeoTreeNormalNC guibg=NONE ctermbg=NONE
            hi NeoTreeRootName gui=bold guifg=#c4a7e7
            hi NeoTreeDirectoryName guifg=#9ccfd8
            hi NeoTreeDirectoryIcon guifg=#9ccfd8
            hi NeoTreeIndentMarker guifg=#2a273f
            hi NeoTreeGitModified guifg=#f6c177
            hi NeoTreeGitAdded guifg=#a6da95
            hi NeoTreeGitDeleted guifg=#ed8796
            hi NeoTreeGitConflict guifg=#f5a97f gui=bold
            hi NeoTreeGitUntracked guifg=#c4a7e7 gui=italic
        ]])
    end,
})

-- Set up specific marks for indent lines
vim.g.indent_blankline_char = "▏"
vim.g.indent_blankline_context_char = "▎"

-- Initialize integrated testing
vim.g.test_strategy = "neovim"
vim.g.test_neovim_term_position = "botright 15"

-- Ensure proper loading order for UI components
vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(event)
        if event.data == "neo-tree.nvim" then
            -- Refresh Neotree when it loads
            vim.cmd("Neotree reveal")
        end
    end,
})

local M = {}

function M.setup()
    -- Cursor settings
    vim.opt.guicursor = {
        "n-v-c:block",
        "i-ci-ve:ver25",
        "r-cr:hor20",
        "o:hor50",
        "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
        "sm:block-blinkwait175-blinkoff150-blinkon175",
    }

    -- Proper folding settings
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true

    -- Fix the foldclose option
    vim.opt.foldclose = "" -- Empty string instead of invalid value

    -- UI Improvements
    vim.opt.termguicolors = true
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.cursorline = true
    vim.opt.signcolumn = "yes"
    vim.opt.colorcolumn = "80"
    vim.opt.showmode = false
    vim.opt.conceallevel = 2
    vim.opt.concealcursor = "nc"

    -- Better splits
    vim.opt.splitbelow = true
    vim.opt.splitright = true

    -- Set up specific marks for indent lines
    vim.g.indent_blankline_char = "▏"
    vim.g.indent_blankline_context_char = "▎"

    -- Initialize integrated testing
    vim.g.test_strategy = "neovim"
    vim.g.test_neovim_term_position = "botright 15"

    -- Additional Neovim highlights for better UI
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            -- Ensure Neotree loads with proper padding
            vim.cmd([[
                hi NeoTreeEndOfBuffer guibg=NONE ctermbg=NONE
                hi NeoTreeNormal guibg=NONE ctermbg=NONE
                hi NeoTreeNormalNC guibg=NONE ctermbg=NONE
                hi NeoTreeRootName gui=bold guifg=#c4a7e7
                hi NeoTreeDirectoryName guifg=#9ccfd8
                hi NeoTreeDirectoryIcon guifg=#9ccfd8
                hi NeoTreeIndentMarker guifg=#2a273f
                hi NeoTreeGitModified guifg=#f6c177
                hi NeoTreeGitAdded guifg=#a6da95
                hi NeoTreeGitDeleted guifg=#ed8796
                hi NeoTreeGitConflict guifg=#f5a97f gui=bold
                hi NeoTreeGitUntracked guifg=#c4a7e7 gui=italic
            ]])
        end,
    })

    -- Ensure proper loading order for UI components
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(event)
            if event.data == "neo-tree.nvim" then
                -- Refresh Neotree when it loads
                vim.cmd("Neotree reveal")
            end
        end,
    })
end

return M

-- Function to refine UI elements after initial load
function M.refine()
    -- Additional UI refinements that need to run after VimEnter
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
            -- Transparent floating windows
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
            vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", ctermbg = "NONE" })

            -- Better line numbers
            vim.api.nvim_set_hl(0, "LineNr", { fg = "#6e738d", bold = false })
            vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#c4a7e7", bold = true })

            -- Improved UI elements
            vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#c4a7e7", bold = true })
            vim.api.nvim_set_hl(0, "FloatFooter", { fg = "#6e738d" })
            vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE" })
        end,
    })
end

