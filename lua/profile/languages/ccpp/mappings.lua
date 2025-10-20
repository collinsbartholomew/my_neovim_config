-- added-by-agent: ccpp-setup 20251020
-- mason: none
-- manual: none

local M = {}

function M.setup()
  local which_key_ok, wk = pcall(require, "which-key")
  if not which_key_ok then
    vim.notify("which-key not available", vim.log.levels.WARN)
    return
  end

  -- Register C/C++ specific mappings
  wk.register({
    ["<leader>c"] = {
      name = "code/clang",
      c = { "<cmd>ClangTidy<cr>", "Run clang-tidy" },
      f = { function()
        if pcall(require, "conform") then
          require("conform").format()
        else
          vim.lsp.buf.format()
        end
      end, "Format buffer" },
      h = { "<cmd>ClangdSwitchSourceHeader<cr>", "Switch header/source" },
    },
    ["<leader>b"] = {
      name = "build",
      b = { "<cmd>CMakeBuild<cr>", "Build project" },
      d = { "<cmd>MakeCompileDB<cr>", "Generate compile_commands.json" },
    },
    ["<leader>d"] = {
      name = "debug",
      b = { function() require("dap").toggle_breakpoint() end, "Toggle breakpoint" },
      c = { function() require("dap").continue() end, "Continue" },
      i = { function() require("dap").step_into() end, "Step into" },
      o = { function() require("dap").step_over() end, "Step over" },
      r = { function() require("dap").repl.open() end, "Open REPL" },
      t = { function()
        if pcall(require, "dapui") then
          require("dapui").toggle()
        end
      end, "Toggle UI" },
    },
    ["<leader>q"] = {
      name = "QML",
      f = { function()
        vim.lsp.buf.format({ name = "qmlls" })
      end, "Format QML" },
      n = { "<cmd>edit qml.config<cr>", "Edit QML config" },
    },
  })
end

return M
