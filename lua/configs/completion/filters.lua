-- Helper heuristics and entry filter for nvim-cmp
local M = {}

local api = vim.api
-- fn not used here; kept via vim.fn when needed directly

local function is_jsx_attribute_context()
    local line = api.nvim_get_current_line()
    local col = api.nvim_win_get_cursor(0)[2]
    local before = line:sub(1, col)
    if before:match("=%s*$") then return true end
    if before:match("=%s*['\"%{]%s*$") then return true end
    if before:match("className?%s*=%s*['\"%{]") then return true end
    return false
end

local function in_class_attr()
    local line = api.nvim_get_current_line()
    local col = api.nvim_win_get_cursor(0)[2]
    local before = line:sub(1, col)
    return before:match("className?%s*=%s*['\"%{") ~= nil
end

local function is_inside_jsx_quotes()
    local line = api.nvim_get_current_line()
    local col = api.nvim_win_get_cursor(0)[2]
    local before = line:sub(1, col)
    local single = select(2, before:gsub("'", ""))
    local double = select(2, before:gsub('"', '"'))
    return (single % 2 == 1) or (double % 2 == 1)
end

local function in_jsx_tag_declaration_body()
    local line = api.nvim_get_current_line()
    local col = api.nvim_win_get_cursor(0)[2]
    local before = line:sub(1, col)
    local lt_pos = before:match("()<[^!/][%w:_%.%-]*")
    if not lt_pos then return false end
    local segment = before:sub(lt_pos)
    if segment:find(">%s*$") then return false end
    return segment:match("^<[^%s>]+[%s{]") ~= nil and not segment:match("^<[^%s>]+$")
end

-- allow element snippets where it's safe (based on heuristics)
local function allow_element_snippets_here()
    local bufnr = api.nvim_get_current_buf()
    local row, col = unpack(api.nvim_win_get_cursor(0))
    local line = api.nvim_get_current_line()
    local before = line:sub(1, col)

    if is_inside_jsx_quotes() or is_jsx_attribute_context() or in_jsx_tag_declaration_body() then
        return false
    end

    local before_trim = before:match("^%s*(.-)$") or before
    if not before_trim:match("^<[%w]") then
        return false
    end

    local prev_nonempty = ""
    for i = row - 1, math.max(1, row - 3), -1 do
        local l = api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1] or ""
        if l:match("%S") then
            prev_nonempty = l
            break
        end
    end

    if before:match("return%s*<") then return true end
    if prev_nonempty:match("return%s*%(?%s*$") then return true end
    if before:match("=%s*<") then return true end
    if before:match("=>%s*<") then return true end

    return false
end

local function stack_filter(entry)
    local filetype = vim.bo.filetype
    local kind = entry.completion_item.kind
    local label = entry.completion_item.label or ""

    if filetype == "typescriptreact" or filetype == "javascriptreact" then
        local is_snippet = (entry.source and entry.source.name == "luasnip") or (kind == 15)
        local insert_text = entry.completion_item and entry.completion_item.insertText
        local looks_like_tag = label:match("^<") or (type(insert_text) == "string" and insert_text:match("^<"))

        if is_snippet and looks_like_tag then
            if is_jsx_attribute_context() or is_inside_jsx_quotes() or in_jsx_tag_declaration_body() then
                return false
            end
            if not allow_element_snippets_here() then
                return false
            end
        end

        if entry.source and entry.source.name == "nvim_lsp" and looks_like_tag then
            if is_jsx_attribute_context() or is_inside_jsx_quotes() or in_jsx_tag_declaration_body() then
                return false
            end
            if not allow_element_snippets_here() then
                return false
            end
        end

        if entry.source and entry.source.name == "nvim_lsp" and label:match("^[A-Z]") then
            entry.score = (entry.score or 0) + 100
        end

        if in_class_attr() and label:match("^[%w%-:/%[%].]+$") then
            entry.score = (entry.score or 0) + 50
        end
        
        -- Reduce priority of text completions in JSX/TSX files
        if entry.source and entry.source.name == "nvim_lsp" and kind == 1 then
            entry.score = (entry.score or 0) - 50
        end
    end

    if filetype == "sql" or filetype == "prisma" then
        if entry.source.name == "nvim_lsp" and (label:match("Table") or label:match("Model")) then
            entry.score = (entry.score or 0) + 50
        end
    end

    if filetype == "rust" then
        if kind == 5 and label:match("&") then
            return false
        end
    end

    return true
end

M.stack_filter = stack_filter
M.allow_element_snippets_here = allow_element_snippets_here
M.is_jsx_attribute_context = is_jsx_attribute_context

return M