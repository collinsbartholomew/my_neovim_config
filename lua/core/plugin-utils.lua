-- Utility function to flatten plugin specs
local function flatten(spec)
    local result = {}

    local function recurse(item)
        if type(item) == "table" then
            -- If it's a plugin spec (has a name or path), add it directly
            if item[1] or item.dir or item.name then
                table.insert(result, item)
            else
                -- Otherwise, recurse through the table
                for _, v in pairs(item) do
                    recurse(v)
                end
            end
        end
    end

    recurse(spec)
    return result
end

return function(plugin_specs)
    local plugins = {}

    -- Flatten each plugin specification
    for _, spec in ipairs(plugin_specs) do
        if spec then
            local flattened = flatten(spec)
            for _, plugin in ipairs(flattened) do
                table.insert(plugins, plugin)
            end
        end
    end

    return plugins
end
