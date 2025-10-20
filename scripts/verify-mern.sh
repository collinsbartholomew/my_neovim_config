#!/bin/bash

# MERN verification script
# added-by-agent: mern-setup 20251020-170000

set -e

echo "Starting MERN verification..." > scripts/verify-mern.log

# Test Neovim headless startup
echo "Testing Neovim headless startup..." >> scripts/verify-mern.log
if nvim --headless -u ~/.config/nvim/init.lua -c 'echo "startup_ok"' -c 'qa!' 2>> scripts/verify-mern.log; then
  echo "Neovim startup: PASS" >> scripts/verify-mern.log
else
  echo "Neovim startup: FAIL" >> scripts/verify-mern.log
fi

# Test Node and pnpm detection
echo "Testing Node and pnpm detection..." >> scripts/verify-mern.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua local node = vim.fn.exepath("node"); local pnpm = vim.fn.exepath("pnpm"); print("Node:", node ~= "" and "found" or "not found", "Pnpm:", pnpm ~= "" and "found" or "not found")' -c 'qa!' >> scripts/verify-mern.log 2>&1 || echo "Node/pnpm detection failed" >> scripts/verify-mern.log

# Test Mason packages
echo "Testing Mason packages..." >> scripts/verify-mern.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua local mason_registry = require("mason-registry"); mason_registry.refresh(); local packages = {"typescript-language-server", "eslint", "html", "cssls", "tailwindcss", "jsonls", "js-debug-adapter"}; local found = {}; for _, pkg in ipairs(packages) do if mason_registry.is_installed(pkg) then table.insert(found, pkg) end end; print("Mason packages found:", table.concat(found, ", "))' -c 'qa!' >> scripts/verify-mern.log 2>&1 || echo "Mason test failed" >> scripts/verify-mern.log

# Test LSP configuration
echo "Testing LSP configuration..." >> scripts/verify-mern.log
echo "console.log('test');" > /tmp/mern_tmp_test.ts
nvim --headless -u ~/.config/nvim/init.lua /tmp/mern_tmp_test.ts -c 'sleep 2000ms' -c 'lua local clients = vim.lsp.get_active_clients(); local tsserver_found = false; for _, client in ipairs(clients) do if client.name == "tsserver" then tsserver_found = true; break; end end; print("TypeScript LSP:", tsserver_found and "found" or "not found")' -c 'bd!' -c 'qa!' >> scripts/verify-mern.log 2>&1 || echo "LSP test failed" >> scripts/verify-mern.log
rm -f /tmp/mern_tmp_test.ts

# Test DAP configuration
echo "Testing DAP configuration..." >> scripts/verify-mern.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua local dap_status, dap = pcall(require, "dap"); if dap_status then local pwa_node = dap.adapters["pwa-node"]; if pwa_node then print("DAP pwa-node: registered") else print("DAP pwa-node: not registered") end else print("DAP: not available") end' -c 'qa!' >> scripts/verify-mern.log 2>&1 || echo "DAP test failed" >> scripts/verify-mern.log

# Test command presence
echo "Testing command presence..." >> scripts/verify-mern.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua local cmds = { "NpmInstall", "StartDev", "Format" }; local found = {}; for _, cmd in ipairs(cmds) do if vim.fn.exists(":" .. cmd) == 2 then table.insert(found, cmd) end end; print("Commands found:", table.concat(found, ", "))' -c 'qa!' >> scripts/verify-mern.log 2>&1 || echo "Command test failed" >> scripts/verify-mern.log

echo "MERN verification completed. Check scripts/verify-mern.log for details."