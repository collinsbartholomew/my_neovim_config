-- Legacy module compatibility layer
local M = {}

-- Set up compatibility layer for newer Neovim features
function M.setup()
    -- Handle older Neovim versions that don't have all features
    local function ensure_feature(feature_check, setup_fn)
        local ok, has_feature = pcall(feature_check)
        if not ok or not has_feature then
            setup_fn()
        end
    end

    -- Setup compatibility for vim.validate
    ensure_feature(
        function() return vim._validate ~= nil end,
        function()
            if vim.validate and not vim._validate then
                vim._validate = vim.validate
            end
        end
    )

    -- Setup string function compatibility
    ensure_feature(
        function() return vim.str_utfindex ~= nil end,
        function()
            vim.str_utfindex = function(line, col)
                return vim.fn.byteidx(line, col)
            end
        end
    )

    -- Ensure vim.tbl exists
    if not vim.tbl then
        vim.tbl = {}
    end

    -- Ensure modern table functions exist
    local function ensure_tbl_function(name, fn)
        if not vim.tbl[name] then
            vim.tbl[name] = fn
        end
    end

    -- Add missing table functions
    ensure_tbl_function("map", function(t, f)
        local ret = {}
        for k, v in pairs(t) do
            ret[k] = f(v)
        end
        return ret
    end)

    ensure_tbl_function("filter", function(t, f)
        local ret = {}
        for k, v in pairs(t) do
            if f(v) then
                ret[k] = v
            end
        end
        return ret
    end)

    ensure_tbl_function("deep_extend", function(behavior, ...)
        local result = {}
        local args = { ... }

        for _, t in ipairs(args) do
            for k, v in pairs(t) do
                if type(v) == "table" and type(result[k]) == "table" then
                    result[k] = M.deep_extend(behavior, result[k], v)
                else
                    result[k] = v
                end
            end
        end

        return result
    end)

    -- Create modern defaults if not present
    ensure_feature(
        function() return vim.defaults ~= nil end,
        function()
            vim.defaults = {
                fillchars = {
                    fold = " ",
                    foldopen = "",
                    foldclose = "",
                    foldsep = " ",
                    diff = "╱",
                    eob = " ",
                },
            }
        end
    )

    -- Add safe require to global scope
    _G.safe_require = function(module)
        local ok, result = pcall(require, module)
        if not ok then
            vim.notify(string.format("Error loading module '%s': %s", module, result), vim.log.levels.WARN)
            return nil
        end
        return result
    end

    -- Set up better global error handling
    vim.schedule(function()
        local group = vim.api.nvim_create_augroup("error_handling", { clear = true })
        vim.api.nvim_create_autocmd("LspAttach", {
            group = group,
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then
                    return
                end

                if client.server_capabilities.documentHighlightProvider then
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = args.buf,
                        group = group,
                        callback = function()
                            pcall(vim.lsp.buf.document_highlight)
                        end,
                    })
                    vim.api.nvim_create_autocmd("CursorMoved", {
                        buffer = args.buf,
                        group = group,
                        callback = function()
                            pcall(vim.lsp.buf.clear_references)
                        end,
                    })
                end
            end,
        })
    end)

    -- Ensure proper handling of large files
    vim.api.nvim_create_autocmd("BufReadPre", {
        callback = function(ev)
            local ok, stats = pcall(vim.loop.fs_stat, ev.match)
            -- Check if file exists and is larger than 1MB
            if ok and stats and stats.size > 1024 * 1024 then
                -- Disable potentially expensive features
                vim.opt_local.foldmethod = "manual"
                vim.opt_local.foldenable = false
                vim.opt_local.swapfile = false
                vim.opt_local.undolevels = -1
                vim.opt_local.undoreload = 0
                vim.opt_local.list = false
                vim.opt_local.syntax = ""
            end
        end,
    })

    -- Set up better command handling
    vim.api.nvim_create_user_command("ReloadConfig", function()
        for name, _ in pairs(package.loaded) do
            if name:match("^core%.") or name:match("^plugins%.") or name:match("^langs%.") then
                package.loaded[name] = nil
            end
        end
        dofile(vim.env.MYVIMRC)
        vim.notify("Neovim config reloaded!", vim.log.levels.INFO)
    end, {})
end

return M
