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
            o = {
                name = "Java",
                b = { "<cmd>MavenBuild<CR>", "Maven build" },
                t = { "<cmd>MavenTest<CR>", "Maven test" },
                r = { "<cmd>MavenRun<CR>", "Maven run" },
                c = { "<cmd>MavenClean<CR>", "Maven clean" },
            },
            g = {
                name = "Gradle",
                b = { "<cmd>GradleBuild<CR>", "Gradle build" },
                t = { "<cmd>GradleTest<CR>", "Gradle test" },
                r = { "<cmd>GradleRun<CR>", "Gradle run" },
                c = { "<cmd>GradleClean<CR>", "Gradle clean" },
            },
            f = { "<cmd>JavaFormat<CR>", "Format code" },
            o = { "<cmd>lua require('jdtls').organize_imports()<CR>", "Organize imports" },
            v = { "<cmd>lua require('jdtls').extract_variable()<CR>", "Extract variable" },
            c = { "<cmd>lua require('jdtls').extract_constant()<CR>", "Extract constant" },
            m = { "<cmd>lua require('jdtls').extract_method(true)<CR>", "Extract method" },
            t = { "<cmd>lua require('jdtls').test_class()<CR>", "Test class" },
            T = { "<cmd>lua require('jdtls').test_nearest_method()<CR>", "Test method" },
            u = { "<cmd>lua require('jdtls').update_project_config()<CR>", "Update project config" },
            p = { "<cmd>lua require('jdtls').jol()<CR>", "Show memory layout" },
            s = { "<cmd>JavaSecurityCheck<CR>", "Security check" },
            m = { "<cmd>JavaHeapDump<CR>", "Heap dump" },
        },
        d = {
            name = "Debug",
            d = { "<cmd>lua require'dap'.continue()<CR>", "Continue" },
            b = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Toggle breakpoint" },
            r = { "<cmd>lua require'dap'.restart()<CR>", "Restart debug" },
            t = { "<cmd>lua require'dap'.run_to_cursor()<CR>", "Run to cursor" },
            s = { "<cmd>lua require'dap'.step_over()<CR>", "Step over" },
            i = { "<cmd>lua require'dap'.step_into()<CR>", "Step into" },
            o = { "<cmd>lua require'dap'.step_out()<CR>", "Step out" },
            u = { "<cmd>lua require'dapui'.toggle()<CR>", "Toggle DAP UI" },
            q = { "<cmd>lua require'dap'.terminate()<CR>", "Stop debugging" },
        },
        s = {
            name = "Software Eng.",
            e = {
                name = "Java",
                c = { "<cmd>JavaCoverage<CR>", "Coverage" },
                r = { "<cmd>JavaFormat<CR>", "Reformat" },
                t = { "<cmd>RunTests<CR>", "Test" },
                f = { "<cmd>JavaPackageAnalyze<CR>", "Dependencies" },
                s = { "<cmd>JavaSecurityCheck<CR>", "Security scan" },
            },
        },
    }, { prefix = "<leader>" })

    -- Register build command based on project type
    if vim.fn.filereadable('pom.xml') == 1 then
        wk.register({
            j = {
                b = { "<cmd>MavenBuild<CR>", "Build project" },
            }
        }, { prefix = "<leader>" })
    elseif vim.fn.filereadable('build.gradle') == 1 or vim.fn.filereadable('build.gradle.kts') == 1 then
        wk.register({
            j = {
                b = { "<cmd>GradleBuild<CR>", "Build project" },
            }
        }, { prefix = "<leader>" })
    end
end

function M.lsp(bufnr)
    local whichkey_status, wk = pcall(require, "which-key")
    if not whichkey_status then
        return
    end

    wk.register({
        ["<leader>lh"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
        ["<leader>lr"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
        ["<leader>la"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
        ["<leader>ld"] = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Diagnostics" },
        ["<leader>lf"] = { "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "Format" },
        ["<leader>lg"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to Definition" },
        ["<leader>li"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation" },
        ["<leader>ls"] = { "<cmd>lua vim.lsp.buf.document_symbol()<CR>", "Document Symbols" },
        ["<leader>lw"] = { "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "Workspace Symbols" },
        ["<leader>lt"] = { "<cmd>lua vim.lsp.codelens.run()<CR>", "Run CodeLens" },
    }, { buffer = bufnr })
end

function M.dap()
    local whichkey_status, wk = pcall(require, "which-key")
    if not whichkey_status then
        return
    end

    wk.register({
        ["<leader>db"] = { "<cmd>lua require('dap').toggle_breakpoint()<CR>", "Toggle Breakpoint" },
        ["<leader>dc"] = { "<cmd>lua require('dap').continue()<CR>", "Continue" },
        ["<leader>do"] = { "<cmd>lua require('dap').step_over()<CR>", "Step Over" },
        ["<leader>di"] = { "<cmd>lua require('dap').step_into()<CR>", "Step Into" },
        ["<leader>dO"] = { "<cmd>lua require('dap').step_out()<CR>", "Step Out" },
        ["<leader>dr"] = { "<cmd>lua require('dap').repl.open()<CR>", "Open REPL" },
        ["<leader>du"] = { "<cmd>lua require('dapui').toggle()<CR>", "Toggle DAP UI" },
        ["<leader>dq"] = { "<cmd>lua require('dap').terminate()<CR>", "Stop Debugging" },
        ["<leader>dt"] = { "<cmd>lua require('dap').terminate()<CR>", "Terminate Session" },
        ["<leader>dp"] = { "<cmd>lua require('dap').pause()<CR>", "Pause Execution" },
        ["<leader>dw"] = { "<cmd>lua require('dap.ui.widgets').hover()<CR>", "Widget Hover" },
    })
end

return M