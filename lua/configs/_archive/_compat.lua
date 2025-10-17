-- Small shim moved to `lua/configs/init.lua`.
-- Keep this file as a compatibility shim that delegates to the centralized loader.
local configs = require('configs')
-- Provide the same API as old `configs._compat` which exposed `get(name)`.
return { get = configs.get }
