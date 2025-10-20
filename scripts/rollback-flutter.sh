#!/bin/bash

# Flutter rollback script
# added-by-agent: flutter-setup 20251020-160000

echo "Rolling back Flutter setup..."

# Remove Flutter language module files
rm -rf lua/profile/languages/flutter/

# Restore original mason.lua
git checkout HEAD -- lua/profile/core/mason.lua

# Remove added plugin entries from plugins.lua
sed -i '/added-by-agent: flutter-setup/d' lua/profile/lazy/plugins.lua

# Remove Flutter from language modules if it was added
# (In this case, it was already there, so we don't need to do anything)

echo "Flutter setup rolled back."