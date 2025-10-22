-- added-by-agent: web-setup 20251020-173000
-- mason: prettier, eslint
-- manual: node.js, pnpm installation required

local M = {}

function M.setup()
    -- NpmInstall command
    vim.api.nvim_create_user_command("NpmInstall", function()
        vim.cmd("belowright new | terminal npm install")
    end, {})

    -- YarnInstall command
    vim.api.nvim_create_user_command("YarnInstall", function()
        vim.cmd("belowright new | terminal yarn install")
    end, {})

    -- PnpmInstall command
    vim.api.nvim_create_user_command("PnpmInstall", function()
        vim.cmd("belowright new | terminal pnpm install")
    end, {})

    -- StartDev command
    vim.api.nvim_create_user_command("StartDev", function()
        vim.cmd("belowright new | terminal npm run dev")
    end, {})

    -- StartDevYarn command
    vim.api.nvim_create_user_command("StartDevYarn", function()
        vim.cmd("belowright new | terminal yarn dev")
    end, {})

    -- StartDevPnpm command
    vim.api.nvim_create_user_command("StartDevPnpm", function()
        vim.cmd("belowright new | terminal pnpm run dev")
    end, {})

    -- Build command
    vim.api.nvim_create_user_command("WebBuild", function()
        vim.cmd("belowright new | terminal npm run build")
    end, {})

    -- Test command
    vim.api.nvim_create_user_command("WebTest", function()
        vim.cmd("belowright new | terminal npm test")
    end, {})

    -- Format command
    vim.api.nvim_create_user_command("WebFormat", function()
        vim.lsp.buf.format()
    end, {})

    -- Null-ls setup for formatting and linting
    local null_ls_status, null_ls = pcall(require, "null-ls")
    if null_ls_status then
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.prettierd.with({
                    extra_filetypes = { "astro", "mdx" }
                }),
                null_ls.builtins.formatting.prettier.with({
                    extra_filetypes = { "astro", "mdx" }
                }),
                null_ls.builtins.diagnostics.eslint_d,
                null_ls.builtins.code_actions.eslint_d,
                null_ls.builtins.diagnostics.stylelint,
            },
        })
    end

    -- Emmet setup
    vim.g.user_emmet_mode = "n"
    vim.g.user_emmet_install_global = 0
    vim.cmd([[autocmd FileType html,css,scss,sass,less,javascript,typescript,jsx,tsx,vue,svelte,astro,mdx EmmetInstall]])
    
    -- Add custom functions for web development
    _G.web_utils = {
        -- Run npm script
        run_npm_script = function()
            local script = vim.fn.input("npm run: ")
            if script ~= "" then
                vim.cmd("belowright new | terminal npm run " .. script)
            end
        end,
        
        -- Run yarn script
        run_yarn_script = function()
            local script = vim.fn.input("yarn: ")
            if script ~= "" then
                vim.cmd("belowright new | terminal yarn " .. script)
            end
        end,
        
        -- Run pnpm script
        run_pnpm_script = function()
            local script = vim.fn.input("pnpm: ")
            if script ~= "" then
                vim.cmd("belowright new | terminal pnpm " .. script)
            end
        end,
        
        -- Create React component
        create_react_component = function()
            local name = vim.fn.input("Component name: ")
            if name == "" then return end
            
            local content = {
                "import React from 'react';",
                "",
                "interface " .. name .. "Props {",
                "  // Define your props here",
                "}",
                "",
                "const " .. name .. ": React.FC<" .. name .. "Props> = ({}) => {",
                "  return (",
                "    <div>",
                "      " .. name .. " component",
                "    </div>",
                "  );",
                "};",
                "",
                "export default " .. name .. ";"
            }
            
            -- Create new buffer with component content
            local buf = vim.api.nvim_create_buf(true, false)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
            vim.api.nvim_buf_set_name(buf, name .. ".tsx")
            vim.api.nvim_set_current_buf(buf)
        end,
        
        -- Create Express route
        create_express_route = function()
            local name = vim.fn.input("Route name: ")
            if name == "" then return end
            
            local content = {
                "import { Router } from 'express';",
                "const router = Router();",
                "",
                "// GET " .. name .. " route",
                "router.get('/" .. name .. "', (req, res) => {",
                "  res.json({ message: 'GET " .. name .. " route' });",
                "});",
                "",
                "// POST " .. name .. " route",
                "router.post('/" .. name .. "', (req, res) => {",
                "  res.json({ message: 'POST " .. name .. " route' });",
                "});",
                "",
                "export default router;"
            }
            
            -- Create new buffer with route content
            local buf = vim.api.nvim_create_buf(true, false)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
            vim.api.nvim_buf_set_name(buf, name .. "Route.ts")
            vim.api.nvim_set_current_buf(buf)
        end
    }
end

return M