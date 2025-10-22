---
-- Custom assembly formatter
local M = {}

-- Simple formatter for assembly code
-- Aligns instructions and comments
function M.format_asm(lines, opts)
    local formatted = {}
    local max_label_width = 0
    local max_instruction_width = 0
    
    -- First pass: find maximum widths
    for _, line in ipairs(lines) do
        -- Skip empty lines and comments
        if line:match("^%s*$") or line:match("^%s*;") then
            goto continue
        end
        
        -- Extract label, instruction and operands
        local label = line:match("^%s*([%w_]+):")
        if label and #label > max_label_width then
            max_label_width = #label
        end
        
        local instruction = line:match("^%s*([%w_]+)")
        if instruction and #instruction > max_instruction_width then
            max_instruction_width = #instruction
        end
        
        ::continue::
    end
    
    -- Second pass: format lines
    for _, line in ipairs(lines) do
        -- Handle empty lines
        if line:match("^%s*$") then
            table.insert(formatted, "")
            goto continue
        end
        
        -- Handle comments
        if line:match("^%s*;") then
            table.insert(formatted, line)
            goto continue
        end
        
        -- Handle labels
        local label = line:match("^%s*([%w_]+):")
        if label then
            local rest = line:match("^%s*[%w_]+:%s*(.*)")
            if rest and rest ~= "" then
                -- Label with instruction on same line
                local formatted_line = string.format("%s:%s%s", 
                    label, 
                    string.rep(" ", max_label_width - #label + 2), 
                    rest)
                table.insert(formatted, formatted_line)
            else
                -- Label only
                table.insert(formatted, label .. ":")
            end
            goto continue
        end
        
        -- Handle instructions
        local instruction = line:match("^%s*([%w_]+)")
        if instruction then
            local operands = line:match("^%s*[%w_]+%s+(.*)")
            local comment = ""
            
            -- Extract comment if present
            if operands then
                local comment_start = operands:find(";")
                if comment_start then
                    comment = operands:sub(comment_start)
                    operands = operands:sub(1, comment_start - 2)
                end
            end
            
            local formatted_line = string.format("%s%s%s", 
                string.rep(" ", max_label_width + 2),
                instruction,
                operands and (" " .. operands) or "")
            
            -- Add comment if present
            if comment ~= "" then
                formatted_line = formatted_line .. string.rep(" ", 40 - #formatted_line) .. comment
            end
            
            table.insert(formatted, formatted_line)
        else
            table.insert(formatted, line)
        end
        
        ::continue::
    end
    
    return formatted
end

return M