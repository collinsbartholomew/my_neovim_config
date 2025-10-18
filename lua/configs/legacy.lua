-- Centralized legacy shim for small `configs.*` compatibility modules
-- Use `require('configs.legacy').load('name')` from tiny forwarders to keep back-compat
local M = {}

local map = {
  -- UI
  telescope = "ui.telescope",
  statusline = "ui.statusline",
  trouble = "ui.trouble",
  toggleterm = "ui.toggleterm",
  neotree = "ui.neotree",
  gitsigns = "ui.gitsigns",
  ["rose-pine"] = "ui.rose_pine",
  colorizer = "ui.colorizer",
  flash = "ui.flash",

  -- Tools
  mason = "configs.tools.mason",
  formatting = "configs.tools.formatting",

  -- Languages (moved under configs/lang)
  assembly = "configs.lang.assembly",
  go = "configs.lang.go",
  rust = "configs.lang.rust",
  nodejs = "configs.lang.nodejs",
  ["flutter-tools"] = "configs.lang.flutter-tools",
  hyprland = "configs.lang.hyprland",
  tensorflow = "configs.lang.tensorflow",
  react = "configs.lang.react",

  -- Other
  completion = "configs.completion",
  ["lsp-unified"] = "configs.lsp-unified",
}

-- load(module_name, call_setup=true)
function M.load(name, call_setup)
  call_setup = call_setup == nil and true or call_setup
  local target = map[name]
  if not target then
    vim.schedule(function()
      vim.notify(("configs.legacy: no mapping for '%s' (tried to load)"):format(name), vim.log.levels.DEBUG)
    end)
    return {}
  end

  local ok, mod = pcall(require, target)
  if not ok then
    vim.schedule(function()
      vim.notify(("Failed to load %s -> %s: %s"):format(name, target, tostring(mod)), vim.log.levels.WARN)
    end)
    return {}
  end

  if call_setup and type(mod) == 'table' and type(mod.setup) == 'function' then
    pcall(mod.setup)
  end
  return mod or {}
end

return M
