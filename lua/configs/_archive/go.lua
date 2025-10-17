-- Forwarding shim to the centralized legacy loader (configs.legacy).
local configs = require('configs')
local mod = configs.load('go') or {}
return mod
