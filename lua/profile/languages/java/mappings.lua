-- added-by-agent: java-setup 20251020-163000
-- mason: jdtls
-- manual: java-debug and vscode-java-test bundle build steps

local M = {}

function M.setup()
  local whichkey_status, wk = pcall(require, "which-key")
  if not whichkey_status then
    vim.notify("which-key not available for Java mappings", vim.log.levels.WARN)
    return
  end

  wk.register({
    j = {
      name = "Java",
      b = { "<cmd>lua require('profile.languages.java.tools').build()<CR>", "Build project" },
      t = { "<cmd>RunTests<CR>", "Run tests" },
      r = { "<cmd>JavaRun<CR>", "Run program" },
      f = { "<cmd>JavaFormat<CR>", "Format code" },
      o = { "<cmd>lua require('jdtls').organize_imports()<CR>", "Organize imports" },
      v = { "<cmd>lua require('jdtls').extract_variable()<CR>", "Extract variable" },
      c = { "<cmd>lua require('jdtls').extract_constant()<CR>", "Extract constant" },
    },
    d = {
      name = "Debug",
      d = { "<cmd>lua require'dap'.continue()<CR>", "Continue" },
      b = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Toggle breakpoint" },
      r = { "<cmd>lua require'dap'.restart()<CR>", "Restart debug" },
      t = { "<cmd>lua require'dap'.run_to_cursor()<CR>", "Debug test" },
    },
    v = {
      name = "Tools",
      j = { "<cmd>JavaPackageAnalyze<CR>", "Analyze dependencies" },
      c = { "<cmd>JavaCoverage<CR>", "Code coverage" },
    },
  }, { prefix = "<leader>" })
  
  -- Register build command based on project type
  if vim.fn.filereadable('pom.xml') == 1 then
    wk.register({
      j = {
        b = { "<cmd>MavenBuild<CR>", "Maven build" },
      }
    }, { prefix = "<leader>" })
  elseif vim.fn.filereadable('build.gradle') == 1 or vim.fn.filereadable('build.gradle.kts') == 1 then
    wk.register({
      j = {
        b = { "<cmd>GradleBuild<CR>", "Gradle build" },
      }
    }, { prefix = "<leader>" })
  end
end

return M