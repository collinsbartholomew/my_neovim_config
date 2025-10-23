--nvim-cmp setup
--This file configures the completion engine for Neovim
local cmp = require("cmp")
local luasnip = require("luasnip")

-- Load VS Code style snippets for luasnip with filetype filtering
-- This prevents JSX snippets from appearing in JS files
require("luasnip.loaders.from_vscode").lazy_load({
    -- Exclude jsx snippets from javascript files
    exclude = { "javascriptreact", "typescriptreact" }
})

-- Extend filetypes so that react snippets are only available in jsx/tsx files
luasnip.filetype_extend("javascript", {}, { "javascriptreact" })
luasnip.filetype_extend("typescript", {}, { "typescriptreact" })

-- CustomizedCMP appearance
-- Define icons fordifferent completion kinds for better visual recognition
local kind_icons = {
    Text = "", -- Text completion
    Method = "󰆧", -- Method completion
    Function = "󰊕", -- Function completion
    Constructor = "", -- Constructor completion
    Field = "󰇽", -- Field completion
    Variable = "󰂡", -- Variable completion
    Class = "󰠱", -- Class completion
    Interface = "", -- Interface completion
    Module = "", --Module completion
    Property = "󰜢", -- Property completion
    Unit = "", -- Unit completion
    Value = "󰎠", -- Value completion
    Enum = "", -- Enum completion
    Keyword = "󰌋", -- Keywordcompletion
    Snippet = "", -- Snippet completion
    Color = "󰏘", -- Color completion
    File = "󰈙", -- File completion
    Reference = "", -- Reference completion
    Folder = "󰉋", -- Folder completion
    EnumMember = "", -- Enum member completion
    Constant = "󰏿", -- Constant completion
    Struct = "", -- Struct completion
    Event = "", -- Event completion
    Operator = "󰆕", -- Operator completion
    TypeParameter = "󰅲", -- Type parameter completion
    Copilot = "", -- Copilot completion
}

-- Main CMP setup for insert mode
cmp.setup({
    -- Configuresnippet expansion
    snippet = {
        expand = function(args)
            -- Use luasnip to expand snippets
            luasnip.lsp_expand(args.body)
        end,
    },

    -- Automatically add parentheses to function calls
    enabled = function()
        -- Enable completion except for certain filetypes or conditions
        return not vim.api.nvim_buf_get_option(0, 'buftype'):match('prompt')
    end,

    -- Configure completion window appearance
    window = {
        -- Completion popup window with border
        completion = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            col_offset = -3, -- Adjust column offset
            side_padding = 1, -- Add side padding
            max_width = 60, -- Limit width
            max_height = 10, -- Limit height to 10 items
        }),
        -- Documentation popup window with border
        documentation = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            max_width = 40, -- Reduced maximum width
            max_height = 6, -- Reduced maximum height to6 lines
            zindex = 1001, -- Ensure proper z-index
        }),
    },

    -- Configure how completions are formatted and displayed
    formatting = {
        fields = { "kind", "abbr", "menu" }, -- Display fields in this order
        format = function(entry, vim_item)
            -- Add icons to completion kinds
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)

            -- Set source labels for different completion sources
            vim_item.menu = ({
                nvim_lsp = "[LSP]", -- Language Server Protocolluasnip = "[Snippet]", -- Snippet engine
                buffer = "[Buffer]", -- Current buffer
                path = "[Path]", -- File path
                copilot = "[Copilot]", -- GitHub Copilot
                cmdline = "[Cmd]", -- Command line
            })[entry.source.name]

            return vim_item
        end,
    },

    -- Configure key mappings for completion
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll documentation up
        ["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll documentation down["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion manually
        ["<C-e>"] = cmp.mapping.abort(), -- Close completion menu
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    cmp.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    })
                    -- Add parentheses for functions and methods
                    local item = entry.completion_item
                    if item.kind == 2 or item.kind == 3 then
                        -- Function or Method
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("()", true, false, true), 'n', true)
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 'n', true)
                    end
                end
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            -- Shift+Tab navigation through completions and snippets
            if cmp.visible() then
                -- If completion menu is visible, select previous item
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                -- If in a snippet, jumpto previous field
                luasnip.jump(-1)
            else
                -- Otherwise, use fallback behavior
                fallback()
            end
        end, { "i", "s" }),
    }),

    -- Configure completion sources and their priority
    sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- Language Server Protocol completions (highest priority)
        { name = "luasnip" }, -- Snippet completions
        { name = "copilot" }, --GitHub Copilot completions
    }, {
        { name = "buffer", keyword_length = 3 }, -- Buffer completions (3 chars minimum)
        { name = "path" }, -- File path completions
    }),

    -- Configure completion behavior settings
    completion = {
        completeopt = "menu,menuone,noinsert", -- Completion options
        keyword_length = 1, -- Minimum keyword length to trigger completion
    },

    -- Enable auto-inserting parentheses for function calls
    enabled = function()
        return true
    end,
    preselect = cmp.PreselectMode.None,
    confirmation = {
        default_behavior = cmp.ConfirmBehavior.Replace,
        get_commit_characters = function(commit_characters)
            return commit_characters
        end,
    },
    experimental = {}
})

-- Command mode completion - only valid Neovim commands, no buffer suggestions
-- Configure completion for command mode (when typing ':')
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(), -- Use preset command-line mappings
    sources = {
        { name = "cmdline" }, -- Only command-line completions
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Add icons to completion kinds
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)

            -- Set source labels for command-line completions
            vim_item.menu = ({
                cmdline = "[Cmd]", -- Command line source
            })[entry.source.name]

            return vim_item
        end,
    },
    window = {
        -- Command-line completion window with border
        completion = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            col_offset = -3, -- Adjust column offset
            side_padding = 1, -- Add side padding
            max_width = 60, -- Limit width
            max_height = 10, -- Limitheight
        }),
    },
})

-- Search mode completion
-- Configure completion for search mode (when typing '/')
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(), -- Use preset command-line mappings
    sources = {
        { name = "buffer" }, -- Only buffer text completions
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Add icons to completion kinds
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)

            -- Set source labels for search completions
            vim_item.menu = ({
                buffer = "[Buffer]", -- Buffer source
            })[entry.source.name]

            return vim_item
        end,
    },
    window = {
        -- Search completion window with border
        completion = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            col_offset = -3, -- Adjust column offset
            side_padding = 1, -- Add side padding
        }),
    },
})

-- Enhanced filetype-specific configurations
-- Customize completion sources for specific filetypes
cmp.setup.filetype({
    rust = {
        -- Rust-specific completion sources
        sources = cmp.config.sources({
            { name = "nvim_lsp" }, -- LSP completions
            { name = "crates" }, -- Rust crates completions
            { name = "buffer", keyword_length = 3 }, -- Buffer completions
            { name = "path" }, -- Path completions
            { name = "luasnip" }, -- Snippet completions
        }),
    },
    ["toml"] = {
        -- TOML-specific completion sources
        sources = cmp.config.sources({
            { name = "crates" }, -- Crates completions for TOML
            { name = "buffer", keyword_length = 3 }, -- Buffer completions
            { name = "path" }, -- Path completions{name = "luasnip" }, -- Snippet completions
        }),
    },
    --Command mode completion
    ["vim"] = {
        -- Vimscript-specific completion sources
        sources = cmp.config.sources({
            { name = "cmdline" }, -- Command-line completions
            { name = "path" }, -- Path completions
        }, {
            { name = "buffer", keyword_length = 3 }, -- Buffer completions
        }),
    },
    -- Enhanced configurations for other languages
    ["python"] = {
        -- Python-specific completion sources
        sources = cmp.config.sources({
            { name = "nvim_lsp" }, -- LSP completions
            { name = "luasnip" }, -- Snippet completions
            { name = "buffer", keyword_length = 3 }, -- Buffer completions
            { name = "path" }, -- Path completions
        }),
    },
    ["javascript"] = {
        -- JavaScript-specific completion sources
        sources = cmp.config.sources({
            { name = "nvim_lsp" }, -- LSP completions
            { name = "luasnip" }, -- Snippet completions
            { name = "buffer", keyword_length = 3 }, -- Buffer completions
            { name = "path" }, -- Path completions
        }),
    },
    ["typescript"] = {
        -- TypeScript-specific completion sources
        sources = cmp.config.sources({
            { name = "nvim_lsp" }, -- LSP completions
            { name = "luasnip" }, -- Snippet completions
            { name = "buffer", keyword_length = 3 }, -- Buffercompletions
            { name = "path" }, -- Path completions
        }),
    },
    ["go"] = {
        -- Go-specific completion sources
        sources = cmp.config.sources({
            { name = "nvim_lsp" }, -- LSP completions
            { name = "luasnip" }, -- Snippet completions
            { name = "buffer", keyword_length = 3 }, -- Buffercompletions
            { name = "path" }, -- Path completions
        }),
    },
})