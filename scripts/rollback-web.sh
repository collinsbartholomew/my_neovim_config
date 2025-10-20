#!/bin/bash

# Web rollback script
# added-by-agent: web-setup 20251020-173000

echo "Rolling back Web setup..."

# Restore original web init file
mv lua/profile/languages/web/init.lua.userconf lua/profile/languages/web/init.lua

# Remove added web module files
rm -f lua/profile/languages/web/lsp.lua
rm -f lua/profile/languages/web/dap.lua
rm -f lua/profile/languages/web/tools.lua
rm -f lua/profile/languages/web/mappings.lua
rm -f lua/profile/languages/web/README.md

# Restore original mason.lua
git checkout HEAD -- lua/profile/core/mason.lua

echo "Web setup rolled back."