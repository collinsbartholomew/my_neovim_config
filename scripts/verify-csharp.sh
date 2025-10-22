#!/bin/bash

# C# verification script
# added-by-agent: csharp-setup 20251020-153000

set -e

echo "Starting C# verification..." > scripts/verify-csharp.log

# Test Neovim headless startup
echo "Testing Neovim headless startup..." >> scripts/verify-csharp.log
if nvim --headless -u ~/.config/nvim/init.lua -c 'echo "startup_ok"' -c 'qa!' 2>> scripts/verify-csharp.log; then
  echo "Neovim startup: PASS" >> scripts/verify-csharp.log
else
  echo "Neovim startup: FAIL" >> scripts/verify-csharp.log
fi

# Test Mason presence
echo "Testing Mason packages..." >> scripts/verify-csharp.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua require("mason-registry").refresh(); local installed = require("mason-registry").get_installed_packages(); local found = {}; for _, pkg in ipairs(installed) do if pkg.name == "omnisharp" or pkg.name == "netcoredbg" then table.insert(found, pkg.name) end end; print("Mason packages found:", table.concat(found, ", "))' -c 'qa!' >> scripts/verify-csharp.log 2>&1 || echo "Mason test failed" >> scripts/verify-csharp.log

# Test LSP configuration
echo "Testing LSP configuration..." >> scripts/verify-csharp.log
echo "class Program { static void Main() { System.Console.WriteLine(1); } }" > /tmp/tmp.cs
nvim --headless -u ~/.config/nvim/init.lua /tmp/tmp.cs -c 'sleep 2000ms' -c 'lua local clients = vim.lsp.get_active_clients(); local omnisharp_found = false; for _, client in ipairs(clients) do if client.name == "omnisharp" then omnisharp_found = true; break; end end; print("OmniSharp LSP:", omnisharp_found and "found" or "not found")' -c 'bd!' -c 'qa!' >> scripts/verify-csharp.log 2>&1 || echo "LSP test failed" >> scripts/verify-csharp.log
rm -f /tmp/tmp.cs

# Test command presence
echo "Testing command presence..." >> scripts/verify-csharp.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua local cmds = { "DotnetBuild", "DotnetTest", "DotnetFormat" }; local found = {}; for _, cmd in ipairs(cmds) do if vim.fn.exists(":" .. cmd) == 2 then table.insert(found, cmd) end end; print("Commands found:", table.concat(found, ", "))' -c 'qa!' >> scripts/verify-csharp.log 2>&1 || echo "Command test failed" >> scripts/verify-csharp.log

echo "C# verification completed. Check scripts/verify-csharp.log for details."
