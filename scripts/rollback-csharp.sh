#!/bin/bash

# C# rollback script
# added-by-agent: csharp-setup 20251020-153000

echo "Rolling back C# setup..."

# Remove C# language module files
rm -rf lua/profile/languages/csharp/

# Restore original diagnostics.lua
git checkout HEAD -- lua/profile/ui/diagnostics.lua

# Restore original mason.lua
git checkout HEAD -- lua/profile/core/mason.lua

# Remove added plugin entries from plugins.lua
sed -i '/added-by-agent: csharp-setup/d' lua/profile/lazy/plugins.lua

echo "C# setup rolled back."