-- Adapter to configure lsp-zero using the project's `configs.lsp.*` data
local M = {}

-- servers_mod: table with servers (configs.lsp.servers)
-- on_attach_mod: module or function
function M.setup(servers_mod, on_attach_mod)
  local ok, lsp_zero = pcall(require, 'lsp-zero')
  if not ok or not lsp_zero then return end

  local preset
  if type(lsp_zero.preset) == 'function' then
    local ok2, p = pcall(lsp_zero.preset, 'recommended')
    preset = ok2 and p or lsp_zero
  else
    preset = lsp_zero
  end

  -- Collect server names to ensure installed
  if type(servers_mod) == 'table' and type(servers_mod.servers) == 'table' then
    local server_names = {}
    for name, _ in pairs(servers_mod.servers) do table.insert(server_names, name) end
    if #server_names > 0 then
      if type(preset.ensure_installed) == 'function' then
        pcall(preset.ensure_installed, server_names)
      elseif type(lsp_zero.ensure_installed) == 'function' then
        pcall(lsp_zero.ensure_installed, server_names)
      end
    end
  end

  -- Wire on_attach
  if type(preset.on_attach) == 'function' and on_attach_mod then
    if type(on_attach_mod.on_attach) == 'function' then
      pcall(preset.on_attach, on_attach_mod.on_attach)
    elseif type(on_attach_mod) == 'function' then
      pcall(preset.on_attach, on_attach_mod)
    end
  end

  -- Finally call setup if available
  if type(preset.setup) == 'function' then
    pcall(preset.setup)
  elseif type(lsp_zero.setup) == 'function' then
    pcall(lsp_zero.setup)
  end
end

return M
