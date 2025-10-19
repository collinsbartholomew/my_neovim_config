local M = {}

function M.setup()
    -- Load language-specific configurations
    local language_modules = {
        "web",      -- JavaScript/TypeScript/HTML/CSS
        "rust",     -- Rust
        "cpp",      -- C/C++
        "go",       -- Go
        "python",   -- Python
        "embedded", -- Assembly/Embedded
        "system",   -- System configuration files
    }

    for _, lang in ipairs(language_modules) do
        local ok, module = pcall(require, "langs." .. lang)
        if ok then
            if type(module.setup) == "function" then
                pcall(module.setup)
            end
        else
            vim.notify("Failed to load language module: " .. lang, vim.log.levels.WARN)
        end
    end
end

return M
