-- Centralized LSP setup: integrates lsp-zero (preferred), mason, mason-lspconfig, and configs.lsp.*
local M = {}

local function safe_require(name)
  local ok, mod = pcall(require, name)
  if not ok then return nil end
  return mod
end

function M.setup()
  local lsp_cfg = safe_require('configs.lsp') or {}
  local cap_mod = lsp_cfg.capabilities
  local capabilities = (cap_mod and type(cap_mod) == 'table' and cap_mod.setup and cap_mod.setup()) or (type(cap_mod) == 'function' and cap_mod()) or vim.lsp.protocol.make_client_capabilities()
  local on_attach_mod = lsp_cfg.on_attach or safe_require('configs.lsp.on_attach')
  local servers_mod = lsp_cfg.servers or safe_require('configs.lsp.servers') or {}

  -- Attempt to use lsp-zero if it's installed. Use it in a best-effort way and
  -- always wrap calls in pcall so missing methods won't break startup.
  local lsp_zero = safe_require('lsp-zero') or safe_require('lsp_zero')
  local mason = safe_require('mason')
  local mlsp = safe_require('mason-lspconfig')

  if lsp_zero then
    -- If a small adapter exists, use it to configure lsp-zero in a consistent way
    local adapter = safe_require('configs.lsp.lsp_zero')
    if adapter and type(adapter.setup) == 'function' then
      pcall(adapter.setup, servers_mod, on_attach_mod)
      return
    end

    -- If mason-lspconfig is available, ask it to ensure servers are installed
    if mlsp and type(mlsp.ensure_installed) == 'function' and type(servers_mod.servers) == 'table' then
      local server_names = {}
      for name, _ in pairs(servers_mod.servers) do table.insert(server_names, name) end
      if #server_names > 0 then
        pcall(function() mlsp.setup({ ensure_installed = server_names }) end)
      end
    end

    -- Try to configure lsp-zero directly as a fallback
    pcall(function()
      if type(lsp_zero.preset) == 'function' then
        local ok, preset = pcall(lsp_zero.preset, { name = 'recommended' })
        if ok and preset then
          if type(preset.on_attach) == 'function' and on_attach_mod and on_attach_mod.on_attach then
            pcall(preset.on_attach, on_attach_mod.on_attach)
          elseif type(preset.on_attach) == 'function' and on_attach_mod then
            pcall(preset.on_attach, on_attach_mod)
          end
          if type(preset.setup) == 'function' then pcall(preset.setup) end
        end
      end

      if type(lsp_zero.setup) == 'function' then
        pcall(lsp_zero.setup, {})
      end

      if type(lsp_zero.ensure_installed) == 'function' and type(servers_mod.servers) == 'table' then
        local server_names = {}
        for name, _ in pairs(servers_mod.servers) do table.insert(server_names, name) end
        if #server_names > 0 then pcall(lsp_zero.ensure_installed, server_names) end
      end
    end)

    return
  end

  -- No lsp-zero: fall back to mason + autostart wiring
  if mason and mlsp then
    local server_names = {}
    if type(servers_mod.servers) == 'table' then
      for name, _ in pairs(servers_mod.servers) do table.insert(server_names, name) end
    end
    if #server_names > 0 and mlsp.ensure_installed then
      pcall(function() mlsp.setup({ ensure_installed = server_names }) end)
    end
  end

  -- Defer to configs.lsp.autostart to wire autostart behavior
  local autostart = safe_require('configs.lsp.autostart')
  if autostart and autostart.setup then
    pcall(autostart.setup, lsp_cfg.capabilities or capabilities, on_attach_mod, servers_mod)
  else
    if lsp_cfg and type(lsp_cfg.setup) == 'function' then
      pcall(lsp_cfg.setup)
    end
  end
end

return M
