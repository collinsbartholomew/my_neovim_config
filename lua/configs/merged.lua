-- Consolidated small configs: cmake, copilot, database, memsafe, linting, treesitter, dap
local M = {}

-- Safe require helper
local function safe_require(name)
  local ok, mod = pcall(require, name)
  return ok and mod or nil
end

-- CMake setup
function M.setup_cmake()
  local cmake = safe_require('cmake-tools')
  if not cmake then
    vim.notify('cmake-tools.nvim not available', vim.log.levels.WARN)
    return
  end
  cmake.setup({
    cmake_command = 'cmake',
    save_before_build = true,
    configure_args = { '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON' },
    build_dir = 'build',
  })
  vim.keymap.set('n', '<leader>cm', function() cmake.configure() end, { desc = 'CMake: Configure' })
  vim.keymap.set('n', '<leader>cb', function() cmake.build() end, { desc = 'CMake: Build' })
  vim.keymap.set('n', '<leader>ct', function() cmake.test() end, { desc = 'CMake: Test' })
  vim.keymap.set('n', '<leader>cp', function() cmake.set_build_type() end, { desc = 'CMake: Select build type' })
end

-- Copilot setup
function M.setup_copilot()
  local copilot = safe_require('copilot')
  if not copilot then
    vim.notify('copilot.lua not available', vim.log.levels.WARN)
    return
  end
  copilot.setup({ suggestion = { enabled = true, auto_trigger = true, keymap = { accept = "<C-\\>" } }, panel = { enabled = true, auto_refresh = false } })
  local copilot_cmp = safe_require('copilot_cmp')
  if copilot_cmp and copilot_cmp.setup then
    pcall(copilot_cmp.setup, { method = 'getCompletionsCycling' })
  end
end

-- Database setup
function M.setup_database()
  -- dadbod-ui & SQL helpers
  vim.g.db_ui_use_nerd_fonts = 1
  vim.g.db_ui_show_database_icon = 1
  vim.g.db_ui_force_echo_messages = 1
  vim.g.db_ui_win_position = 'left'
  vim.g.db_ui_winwidth = 30
  vim.g.db_ui_auto_execute_table_helpers = 1
  vim.g.db_ui_save_location = vim.fn.stdpath('data') .. '/db_ui'
  vim.keymap.set('n', '<leader>Dt', '<cmd>DBUIToggle<cr>', { desc = 'Database toggle' })
  vim.keymap.set('n', '<leader>Df', '<cmd>DBUIFindBuffer<cr>', { desc = 'Database find' })
  vim.keymap.set('n', '<leader>Dr', '<cmd>DBUIRenameBuffer<cr>', { desc = 'Database rename' })
  vim.keymap.set('n', '<leader>Dl', '<cmd>DBUILastQueryInfo<cr>', { desc = 'Database last' })

  -- SQL autocmds
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'sql', 'mysql', 'plsql', 'postgresql' },
    callback = function()
      vim.keymap.set('n', '<leader>se', '<cmd>SqlExecute<cr>', { desc = 'Execute SQL', buffer = true })
      vim.keymap.set('v', '<leader>se', ':SqlExecute<cr>', { desc = 'Execute SQL Selection', buffer = true })
      vim.keymap.set('n', '<leader>sf', function()
        local ok, conform = pcall(require, 'conform')
        if ok then conform.format({ formatters = { 'sqlfluff' }, async = true }) end
      end, { desc = 'Format SQL', buffer = true })
      vim.opt_local.commentstring = '-- %s'
      vim.opt_local.iskeyword:append('@-@')
    end,
  })

  -- MongoDB helper (best-effort)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'javascript', 'typescript' },
    callback = function()
      if vim.fn.search('db\.', 'nw') > 0 or vim.fn.search('collection\.', 'nw') > 0 then
        vim.keymap.set('n', '<leader>me', function()
          -- Run mongosh only if available; avoid running arbitrary shell commands during startup
          local mongosh = vim.fn.exepath('mongosh')
          if mongosh == '' then
            vim.notify('mongosh not available in PATH; cannot execute query', vim.log.levels.WARN)
            return
          end
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          local query = table.concat(lines, '\n')
          -- Use pcall to avoid runtime errors from system call failures
          local ok, out = pcall(vim.fn.system, { mongosh, '--eval', query })
          if not ok then
            vim.notify('Failed to execute mongosh: ' .. tostring(out), vim.log.levels.ERROR)
          else
            -- Show a brief notification that the query ran; output can be inspected in command history
            vim.notify('mongosh executed (output in command history).', vim.log.levels.INFO)
          end
        end, { desc = 'Execute MongoDB Query', buffer = true })
      end
    end,
  })

  -- Prisma
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'prisma',
    callback = function()
      vim.keymap.set('n', '<leader>pg', '<cmd>!npx prisma generate<cr>', { desc = 'Prisma Generate', buffer = true })
      vim.keymap.set('n', '<leader>pm', '<cmd>!npx prisma migrate dev<cr>', { desc = 'Prisma Migrate', buffer = true })
      vim.keymap.set('n', '<leader>ps', '<cmd>!npx prisma studio<cr>', { desc = 'Prisma Studio', buffer = true })
      vim.keymap.set('n', '<leader>pf', '<cmd>!npx prisma format<cr>', { desc = 'Prisma Format', buffer = true })
    end,
  })
end

-- Memsafe setup
function M.setup_memsafe()
  -- lightweight filetype helpers for C/C++ memory-safety
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'objc', 'objcpp' },
    callback = function()
      vim.keymap.set('n', '<leader>ma', function() vim.cmd('!valgrind %') end, { desc = 'Run Valgrind', buffer = true })
    end,
  })
end

-- Linting (nvim-lint/conform helpers)
function M.setup_linting()
  -- Provide a small API and keymaps
  vim.keymap.set('n', '<leader>ll', function()
    local ok, lint = pcall(require, 'lint')
    if ok then lint.try_lint() else vim.notify('nvim-lint not available', vim.log.levels.WARN) end
  end, { desc = 'Lint' })
  vim.keymap.set('n', '<leader>li', function()
    local filetype = vim.bo.filetype
    local ok, lint = pcall(require, 'lint')
    if not ok then vim.notify('nvim-lint not available', vim.log.levels.WARN) return end
    local linters = lint.linters_by_ft[filetype] or {}
    if #linters == 0 then vim.notify('No linters available for ' .. filetype, vim.log.levels.INFO) else vim.notify('Linters for ' .. filetype .. ': ' .. table.concat(linters, ', '), vim.log.levels.INFO) end
  end, { desc = 'Lint info' })

  -- Configure linters for JavaScript/TypeScript/JSX/TSX files
  local ok, lint = pcall(require, 'lint')
  if ok then
    -- Set up proper linters for JS/TS/JSX/TSX files
    lint.linters_by_ft = {
      javascript = { "eslint" },
      javascriptreact = { "eslint" },
      typescript = { "eslint" },
      typescriptreact = { "eslint" },
    }
  end
end

-- Treesitter (ensure parsers and basic setup hooks)
function M.setup_treesitter()
  local parsers_ok = pcall(require, 'nvim-treesitter.parsers')
  local configs_ok, configs = pcall(require, 'nvim-treesitter.configs')

  if not parsers_ok or not configs_ok then
    vim.notify('nvim-treesitter not available', vim.log.levels.WARN)
    return
  end

  configs.setup({
    ensure_installed = { 'lua', 'python', 'javascript', 'typescript', 'c', 'cpp', 'rust', 'go', 'zig', 'tsx', 'jsx' },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    autotag = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = "<S-CR>",
        node_decremental = "<BS>",
      },
    },
  })
end

-- DAP (lightweight setup and keymaps)
function M.setup_dap()
  local dap = safe_require('dap')
  if not dap then
    -- dap not installed; still provide keymaps that warn
    vim.keymap.set('n', '<leader>db', function() vim.notify('DAP not available', vim.log.levels.WARN) end, { desc = 'Toggle breakpoint' })
    return
  end
  -- Basic DAP keymaps
  vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = 'Toggle breakpoint' })
  vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = 'DAP continue' })
  vim.keymap.set('n', '<leader>di', function() dap.step_into() end, { desc = 'Step into' })
  vim.keymap.set('n', '<leader>do', function() dap.step_over() end, { desc = 'Step over' })
  vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end, { desc = 'Open REPL' })
  -- Load dap-ui if present
  local dapui = safe_require('dapui')
  if dapui and dapui.setup then
    dapui.setup()
    vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end, { desc = 'DAP UI' })
  end
end

-- Zig language helpers
function M.setup_zig()
  local ok = pcall(require, 'configs.lang.zig')
  if ok then
    pcall(require('configs.lang.zig').setup)
  end
end

-- Master setup to run commonly used setups
function M.setup()
  -- Call non-blocking setups; protect each
  pcall(M.setup_cmake)
  pcall(M.setup_copilot)
  pcall(M.setup_database)
  pcall(M.setup_memsafe)
  pcall(M.setup_linting)
  pcall(M.setup_treesitter)
  pcall(M.setup_dap)
  pcall(M.setup_zig)
end

return M
