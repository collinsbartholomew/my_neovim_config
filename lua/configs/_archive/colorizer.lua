-- Compatibility shim delegated to centralized `lua/configs/init.lua`.
local configs = require('configs')
local mod = configs.load('colorizer') or {}
return mod

