-- Unified on_attach for LSP clients (shared keymaps and integrations)
local M = {}

local function safe_map(mode, lhs, rhs, opts)
  opts = opts or {}
  pcall(vim.keymap.set, mode, lhs, rhs, opts)
end

local function on_attach(client, bufnr)
  local opts = { buffer = bufnr, silent = true }

  -- Client-specific optimizations
  if client.name == 'biome' then
    client.server_capabilities.completionProvider = false
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.diagnosticProvider = true
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
  elseif client.name == 'ts_ls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  elseif client.name == 'html' and (vim.bo[bufnr].filetype:match('react') or vim.bo[bufnr].filetype:match('typescript')) then
    client.server_capabilities.completionProvider = false
  elseif client.name == 'emmet_ls' and (vim.bo[bufnr].filetype:match('typescript') or vim.bo[bufnr].filetype:match('javascript')) then
    client.server_capabilities.completionProvider = false
  elseif client.name == 'cssls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  -- Core LSP mappings
  safe_map('n', 'gd', vim.lsp.buf.definition, opts)
  safe_map('n', 'gD', vim.lsp.buf.declaration, opts)
  safe_map('n', 'gi', vim.lsp.buf.implementation, opts)
  safe_map('n', 'gr', vim.lsp.buf.references, opts)
  safe_map('n', 'gt', vim.lsp.buf.type_definition, opts)
  safe_map('n', 'K', vim.lsp.buf.hover, opts)
  safe_map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  safe_map('n', '<leader>lr', vim.lsp.buf.rename, opts)
  safe_map('n', '<leader>la', vim.lsp.buf.code_action, opts)

  -- Organize imports helper
  local function organize_imports()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.organizeImports' } }
    local results = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params, 1500)
    if not results then return end
    for _, res in pairs(results or {}) do
      for _, r in pairs(res or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, 'utf-8')
        elseif r.command then
          local cmd = type(r.command) == 'table' and r.command or r
          pcall(vim.lsp.buf.execute_command, cmd)
        end
      end
    end
  end

  -- ESLint fix helper
  local function eslint_fix()
    if vim.fn.exists(':EslintFixAll') == 2 then
      pcall(vim.cmd, 'EslintFixAll')
      return
    end
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.fixAll.eslint' } }
    local results = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params, 1500)
    if not results then return end
    for _, res in pairs(results or {}) do
      for _, r in pairs(res or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, 'utf-8')
        elseif r.command then
          local cmd = type(r.command) == 'table' and r.command or r
          pcall(vim.lsp.buf.execute_command, cmd)
        end
      end
    end
  end

  -- Format command
  safe_map('n', '<leader>lf', function()
    if client.name == 'biome' then
      vim.lsp.buf.format({ async = true, name = 'biome' })
    else
      vim.lsp.buf.format({ async = true })
    end
  end, opts)

  -- Organize imports command
  safe_map('n', '<leader>lo', function()
    pcall(function()
      vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
    end)
  end, vim.tbl_extend('force', opts, { desc = 'LSP Organize Imports' }))

  -- JS/TS specific: organize imports + eslint fix + format on save
  local ft = vim.bo[bufnr].filetype
  if ft == 'javascript' or ft == 'javascriptreact' or ft == 'typescript' or ft == 'typescriptreact' then
    local group = vim.api.nvim_create_augroup('lsp_js_format_' .. bufnr, { clear = true })
    if _G.format_on_save == nil then _G.format_on_save = true end
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      group = group,
      callback = function()
        pcall(organize_imports)
        pcall(eslint_fix)
        if _G.format_on_save then
          local okc, conform = pcall(require, 'conform')
          if okc and conform then
            pcall(conform.format, { async = false, lsp_fallback = true })
          else
            pcall(vim.lsp.buf.format, { bufnr = bufnr })
          end
        end
      end,
    })
  end

  -- Advanced workspace features
  safe_map('n', '<leader>lws', vim.lsp.buf.workspace_symbol, opts)
  safe_map('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, opts)
  safe_map('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, opts)
  safe_map('n', '<leader>lwl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)

  -- LSP control
  safe_map('n', '<leader>lI', '<cmd>LspInfo<cr>', { desc = 'LSP info' })
  safe_map('n', '<leader>lL', '<cmd>LspLog<cr>', { desc = 'LSP log' })
  safe_map('n', '<leader>lT', '<cmd>LspStart<cr>', { desc = 'LSP start' })
  safe_map('n', '<leader>lX', '<cmd>LspStop<cr>', { desc = 'LSP stop' })
  safe_map('n', '<leader>lR', '<cmd>LspRestart<cr>', { desc = 'LSP restart' })

  -- Inlay hints
  if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    vim.lsp.inlay_hint(bufnr, true)
    safe_map('n', '<leader>lih', function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
      vim.notify('Inlay hints ' .. (enabled and 'disabled' or 'enabled'))
    end, opts)
  end

  -- CodeLens
  if client.server_capabilities.codeLensProvider and vim.lsp.codelens then
    vim.lsp.codelens.refresh({ bufnr = bufnr })
    safe_map('n', '<leader>lcl', vim.lsp.codelens.run, opts)
    safe_map('n', '<leader>lcr', function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end, opts)
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      buffer = bufnr,
      callback = function() pcall(vim.lsp.codelens.refresh, { bufnr = bufnr }) end,
    })
  end

  -- Document highlights
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup('lsp_document_highlight_' .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { buffer = bufnr, group = group, callback = vim.lsp.buf.document_highlight })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { buffer = bufnr, group = group, callback = vim.lsp.buf.clear_references })
  end

  -- Call hierarchy
  if client.server_capabilities.callHierarchyProvider then
    safe_map('n', '<leader>lci', vim.lsp.buf.incoming_calls, opts)
    safe_map('n', '<leader>lco', vim.lsp.buf.outgoing_calls, opts)
  end

  -- Memory safety diagnostics placeholder
  safe_map('n', '<leader>lm', function()
    vim.notify('Running memory safety diagnostics...', vim.log.levels.INFO)
  end, { desc = 'Memory safety diagnostics' })
end

M.on_attach = on_attach
return M

