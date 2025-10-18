-- Lightweight autostart for LSP servers (configs/lsp/autostart.lua)
local M = {}

local function executable_from_mason_or_path(bin)
  local mason_bin = vim.fn.stdpath('data') .. '/mason/bin/' .. bin
  if vim.fn.executable(mason_bin) == 1 then return mason_bin end
  if vim.fn.executable(bin) == 1 then return bin end
  return nil
end

local function find_qmlls()
  local function exists(p)
    return p and vim.fn.executable(p) == 1
  end
  local qt_path = os.getenv('QT_PATH') or os.getenv('QTDIR')
  if qt_path then
    local cand = qt_path .. '/bin/qmlls'
    if exists(cand) then return cand end
  end
  local home = os.getenv('HOME') or '~'
  local guesses = {
    home .. '/Qt/6.*/gcc_64/bin/qmlls',
    home .. '/Qt/6.*/bin/qmlls',
    '/usr/lib/qt6/bin/qmlls',
    '/usr/bin/qmlls',
  }
  for _, g in ipairs(guesses) do
    if g:find('%*') then
      local globbed = vim.fn.glob(g)
      if globbed and globbed ~= '' then
        for path in string.gmatch(globbed, "[^\n]+") do
          if exists(path) then return path end
        end
      end
    else
      if exists(g) then return g end
    end
  end
  if vim.fn.executable('qmlls') == 1 then return 'qmlls' end
  return nil
end

local function start_js_stack(base_caps, on_attach, servers)
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  if not vim.tbl_contains({ 'javascript','javascriptreact','typescript','typescriptreact','json','jsonc' }, ft) then
    return
  end

  local util_ok, util = pcall(require, 'lspconfig.util')
  local root
  if util_ok and util and util.root_pattern then
    local ok, rp = pcall(util.root_pattern, 'biome.json','biome.jsonc','package.json','.git')
    if ok and rp then root = rp(vim.api.nvim_buf_get_name(bufnr)) end
  end
  root = root or vim.loop.cwd()

  local biome_cmd = executable_from_mason_or_path('biome')
  if biome_cmd then
    vim.lsp.start({ name = 'biome', cmd = { biome_cmd, 'lsp-proxy' }, root_dir = root, capabilities = base_caps, on_attach = on_attach, filetypes = { 'javascript','javascriptreact','typescript','typescriptreact','json','jsonc' }, settings = servers and servers.biome and servers.biome.settings or nil })
  end

  -- Prefer ts_ls when available. Try ts_ls, then tsserver.
  local ts_ls_cmd = executable_from_mason_or_path('ts_ls') or executable_from_mason_or_path('tsserver')
  if ts_ls_cmd then
    vim.lsp.start({ name = 'ts_ls', cmd = { ts_ls_cmd, '--stdio' }, root_dir = root, capabilities = base_caps, on_attach = on_attach, filetypes = { 'javascript','javascriptreact','typescript','typescriptreact' }, settings = servers and servers.ts_ls and servers.ts_ls.settings or nil })
  end
end

local function start_lua_ls(base_caps, on_attach, servers)
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= 'lua' then return end
  local util_ok, util = pcall(require, 'lspconfig.util')
  local root
  if util_ok and util and util.root_pattern then
    local ok, rp = pcall(util.root_pattern, '.luarc.json','.git')
    if ok and rp then root = rp(vim.api.nvim_buf_get_name(bufnr)) end
  end
  root = root or vim.loop.cwd()
  local lua_cmd = executable_from_mason_or_path('lua-language-server')
  if not lua_cmd then return end
  vim.lsp.start({ name = 'lua_ls', cmd = { lua_cmd }, root_dir = root, capabilities = base_caps, on_attach = on_attach, settings = servers and servers.lua_ls and servers.lua_ls.settings or nil, filetypes = { 'lua' } })
end

local function start_web_stack(base_caps, on_attach, servers)
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local util_ok, util = pcall(require, 'lspconfig.util')
  local root
  if util_ok and util and util.root_pattern then
    local ok, rp = pcall(util.root_pattern, 'package.json','.git')
    if ok and rp then root = rp(filename) end
  end
  root = root or vim.loop.cwd()

  local html_fts = { html=true, htm=true, htmldjango=true, handlebars=true, hbs=true, mustache=true, templ=true, ejs=true, erb=true, twig=true, pug=true }
  local css_fts = { css=true, scss=true, less=true, sass=true }
  local react_fts = { javascriptreact=true, typescriptreact=true }
  local svelte_fts = { svelte=true }
  local vue_fts = { vue=true }
  local astro_fts = { astro=true }
  local xml_fts = { xml=true, xsd=true, xsl=true, xslt=true, svg=true }

  local function start_server_if(cmd_bin, name, opts)
    local cmd = executable_from_mason_or_path(cmd_bin)
    if not cmd then return end
    local cfg = vim.tbl_deep_extend('force', { name = name, cmd = { cmd, '--stdio' }, root_dir = root, capabilities = base_caps, on_attach = on_attach, filetypes = { ft } }, opts or {})
    vim.lsp.start(cfg)
  end

  if html_fts[ft] then
    start_server_if('vscode-html-language-server', 'html')
    start_server_if('emmet-ls', 'emmet_ls')
    start_server_if('tailwindcss-language-server', 'tailwindcss', { cmd = { executable_from_mason_or_path('tailwindcss-language-server'), '--stdio' }, settings = servers and servers.tailwindcss and servers.tailwindcss.settings or nil })
  elseif react_fts[ft] or svelte_fts[ft] or vue_fts[ft] or astro_fts[ft] then
    start_server_if('emmet-ls', 'emmet_ls')
    start_server_if('tailwindcss-language-server', 'tailwindcss', { cmd = { executable_from_mason_or_path('tailwindcss-language-server'), '--stdio' }, settings = servers and servers.tailwindcss and servers.tailwindcss.settings or nil })
  elseif css_fts[ft] then
    start_server_if('vscode-css-language-server', 'cssls')
  elseif xml_fts[ft] then
    local lem = executable_from_mason_or_path('lemminx')
    if lem then
      vim.lsp.start({ name='lemminx', cmd= { lem }, root_dir = root, capabilities = base_caps, on_attach = on_attach, filetypes = { ft } })
    end
  end
end

local function start_qt_stack(base_caps, on_attach, _)
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local util_ok, util = pcall(require, 'lspconfig.util')
  local root
  if util_ok and util and util.root_pattern then
    local ok, rp = pcall(util.root_pattern, 'CMakeLists.txt', '.git')
    if ok and rp then root = rp(filename) end
  end
  root = root or vim.loop.cwd()

  if ft == 'qml' or ft == 'qmljs' then
    local qcmd = find_qmlls()
    if qcmd then
      vim.lsp.start({ name = 'qmlls', cmd = { qcmd }, root_dir = root, capabilities = base_caps, on_attach = on_attach, filetypes = { ft } })
    else
      vim.notify('qmlls not found. Install Qt SDK (qmlls) and/or set QT_PATH.', vim.log.levels.WARN)
    end
  elseif ft == 'cmake' then
    local cmls = executable_from_mason_or_path('cmake-language-server')
    if cmls then
      vim.lsp.start({ name='cmake', cmd = { cmls }, root_dir = root, capabilities = base_caps, on_attach = on_attach, filetypes = { 'cmake' } })
    end
  end
end

-- Zig autostart: start zls for Zig filetypes
local function start_zig_stack(base_caps, on_attach, servers)
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  if ft ~= 'zig' then return end
  local root = vim.loop.cwd()
  local zls_cmd = executable_from_mason_or_path('zls')
  if not zls_cmd then
    if vim.fn.executable('zls') == 1 then zls_cmd = 'zls' end
  end
  if not zls_cmd then
    vim.notify('zls (Zig Language Server) not found. Install via Mason or your package manager.', vim.log.levels.WARN)
    return
  end
  vim.lsp.start({ name = 'zls', cmd = { zls_cmd }, root_dir = root, capabilities = base_caps, on_attach = on_attach, filetypes = { 'zig' }, settings = servers and servers.zls and servers.zls.settings or nil })
end

function M.setup(cap_mod, on_attach_mod, servers_mod)
  local capabilities
  if cap_mod then
    if type(cap_mod) == 'table' and cap_mod.setup then
      capabilities = cap_mod.setup()
    elseif type(cap_mod) == 'function' then
      capabilities = cap_mod()
    end
  end
  capabilities = capabilities or vim.lsp.protocol.make_client_capabilities()

  local on_attach = (on_attach_mod and (on_attach_mod.on_attach or on_attach_mod)) or function() end
  local servers = (servers_mod and (servers_mod.servers or servers_mod)) or {}

  local has_new_lsp_api = (vim.lsp and vim.lsp.config) and true or false

  if has_new_lsp_api then
    vim.api.nvim_create_autocmd({ 'BufReadPost','BufNewFile' }, {
      group = vim.api.nvim_create_augroup('lsp_unified_autostart', { clear = true }),
      callback = function()
        start_js_stack(capabilities, on_attach, servers)
        start_lua_ls(capabilities, on_attach, servers)
        start_web_stack(capabilities, on_attach, servers)
        start_qt_stack(capabilities, on_attach, servers)
        start_zig_stack(capabilities, on_attach, servers)
      end,
    })
  else
    -- Fallback to lspconfig setup
    local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
    if not lspconfig_ok then
      vim.notify('lspconfig not available', vim.log.levels.ERROR)
      return
    end

    local function setup_server(name, config)
      config = config or {}
      config.capabilities = capabilities
      config.on_attach = on_attach

      if name == 'biome' then
        config.filetypes = { 'javascript','javascriptreact','typescript','typescriptreact','json','jsonc' }
        if not config.cmd then
          config.cmd = { vim.fn.stdpath('data') .. '/mason/bin/biome', 'lsp-proxy' }
        end
      elseif name == 'ts_ls' then
        config.handlers = config.handlers or {}
        config.handlers["textDocument/publishDiagnostics"] = function() end
        local user_on_attach = config.on_attach
        config.on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          on_attach(client, bufnr)
          if user_on_attach then pcall(user_on_attach, client, bufnr) end
        end
      end

      if type(lspconfig[name]) ~= 'table' or not lspconfig[name].setup then
        vim.notify("lspconfig has no server named '" .. name .. "'", vim.log.levels.WARN)
        return
      end
      local ok, err = pcall(lspconfig[name].setup, lspconfig[name], config)
      if not ok then
        vim.notify('Failed to setup ' .. name .. ': ' .. tostring(err), vim.log.levels.WARN)
      end
    end

    for name, config in pairs(servers) do
      if name == 'biome' then
        local biome_path = vim.fn.stdpath('data') .. '/mason/bin/biome'
        if vim.fn.executable(biome_path) == 1 then
          setup_server(name, config)
        else
          vim.notify('Biome not found. Install with :Mason', vim.log.levels.WARN)
        end
      else
        setup_server(name, config)
      end
    end
  end
end

return M

