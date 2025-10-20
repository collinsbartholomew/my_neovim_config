#!/bin/bash

# Java rollback script
# added-by-agent: java-setup 20251020-163000

echo "Rolling back Java setup..."

# Remove Java language module files
rm -rf lua/profile/languages/java/

# Restore original mason.lua
git checkout HEAD -- lua/profile/core/mason.lua

# Remove added plugin entries from plugins.lua
sed -i '/added-by-agent: java-setup/d' lua/profile/lazy/plugins.lua

echo "Java setup rolled back."