#!/bin/bash

# Flutter verification script
# added-by-agent: flutter-setup 20251020-160000

set -e

echo "Starting Flutter verification..." > scripts/verify-flutter.log

# Test Neovim headless startup
echo "Testing Neovim headless startup..." >> scripts/verify-flutter.log
if nvim --headless -u ~/.config/nvim/init.lua -c 'echo "startup_ok"' -c 'qa!' 2>> scripts/verify-flutter.log; then
  echo "Neovim startup: PASS" >> scripts/verify-flutter.log
else
  echo "Neovim startup: FAIL" >> scripts/verify-flutter.log
fi

# Test SDK detection
echo "Testing SDK detection..." >> scripts/verify-flutter.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua local flutter = vim.fn.executable("flutter"); local dart = vim.fn.executable("dart"); local fvm = vim.fn.executable("fvm"); print("Flutter:", flutter == 1 and "found" or "not found", "Dart:", dart == 1 and "found" or "not found", "FVM:", fvm == 1 and "found" or "not found")' -c 'qa!' >> scripts/verify-flutter.log 2>&1 || echo "SDK detection failed" >> scripts/verify-flutter.log

# Test Mason registry for dart-debug-adapter
echo "Testing Mason registry..." >> scripts/verify-flutter.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua local mason_status, mason_registry = pcall(require, "mason-registry"); if mason_status then mason_registry.refresh(); local installed = mason_registry.get_installed_packages(); local found = {}; for _, pkg in ipairs(installed) do if pkg.name == "dart-debug-adapter" then table.insert(found, pkg.name) end end; print("Mason packages found:", table.concat(found, ", ")) else print("Mason registry not available") end' -c 'qa!' >> scripts/verify-flutter.log 2>&1 || echo "Mason test failed" >> scripts/verify-flutter.log

# Test LSP load
echo "Testing LSP load..." >> scripts/verify-flutter.log
echo "void main() { print('ok'); }" > /tmp/tmp_main.dart
nvim --headless -u ~/.config/nvim/init.lua /tmp/tmp_main.dart -c 'sleep 2000ms' -c 'lua local flutter_tools_status, flutter_tools = pcall(require, "flutter-tools"); if flutter_tools_status then print("Flutter tools: loaded") else print("Flutter tools: not available") end' -c 'bd!' -c 'qa!' >> scripts/verify-flutter.log 2>&1 || echo "LSP test failed" >> scripts/verify-flutter.log
rm -f /tmp/tmp_main.dart

# Test command presence
echo "Testing command presence..." >> scripts/verify-flutter.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua local cmds = { "FlutterRun", "FlutterTest", "FvmUse", "DevTools", "DartFormat", "FlutterDoctor" }; local found = {}; for _, cmd in ipairs(cmds) do if vim.fn.exists(":" .. cmd) == 2 then table.insert(found, cmd) end end; print("Commands found:", table.concat(found, ", "))' -c 'qa!' >> scripts/verify-flutter.log 2>&1 || echo "Command test failed" >> scripts/verify-flutter.log

# Test DAP adapter
echo "Testing DAP adapter..." >> scripts/verify-flutter.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua local dap_status, dap = pcall(require, "dap"); if dap_status then local adapter = dap.adapters.dart; if adapter then print("DAP adapter: registered") else print("DAP adapter: not registered") end else print("DAP: not available") end' -c 'qa!' >> scripts/verify-flutter.log 2>&1 || echo "DAP test failed" >> scripts/verify-flutter.log

echo "Flutter verification completed. Check scripts/verify-flutter.log for details."