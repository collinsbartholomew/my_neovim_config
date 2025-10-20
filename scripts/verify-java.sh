#!/bin/bash

# Java verification script
# added-by-agent: java-setup 20251020-163000

set -e

echo "Starting Java verification..." > scripts/verify-java.log

# Test Neovim headless startup
echo "Testing Neovim headless startup..." >> scripts/verify-java.log
if nvim --headless -u ~/.config/nvim/init.lua -c 'echo "startup_ok"' -c 'qa!' 2>> scripts/verify-java.log; then
  echo "Neovim startup: PASS" >> scripts/verify-java.log
else
  echo "Neovim startup: FAIL" >> scripts/verify-java.log
fi

# Test Java tools detection
echo "Testing Java tools detection..." >> scripts/verify-java.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua local java = vim.fn.executable("java"); local javac = vim.fn.executable("javac"); local jdtls_mason = false; local mason_status, mason_registry = pcall(require, "mason-registry"); if mason_status then mason_registry.refresh(); jdtls_mason = mason_registry.is_installed("jdtls"); end; print("Java:", java == 1 and "found" or "not found", "Javac:", javac == 1 and "found" or "not found", "JDTLS (Mason):", jdtls_mason and "installed" or "not installed")' -c 'qa!' >> scripts/verify-java.log 2>&1 || echo "Java tools detection failed" >> scripts/verify-java.log

# Test bundles detection
echo "Testing bundles detection..." >> scripts/verify-java.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua local dap = require("profile.languages.java.dap"); local bundles = dap.get_bundles(); print("Debug bundles found:", #bundles)' -c 'qa!' >> scripts/verify-java.log 2>&1 || echo "Bundles detection failed" >> scripts/verify-java.log

# Test LSP configuration
echo "Testing LSP configuration..." >> scripts/verify-java.log
echo "public class Main { public static void main(String[] args) { System.out.println(\"ok\"); } }" > /tmp/Main.java
nvim --headless -u ~/.config/nvim/init.lua /tmp/Main.java -c 'sleep 2000ms' -c 'lua local jdtls_status, jdtls = pcall(require, "jdtls"); if jdtls_status then print("JDTLS module: loaded") else print("JDTLS module: not available") end' -c 'bd!' -c 'qa!' >> scripts/verify-java.log 2>&1 || echo "LSP test failed" >> scripts/verify-java.log
rm -f /tmp/Main.java

# Test command presence
echo "Testing command presence..." >> scripts/verify-java.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua local cmds = { "JavaFormat", "MavenBuild", "GradleBuild", "RunTests", "JavaRun" }; local found = {}; for _, cmd in ipairs(cmds) do if vim.fn.exists(":" .. cmd) == 2 then table.insert(found, cmd) end end; print("Commands found:", table.concat(found, ", "))' -c 'qa!' >> scripts/verify-java.log 2>&1 || echo "Command test failed" >> scripts/verify-java.log

# Test DAP configuration
echo "Testing DAP configuration..." >> scripts/verify-java.log
nvim --headless -u ~/.config/nvim/init.lua -c 'lua local dap_status, dap = pcall(require, "dap"); if dap_status then local java_config = dap.configurations.java; if java_config then print("DAP Java config: available") else print("DAP Java config: not available") end else print("DAP: not available") end' -c 'qa!' >> scripts/verify-java.log 2>&1 || echo "DAP test failed" >> scripts/verify-java.log

echo "Java verification completed. Check scripts/verify-java.log for details."