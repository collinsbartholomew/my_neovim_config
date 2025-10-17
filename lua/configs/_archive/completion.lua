-- Delegated completion loader via centralized configs
local configs = require('configs')
local mod = configs.load('completion') or {}
return mod

