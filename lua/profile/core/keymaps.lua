--Keymaps and which-key setup
-- This file configures all the custom keymaps and keymap groups for the editor
local wk = require("which-key")

-- Setup which-key with modern preset and single border
wk.setup({
    preset = "modern",
    win = {
        border = "single",
    },
})

--Define keymap groups for better organization
wk.add({
    { "<leader>b", group = "Buffer" }, -- Buffer management operations
    { "<leader>d", group = "Debug" }, -- Debugging operations
    { "<leader>f", group = "Find" }, -- File and content findingoperations
    { "<leader>g", group = "Git" }, -- Git operations
    { "<leader>l", group = "LSP" }, -- Language Server Protocol operations
    { "<leader>o", group = "Overseer/Task" }, -- Task and build operations
    { "<leader>p", group = "Project/Session" }, -- Project and session management
    { "<leader>q", group = "Quickfix" }, -- Quickfix list operations
    { "<leader>r", group = "Refactor" }, -- Code refactoring operations
    { "<leader>sr", group = "Search/Replace" }, -- Search and replace operations
    { "<leader>t", group = "Test/Terminal/Toggle" }, -- Testing, terminal, and toggle operations
    { "<leader>u", group = "UI" }, -- User interface operations
    { "<leader>x", group = "Trouble/Diagnostics" }, -- Diagnostic and trouble operations
    { "<leader>y", group = "UI/Theme" }, -- UI theme operations
})

-- Buffer management keymaps
-- These keymaps handle operations related to managing buffers (open files)
wk.add({
    { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Pick buffer" }, -- Pick a buffer from the buffer list
    { "<leader>bc", "<cmd>Telescope buffers<cr>", desc = "Pick close buffer" }, -- Pick and close a buffer
    { "<leader>bd", "<cmd>bdelete<cr>", desc="Delete buffer" }, -- Delete current buffer
    { "<leader>bn", "<cmd>bnext<cr>", desc = "Next buffer" }, -- Switch to next buffer
    { "<leader>bp", "<cmd>bprevious<cr>", desc = "Prev buffer" }, -- Switch to previous buffer
})

-- Debugging keymaps
-- These keymaps handle debugging operations using DAP (Debug Adapter Protocol)
wk.add({
    {
        "<leader>db",
        function()
            -- Togglea breakpoint at the current line
            require("dap").toggle_breakpoint()
        end,
        desc = "Toggle breakpoint",
    },
    {
        "<leader>dc",
        function()
            -- Continue execution of the debugged program
            require("dap").continue()
        end,
        desc = "Continue",
    },
    {
        "<leader>di",
        function()
            -- Step into the next function call
            require("dap").step_into()
        end,
        desc = "Step into",
    },
    {
        "<leader>do",
        function()
            -- Step over the current line(don't enter function calls)
            require("dap").step_over()
        end,
        desc = "Step over",
    },
    {
        "<leader>dO",
        function()
            -- Step out of the current function
            require("dap").step_out()
        end,
        desc = "Stepout",
    },
    {
        "<leader>dr",
        function()
            -- Toggle the Debug Adapter Protocol REPL
            require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
    },
    {
        "<leader>du",
        function()
            -- Toggle the DAP UI (debugger interface)
            require("dapui").toggle()
        end,
        desc = "ToggleDAPUI",
    },
})

-- Find operations using Telescope
-- These keymaps use Telescope to find various items in the project
wk.add({
    { "<leader>fb", "<cmd>Telescopebuffers<cr>", desc = "Buffers" }, -- Find and switch between open buffers
    { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" }, -- Find and execute Neovim commands
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" }, -- Find files in the project
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" }, -- Search for text in files
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" }, -- Find help documentation
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" }, -- Find and view keymaps
    { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Old files" }, -- Find recently opened files
    { "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "References" }, -- Find references to the symbol under cursor
    { "<leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Symbols" }, -- Find symbols in the workspace
})

-- Git operations
-- These keymaps handle Git version control operations
wk.add({
    { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line" }, -- Show Git blame for current line
    { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" }, -- Commit changes
    { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff this" }, -- Show diff for current file
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }, -- Open LazyGit interface
    { "<leader>gl", "<cmd>Git log<cr>", desc = "Log" }, -- Show Git log
    { "<leader>go", "<cmd>Octo<cr>", desc = "Octo (GH)" }, -- Open Octo GitHub interface
    { "<leader>gp", "<cmd>Git pull<cr>", desc = "Pull" }, -- Pull changes from remote
    { "<leader>gP", "<cmd>Git push<cr>", desc = "Push" }, -- Push changes to remote
    { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk" }, -- Stage current hunk
    { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Open DiffView" }, -- Open diff view
    { "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "Close DiffView" }, -- Close diff view
})

-- LSP (Language Server Protocol) operations
-- These keymaps handle LSP features like code navigation and refactoring
wk.add({
    { "<leader>la", vim.lsp.buf.code_action, desc = "Code action" }, -- Show available code actions
    { "<leader>ld", vim.lsp.buf.definition, desc = "Definition" }, -- Go to definition
    { "<leader>lD", vim.lsp.buf.declaration, desc = "Declaration" }, -- Go to declaration
    {
        "<leader>lf",
        function()
            -- Format the current buffer
            vim.lsp.buf.format({ async = true })
        end,
        desc = "Format",
    },
    { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" }, -- Show hover information
    { "<leader>li", vim.lsp.buf.implementation, desc = "Implementation" }, -- Go to implementation
    { "<leader>ll", "<cmd>LspInfo<cr>", desc = "LSPInfo" }, -- Show LSP information
    { "<leader>lr", vim.lsp.buf.references, desc = "References" }, -- Find references
    { "<leader>lR", vim.lsp.buf.rename, desc = "Rename" }, -- Rename symbol
    { "<leader>ls", vim.lsp.buf.signature_help, desc = "Signature help" }, -- Show signature help
    { "<leader>lw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" }, -- Find workspace symbols
    { "<leader>lc", vim.lsp.codelens.run, desc = "Run codelens" }, -- Run code lens action
})

-- Overseer/Task operations
-- These keymaps handle task management and execution
wk.add({
    { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Build" }, -- Build project
    { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Info" }, -- Show task information
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run" }, -- Run task
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle" }, -- Toggle task
})

-- Project/Session operations
-- These keymaps handle project and session management
wk.add({
    {
        "<leader>pl",
        function()
            local status_ok, persistence = pcall(require, "persistence")
            if status_ok and persistence then
                persistence.load()
            else
                vim.notify("Persistence module not available", vim.log.levels.WARN)
            end
        end,
        desc = "Loadsession",
    },
    {
        "<leader>ps",
        function()
            local status_ok, persistence = pcall(require, "persistence")
            if status_ok and persistence then
                persistence.select()
            else
                vim.notify("Persistence module not available", vim.log.levels.WARN)
            end
        end,
        desc = "Select session",
    },
    { "<leader>pt", "<cmd>TodoTelescope<cr>", desc = "Todo" }, -- Find TODO comments
})

-- Quickfix list operations
-- These keymaps handle operations on the quickfix list
wk.add({
    { "<leader>qn", "<cmd>cnext<cr>", desc = "Next" }, -- Goto nextiteminquickfix list
    { "<leader>qp", "<cmd>cprev<cr>", desc = "Prev" }, -- Go to previousitemin quickfix list
    { "<leader>qo", "<cmd>copen<cr>", desc = "Open" }, -- Openquickfix list
    { "<leader>qc", "<cmd>cclose<cr>", desc = "Close" }, -- Closequickfix list
})

-- Refactoring operations
-- These keymaps handle code refactoring operations
wk.add({
    {
        "<leader>re",
        "<cmd>lua require('refactoring').refactor('ExtractFunction')<cr>",
        desc = "Extract function",
        mode = "v",
    },
    {
        "<leader>rf",
        "<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>",
        desc = "Extract function to file",
        mode = "v",
    },
    {
        "<leader>rv",
        "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>",
        desc = "Extract variable",
        mode = "v",
    },
    {
        "<leader>ri",
        "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>",
        desc = "Inline variable",
        mode = "v",
    },
    {
        "<leader>rb",
        "<cmd>lua require('refactoring').refactor('Extract Block')<cr>",
        desc = "Extract block",
        mode = "v",
    },
    {
        "<leader>rp",
        "<cmd>lua require('refactoring').debug.printf({below = false})<cr>",
        desc = "Debugprint",
    },
    {
        "<leader>rc",
        "<cmd>lua require('refactoring').debug.cleanup({})<cr>",
        desc = "Debug cleanup",
    },
})

-- Search and replace operations
-- These keymaps handle search and replace operations
wk.add({
    { "<leader>srp", "<cmd>Spectre<cr>", desc = "Project replace" }, -- Replace text in project
    { "<leader>srw", require("spectre").open_visual, desc = "Replace word", mode = "v" }, -- Replace selected word
})

-- Structure/Outline operations
-- These keymaps handle operations related to code structure and outline
wk.add({
    { "<leader>so", group = "Structure/Outline" }, -- Structure/Outline operations
    { "<leader>sot", "<cmd>AerialToggle<cr>", desc = "Toggle outline" }, -- Toggle code outline
    { "<leader>sof", "<cmd>AerialNavToggle<cr>", desc = "Navigate symbols" }, -- Navigate symbols in outline
})

-- Test/Terminal/Toggle operations
-- These keymaps handle testing, terminal, and toggle operations
wk.add({
    { "<leader>tf", "<cmd>Neotest summary<cr>", desc = "Test summary" }, -- Show test summary
    { "<leader>tn", "<cmd>Neotest run<cr>", desc = "Run nearest test" }, -- Run nearest test
    { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }, -- Toggle terminal
    { "<leader>tb", "<cmd>lua require('profile.ui.toggleterm')._build_toggle()<cr>", desc = "Toggle build terminal" }, -- Toggle build terminal
    { "<leader>tr", "<cmd>lua require('profile.ui.toggleterm')._repl_toggle()<cr>", desc = "Toggle REPL terminal" }, -- Toggle REPL terminal
    { "<leader>tu", "<cmd>lua require('nvim-tree.api').tree.toggle()<cr>", desc = "Toggle file tree" }, -- Toggle file tree
    { "<leader>tp", "<cmd>lua require('ufo').peekFoldedLinesUnderCursor()<cr>", desc = "Peek fold" }, -- Peek folded lines
})

-- UI/Undo operations
-- These keymaps handle undo operations in the UI
wk.add({
    { "<leader>uut", "<cmd>UndotreeToggle<cr>", desc = "Undotree" }, -- Toggle undotree
    { "<leader>uun", "<cmd>Noice<cr>", desc = "Noice history" }, -- Show Noice history
    { "<leader>uuh", "<cmd>Telescope undo<cr>", desc = "Undo history" }, -- Show undo history
})

-- UI/Theme operations
wk.add({
    { "<leader>yt", "<cmd>lua require('profile.ui.theme').toggle()<cr>", desc = "Toggle theme" }, -- Toggle theme
    { "<leader>yr", "<cmd>lua require('profile.ui.transparency').toggle()<cr>", desc = "Toggle transparency" }, -- Toggle transparency
})

-- UI/Folding operations
wk.add({
    { "<leader>uf", group = "UI/Folding" },
    { "<leader>uft", "<cmd>lua require('ufo').enableFold()<CR>", desc = "Toggle fold" },
    { "<leader>ufn", "<cmd>lua require('ufo').goNextClosedFold()<CR>", desc = "Next closed fold" },
    { "<leader>ufp", "<cmd>lua require('ufo').goPreviousClosedFold()<CR>", desc = "Previous closed fold" },
})

-- Trouble/Diagnostics operations
wk.add({
    { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" }, --ToggleTrouble
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },--Showworkspacediagnostics
    {"<leader>xd","<cmd>TroubleToggledocument_diagnostics<cr>", desc= "Document diagnostics" },-- Show documentdiagnostics
    {"<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc= "Quickfix" },--Showquickfix diagnostics
    {"<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Loclist" },--Showloclist diagnostics
})

-- PHP operations
wk.add({
    { "<leader>P", group = "PHP" }, -- PHP operations
    { "<leader>Pa", group = "Actions" }, -- PHP actions
    { "<leader>Pc", group = "Composer" }, -- Composer operations
    { "<leader>Pt", group = "Tests" }, -- PHP testing
    { "<leader>Pl", group = "Laravel" }, -- Laravel operations
})

--Othergeneralkeymaps
wk.add({
    { "gd", vim.lsp.buf.definition, desc = "Goto Definition" }, -- Goto definition
    { "grr", vim.lsp.buf.references, desc = "Goto References" }, -- Changed from gr to grr to avoid conflict
    { "gri", vim.lsp.buf.implementation, desc = "Goto Implementation" }, -- Changed from gI to gri
    { "K", vim.lsp.buf.hover, desc = "Hover" },
    { "<C-h>", "<cmd>lua require('nvim-navbuddy').open()<cr>", desc = "Navbuddy" },
    {
        "<leader>cc",
        "<cmd>Comment toggle<cr>",
        desc = "Comment toggle",
        mode = { "n", "v" },
    },
    { "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Harpoon menu" }, --Changed from<leader>h to <leader>hh
    { "<leader>ha", "<cmd>luarequire('harpoon.mark').add_file()<cr>", desc = "Harpoon add" }, -- Changed from <leader>a to <leader>ha
    { "<leader>S", "<cmd>luarequire('flash').jump()<cr>", desc = "Flash jump" },
    { "<leader>st", "<cmd>lua require('flash').treesitter()<cr>", desc = "Flashtreesitter" }, -- Changed from <leader>s to <leader>st
})

--Add AIgroup
wk.add({
    { "<leader>ai", group = "AI" },
    { "<leader>ait", "<cmd>Copilot toggle<cr>", desc = "Toggle Copilot" },
})

-- Lua development group
wk.add({
    { "<leader>ld", group = "Lua Development" },
    { "<leader>ldr", desc = "Run Lua file" },
    { "<leader>ldd", desc = "Debug Lua file" },
    { "<leader>ldb", desc = "Reload Lua module" },
    { "<leader>ldc", desc = "Check Lua file" },
})

--Add multi-cursor keymaps
wk.add({
    { "<C-d>", "<cmd>VM_Find_Under<cr>", desc = "Multi-cursor find under", mode = { "n", "v" } },
    { "<M-Up>", "<cmd>VM_Add_Cursor_Up<cr>", desc = "Add cursorabove", mode = "n" },
    { "<M-Down>", "<cmd>VM_Add_Cursor_Down<cr>", desc = "Add cursor below", mode = "n" },
})

--Keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Set leaderkeyvim.g.mapleader = " "
vim.g.maplocalleader = ""

-- Better windownavigationmap("n", "<C-h>", "<C-w>h",opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resizewitharrowsmap("n", "<A-Up>", ":resize-2<CR>", opts)
map("n", "<A-Down>", ":resize +2<CR>", opts)
map("n", "<A-Left>", ":vertical resize -2<CR>", opts)
map("n", "<A-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffersmap("n", "<S-l>", ":bnext<CR>",opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
map("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
map("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Clear search highlights
map("n", "<leader>ch", ":nohlsearch<CR>", opts)  -- Changed from <leader>h to <leader>ch

-- Togglediagnosticsmap("n","<leader>td", ":lua require('profile.core.functions').toggle_diagnostics()<CR>", opts)

-- Check assembly tools
map("n", "<leader>atc", ":lua require('profile.core.functions').check_asm_tools()<CR>", opts)

-- Quick run for assembly filesmap("n","<leader>arr", ":lua require('profile.core.functions').asm_run()<CR>", opts)

-- Check C++ toolsmap("n", "<leader>ctc", ":lua require('profile.core.functions').check_cpp_tools()<CR>", opts)

-- Create C++ class
map("n", "<leader>ccc", ":lua require('profile.core.functions').create_cpp_class()<CR>", opts)

-- Check Rust toolsmap("n", "<leader>rtc", ":lua require('profile.core.functions').check_rust_tools()<CR>", opts)

-- Create Rust module
map("n", "<leader>crm", ":lua require('profile.core.functions').create_rust_module()<CR>", opts)

-- Check Zig tools
map("n", "<leader>ztc", ":lua require('profile.core.functions').check_zig_tools()<CR>", opts)

--Create Zig module
map("n", "<leader>czm", ":lua require('profile.core.functions').create_zig_module()<CR>", opts)

-- Luadevelopment
map("n", "<leader>lu", "<cmd>echo 'Lua tools'<CR>", opts)
map("n", "<leader>lur", ":luafile %<CR>", opts) -- Run Lua file
map("n", "<leader>lud", ":lua require('dap').continue()<CR>", opts) -- Debug Lua filemap("n","<leader>lub", ":lua require('profile.core.functions').reload_lua_module()<CR>", opts) -- Reload Lua module
map("n", "<leader>luc", ":luarequire('os').execute('luacheck ' .. vim.fn.expand('%'))<CR>", opts)-- Check Lua file

--Better indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

--Move selected line / block of textinvisualmode
map("x", "J", ":move '>+1<CR>gv-gv", opts)
map("x", "K", ":move '<-2<CR>gv-gv", opts)
map("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
map("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

--Folding keymaps
map("n", "<leader>ft", ":lua require('ufo').enableFold()<CR>", { desc = "Toggle fold" })
map("n", "<leader>fn", ":lua require('ufo').goNextClosedFold()<CR>", { desc = "Go to next closed fold" })
map("n", "<leader>fp", ":lua require('ufo').goPreviousClosedFold()<CR>", { desc = "Go to previous closed fold" })
map("n", "zP", ":lua require('ufo').peekFoldedLinesUnderCursor()<CR>", { desc = "Peek folded lines" })

-- PHP keymaps
wk.add({
    -- PHP general operations
    { "<leader>Pf", "<cmd>lua require('phpactor').navigate('file')<cr>", desc = "Find file" },
    { "<leader>Pm", "<cmd>lua require('phpactor').navigate('module')<cr>", desc = "Navigate module" },
    
    -- Composer operations
    { "<leader>Pci", "<cmd>!composer install<cr>", desc = "Install packages" },
    { "<leader>Pcu", "<cmd>!composer update<cr>", desc = "Update packages" },
    { "<leader>Pcd", "<cmd>!composer dump-autoload<cr>", desc = "Dump autoload" },
    
    -- Laravel operations
    { "<leader>Pla", "<cmd>lua require('laravel').commands()<cr>", desc = "Artisan commands" },
    { "<leader>Plr", "<cmd>lua require('laravel').routes()<cr>", desc = "List routes" },
    { "<leader>Ple", "<cmd>lua require('laravel').tinker()<cr>", desc = "Tinker" },
    
    -- PHP testing
    { "<leader>Ptt", "<cmd>TestFile<cr>", desc = "Run test file" },
    { "<leader>Ptn", "<cmd>TestNearest<cr>", desc = "Run nearest test" },
    { "<leader>Pts", "<cmd>TestSuite<cr>", desc = "Run test suite" },
    { "<leader>Ptl", "<cmd>TestLast<cr>", desc = "Run last test" },
    
    -- PHP refactoring
    { "<leader>Pra", "<cmd>lua require('phpactor').refactor()<cr>", desc = "Refactor" },
    { "<leader>Pre", "<cmd>lua require('phpactor').context_menu()<cr>", desc = "Context menu" },
})

return {}