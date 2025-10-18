-- UI facade: central entry point for UI modules
-- Provides `require('ui').setup()` and exposes submodules under `ui.*`.
local M = {}
M._modules = {}

-- safe require helper
local function safe_require(path)
  local ok, mod = pcall(require, path)
  if not ok then
    return nil
  end
  return mod
end

-- Register a module reference (used internally by shims)
function M._register(name, mod)
  M._modules[name] = mod or {}
end

-- Setup multiple UI modules by name (or all known modules when none provided)
-- Accepts an optional table of { name = opts } to pass to each module's setup.
function M.setup(mods)
  mods = mods or {}
  -- list of known UI modules
  local known = {
    "bufferline",
    "colorizer",
    "flash",
    "gitsigns",
    "neotree",
    "rose_pine",
    "statusline",
    "telescope",
    "toggleterm",
    "trouble",
  }

  for _, name in ipairs(known) do
    local full = "ui." .. name
    -- If the module is currently being loaded by another require(), skip it to
    -- avoid Lua's 'loop or previous error loading module' which happens when
    -- require is re-entered for the same module name.
    if package.loaded[full] == true then
      -- module is in-load; skip and continue
    else
      local mod = safe_require(full)
      if mod then
        M._register(name, mod)
        local ok, _ = pcall(function()
          if type(mod.setup) == 'function' then
            local opts = mods[name] or {}
            mod.setup(opts)
          end
        end)
        if not ok then
          vim.schedule(function()
            vim.notify(('ui.setup: failed to setup module %s'):format(name), vim.log.levels.WARN)
          end)
        end
      end
    end
  end
end

-- Accessor to retrieve a loaded module
function M.get(name)
  return M._modules[name]
end

return M
