-- Central merged loader for small `configs.*` compatibility modules
-- This file centralizes many tiny forwarders (previously individual files
-- like `lua/configs/telescope.lua`, `lua/configs/gitsigns.lua`, etc.).
-- It exposes `load(name)` and `get(name)` and pre-registers package.loaded
-- entries for the legacy module names so existing `require('configs.NAME')`
-- calls continue to work.

local M = {}

-- Map of legacy short names -> actual module path
local map = {
  -- UI
  telescope = "configs.ui.telescope",
  statusline = "configs.ui.statusline",
  trouble = "configs.ui.trouble",
  toggleterm = "configs.ui.toggleterm",
  neotree = "configs.ui.neotree",
  gitsigns = "configs.ui.gitsigns",
  ["rose-pine"] = "configs.ui.rose-pine",
  colorizer = "configs.ui.colorizer",
  flash = "configs.ui.flash",

  -- Tools
  mason = "configs.tools.mason",
  formatting = "configs.tools.formatting",

  -- Languages (moved under configs.lang)
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

  -- Zig language support (added)
  zig = "configs.lang.zig",
}

-- Attempt to require the target module; returns (ok, mod_or_err)
local function safe_require(target)
  local ok, mod = pcall(require, target)
  if not ok then
    return false, mod
  end
  return true, mod
end

-- load(name, call_setup=true)
-- Loads (or requires) the mapped target for `name`. If `call_setup` is true
-- and the module has a `setup` function, it will be called (protected).
function M.load(name, call_setup)
  call_setup = call_setup == nil and true or call_setup
  local target = map[name]
  if not target then
    return nil, ("no mapping for %s"):format(tostring(name))
  end
  local ok, mod_or_err = safe_require(target)
  if not ok then
    vim.schedule(function()
      vim.notify(("Failed to load %s -> %s: %s"):format(name, target, tostring(mod_or_err)), vim.log.levels.WARN)
    end)
    return nil, mod_or_err
  end

  local mod = mod_or_err
  if call_setup and type(mod) == 'table' and type(mod.setup) == 'function' then
    pcall(mod.setup)
  end
  return mod
end

-- get(name)
-- Returns the mapped module if already loaded (or attempts to require it
-- without calling setup). Use this when you just need the module reference.
function M.get(name)
  local target = map[name]
  if not target then
    return nil
  end
  local ok, mod_or_err = safe_require(target)
  if not ok then
    return nil
  end
  return mod_or_err
end

-- Pre-register package.loaded entries for backward compatibility.
-- For each mapped name we expose a lazy proxy under `configs.NAME` so legacy
-- `require('configs.NAME')` continues to work but the actual target module is
-- only required when the module is first accessed. This avoids eager requires
-- during startup and keeps compatibility.
local function make_lazy_proxy(fullname, target)
  local proxy = {}
  local loaded = false
  local real
  local function ensure()
    if loaded then return real end
    loaded = true
    local ok, mod = pcall(require, target)
    if ok and mod ~= nil then
      real = mod
    else
      -- If the target cannot be required, set real to an empty table to avoid
      -- errors on subsequent accesses; also notify once.
      real = {}
      vim.schedule(function()
        vim.notify(('configs.init: failed to require %s -> %s'):format(fullname, target), vim.log.levels.DEBUG)
      end)
    end
    -- Replace proxy in package.loaded with the real module for future requires
    package.loaded[fullname] = real
    return real
  end

  return setmetatable(proxy, {
    __index = function(_, k)
      local mod = ensure()
      return mod and mod[k]
    end,
    __newindex = function(_, k, v)
      local mod = ensure()
      mod[k] = v
    end,
    __call = function(_, ...)
      local mod = ensure()
      if type(mod) == 'function' then
        return mod(...)
      elseif type(mod.call) == 'function' then
        return mod.call(...)
      end
      error(('Module %s is not callable'):format(fullname))
    end,
    __tostring = function()
      return ('<configs.proxy for %s -> %s>'):format(fullname, target)
    end,
  })
end

for name, target in pairs(map) do
  local fullname = ("configs.%s"):format(name)
  if not package.loaded[fullname] then
    package.loaded[fullname] = make_lazy_proxy(fullname, target)
  end
end

-- Expose legacy API compatibility entries
package.loaded['configs._compat'] = {
  get = M.get,
}
package.loaded['configs.legacy'] = {
  load = function(name, call_setup)
    return M.load(name, call_setup)
  end,
}

return M
