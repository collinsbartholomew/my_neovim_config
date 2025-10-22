-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')

require("luasnip.loaders.from_vscode").lazy_load()

-- Customized CMP appearance
local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
    Copilot = "",
}

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            col_offset = -3,
            side_padding = 1,
        }),
        documentation = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            max_width = 80,
            max_height = 20,
        }),
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            
            -- Set a name for each source
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
                copilot = "[Copilot]",
                cmdline = "[Cmd]",
            })[entry.source.name]
            
            return vim_item
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "copilot" },
    }, {
        { name = "buffer", keyword_length = 3 },
        { name = "path" },
    }),
    experimental = {
        ghost_text = {
            hl_group = "LspCodeLens",
        },
    },
    completion = {
        completeopt = "menu,menuone,noinsert",
        keyword_length = 1,
    },
})

-- Command mode completion - only valid Neovim commands, no buffer suggestions
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'cmdline' }
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            
            -- Set a name for each source
            vim_item.menu = ({
                cmdline = "[Cmd]",
            })[entry.source.name]
            
            return vim_item
        end,
    },
    window = {
        completion = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            col_offset = -3,
            side_padding = 1,
        }),
    },
})

-- Search mode completion
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            
            -- Set a name for each source
            vim_item.menu = ({
                buffer = "[Buffer]",
            })[entry.source.name]
            
            return vim_item
        end,
    },
    window = {
        completion = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            col_offset = -3,
            side_padding = 1,
        }),
    },
})

-- Enhanced filetype-specific configurations
cmp.setup.filetype({
    rust = {
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'crates' },
            { name = 'buffer', keyword_length = 3 },
            { name = 'path' },
            { name = 'luasnip' },
        }),
    },
    ['toml'] = {
        sources = cmp.config.sources({
            { name = 'crates' },
            { name = 'buffer', keyword_length = 3 },
            { name = 'path' },
            { name = 'luasnip' },
        }),
    },
    -- Command mode completion
    ['vim'] = {
        sources = cmp.config.sources({
            { name = 'cmdline' },
            { name = 'path' },
        }, {
            { name = 'buffer', keyword_length = 3 },
        })
    },
    -- Enhanced configurations for other languages
    ['python'] = {
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer', keyword_length = 3 },
            { name = 'path' },
        }),
    },
    ['javascript'] = {
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer', keyword_length = 3 },
            { name = 'path' },
        }),
    },
    ['typescript'] = {
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer', keyword_length = 3 },
            { name = 'path' },
        }),
    },
    ['go'] = {
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer', keyword_length = 3 },
            { name = 'path' },
        }),
    },
})