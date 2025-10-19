local M = {}

local health = vim.health or require("health")

local function check_plugin_health()
    local plugins = {
        "lazy.nvim",
        "mason.nvim",
        "nvim-lspconfig",
        "nvim-treesitter",
    }

    for _, plugin in ipairs(plugins) do
        local ok = pcall(require, plugin:gsub("%.nvim$", ""))
        if ok then
            health.ok(plugin .. " is installed")
        else
            health.error(plugin .. " is not installed")
        end
    end
end

local function check_lsp_health()
    local lspconfig = require("lspconfig")
    local servers = {
        "lua_ls",
        "tsserver",
        "pyright",
        "gopls",
        "rust_analyzer",
        "clangd",
    }

    for _, server in ipairs(servers) do
        local configs = require("lspconfig.configs")
        if configs[server] then
            if vim.fn.executable(configs[server].document_config.default_config.cmd[1]) == 1 then
                health.ok(server .. " executable is available")
            else
                health.warn(server .. " executable not found in PATH")
            end
        else
            health.error(server .. " configuration not found")
        end
    end
end

local function check_treesitter_health()
    local parsers = {
        "lua",
        "vim",
        "query",
        "typescript",
        "javascript",
        "python",
        "go",
        "rust",
        "c",
        "cpp",
    }

    for _, parser in ipairs(parsers) do
        local has_parser = vim.treesitter.language.require_language(parser, nil, true)
        if has_parser then
            health.ok(parser .. " parser is installed")
        else
            health.warn(parser .. " parser is not installed")
        end
    end
end

local function check_mason_health()
    local registry = require("mason-registry")
    local required_tools = {
        "prettier",
        "stylua",
        "black",
        "isort",
        "rustfmt",
        "eslint_d",
        "pylint",
        "shellcheck",
    }

    for _, tool in ipairs(required_tools) do
        if registry.is_installed(tool) then
            health.ok(tool .. " is installed")
        else
            health.warn(tool .. " is not installed")
        end
    end
end

function M.check()
    health.start("Neovim Configuration Health Check")

    health.info("Checking plugin health...")
    check_plugin_health()

    health.info("Checking LSP health...")
    check_lsp_health()

    health.info("Checking Treesitter health...")
    check_treesitter_health()

    health.info("Checking Mason tools...")
    check_mason_health()
end

return M
