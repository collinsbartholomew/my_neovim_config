-- Small compatibility shim now delegated to `lua/configs/init.lua`.
local configs = require('configs')
local mod = configs.load('assembly') or {}
return mod

