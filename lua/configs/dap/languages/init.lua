-- Combined DAP language configurations
-- This consolidates per-language files into one module to reduce fragmentation.
local ok, dap = pcall(require, 'dap')
if not ok then
  vim.notify('DAP not available: ' .. tostring(dap), vim.log.levels.WARN)
  return {}
end

-- Global: nothing extra here (dap/init.lua already set some defaults)

-- JavaScript / TypeScript (pwa-node)
dap.configurations.javascript = {
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    cwd = '${workspaceFolder}',
  },
  {
    type = 'pwa-node',
    request = 'attach',
    name = 'Attach',
    processId = require('dap.utils').pick_process,
    cwd = '${workspaceFolder}',
  },
}

dap.configurations.typescript = dap.configurations.javascript

-- Go (delve)
dap.configurations.go = {
  {
    type = 'delve',
    name = 'Debug',
    request = 'launch',
    program = '${file}',
  },
  {
    type = 'delve',
    name = 'Debug test',
    request = 'launch',
    mode = 'test',
    program = '${file}',
  },
  {
    type = 'delve',
    name = 'Debug test (go.mod)',
    request = 'launch',
    mode = 'test',
    program = './${relativeFileDirname}',
  },
}

-- Rust (codelldb)
dap.configurations.rust = {
  {
    name = 'Launch file',
    type = 'codelldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

-- C / C++ / headers (codelldb + cppdbg)
dap.configurations.c = {
  {
    name = 'Launch file',
    type = 'codelldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
  {
    name = 'Launch with Valgrind (Memory Debug)',
    type = 'codelldb',
    request = 'launch',
    program = '/usr/bin/valgrind',
    args = {
      '--tool=memcheck',
      '--leak-check=full',
      '--show-leak-kinds=all',
      '--track-origins=yes',
      '--verbose',
      function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
    },
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
  {
    name = 'Launch with AddressSanitizer',
    type = 'codelldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    env = { ASAN_OPTIONS = 'detect_leaks=1' },
    args = {},
  },
  {
    name = 'Attach to Process',
    type = 'codelldb',
    request = 'attach',
    pid = require('dap.utils').pick_process,
    stopOnEntry = false,
  },
  {
    name = 'Launch with GDB',
    type = 'cppdbg',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = false,
    setupCommands = {
      { description = 'Enable pretty-printing for gdb', text = '-enable-pretty-printing', ignoreFailures = true },
      { description = 'Set Disassembly Flavor to Intel', text = '-gdb-set disassembly-flavor intel', ignoreFailures = true },
    },
  },
}

dap.configurations.cpp = dap.configurations.c
dap.configurations.hpp = dap.configurations.c
dap.configurations.h = dap.configurations.c

-- Assembly (reuse codelldb)
dap.configurations.asm = {
  {
    name = 'Debug Assembly',
    type = 'codelldb',
    request = 'launch',
    program = '${fileDirname}/${fileBasenameNoExtension}',
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
  },
}

dap.configurations.nasm = dap.configurations.asm
dap.configurations.gas = dap.configurations.asm

-- Python (debugpy)
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    pythonPath = function()
      return '/usr/bin/python'
    end,
  },
}

-- Java
dap.configurations.java = {
  {
    type = 'java',
    request = 'attach',
    name = 'Debug (Attach) - Remote',
    hostName = '127.0.0.1',
    port = 5005,
  },
  {
    type = 'java',
    request = 'launch',
    name = 'Debug (Launch) - Current File',
    mainClass = '${file}',
  },
}

-- Dart / Flutter
dap.configurations.dart = {
  {
    type = 'dart',
    request = 'launch',
    name = 'Launch dart',
    dartSdkPath = vim.fn.expand('~/flutter/bin/cache/dart-sdk/'),
    flutterSdkPath = vim.fn.expand('~/flutter'),
    program = '${workspaceFolder}/lib/main.dart',
    cwd = '${workspaceFolder}',
  },
}

-- Bash (bashdb)
dap.configurations.sh = {
  {
    type = 'bashdb',
    request = 'launch',
    name = 'Launch file',
    showDebugOutput = true,
    pathBashdb = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
    pathBashdbLib = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
    trace = true,
    file = '${file}',
    program = '${file}',
    cwd = '${workspaceFolder}',
    pathCat = 'cat',
    pathBash = '/bin/bash',
    pathMkfifo = 'mkfifo',
    pathPkill = 'pkill',
    args = {},
    env = {},
    terminalKind = 'integrated',
  },
}

-- .NET / C#
dap.configurations.cs = {
  {
    type = 'coreclr',
    name = 'Launch- netcoredbg',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}

return {}

