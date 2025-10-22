-- Linting configuration
local lint = require("lint")

lint.linters_by_ft = {
    lua = { "luacheck" },
    python = { "ruff" },
    java = { "checkstyle" },
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    html = { "htmlhint" },
    css = { "stylelint" },
    scss = { "stylelint" },
    asm = { "nasm" },
    nasm = { "nasm" },
    gas = { "gas" },
    cpp = { "clangtidy", "cppcheck" },
    c = { "clangtidy", "cppcheck" },
    qml = { "qmllint" },
    rust = { "clippy" },
    zig = { "zls" },
    go = { "golangcilint" },
    cs = { "dotnet_build" },
    -- Add more
}

-- Define NASM linter
lint.linters.nasm = {
    cmd = "nasm",
    args = { "-X", "gnu", "-f", "elf64", "-o", "/dev/null", "-" },
    stdin = true,
    stream = "stderr",
    parser = function(output, bufnr)
        local diagnostics = {}
        for _, line in ipairs(vim.split(output, "\n")) do
            local parts = vim.split(line, ":")
            if #parts >= 3 then
                local ln = tonumber(parts[2])
                if ln then
                    table.insert(diagnostics, {
                        bufnr = bufnr,
                        lnum = ln - 1,
                        col = 0,
                        severity = vim.diagnostic.severity.ERROR,
                        message = table.concat({ unpack(parts, 3) }, ":"),
                        source = "nasm",
                    })
                end
            end
        end
        return diagnostics
    end,
}

-- Define GAS linter
lint.linters.gas = {
    cmd = "as",
    args = { "--fatal-warnings", "-o", "/dev/null", "-" },
    stdin = true,
    stream = "stderr",
    parser = function(output, bufnr)
        local diagnostics = {}
        for _, line in ipairs(vim.split(output, "\n")) do
            local pattern = "stdin:(%d+):(.*)"
            local ln, msg = string.match(line, pattern)
            if ln and msg then
                table.insert(diagnostics, {
                    bufnr = bufnr,
                    lnum = tonumber(ln) - 1,
                    col = 0,
                    severity = vim.diagnostic.severity.ERROR,
                    message = msg,
                    source = "gas",
                })
            end
        end
        return diagnostics
    end,
}

-- Define Clang-Tidy linter
lint.linters.clangtidy = {
    cmd = "clang-tidy",
    args = { "--quiet", "-" },
    stdin = true,
    stream = "stderr",
    parser = function(output, bufnr)
        local diagnostics = {}
        for _, line in ipairs(vim.split(output, "\n")) do
            -- Pattern for clang-tidy errors/warnings
            local pattern = "stdin:(%d+):(%d+): (%a+): (.+)"
            local ln, col, severity, msg = string.match(line, pattern)
            if ln and col and severity and msg then
                local severity_level = vim.diagnostic.severity.WARN
                if severity == "error" then
                    severity_level = vim.diagnostic.severity.ERROR
                end
                
                table.insert(diagnostics, {
                    bufnr = bufnr,
                    lnum = tonumber(ln) - 1,
                    col = tonumber(col) - 1,
                    severity = severity_level,
                    message = msg,
                    source = "clang-tidy",
                })
            end
        end
        return diagnostics
    end,
}

-- Define Cppcheck linter
lint.linters.cppcheck = {
    cmd = "cppcheck",
    args = { "--enable=all", "--inconclusive", "--xml", "--xml-version=2", "--suppress=unmatchedSuppression:*", "-" },
    stdin = true,
    stream = "stderr",
    parser = function(output, bufnr)
        local diagnostics = {}
        -- Parse XML output from cppcheck
        -- This is a simplified parser - a full XML parser would be better
        for _, line in ipairs(vim.split(output, "\n")) do
            -- Pattern for cppcheck errors
            local pattern = '<%a+ filename="stdin" line="(%d+)" id="[^"]+" severity="(%a+)" msg="([^"]+)"'
            local ln, severity, msg = string.match(line, pattern)
            if ln and severity and msg then
                local severity_level = vim.diagnostic.severity.WARN
                if severity == "error" then
                    severity_level = vim.diagnostic.severity.ERROR
                end
                
                table.insert(diagnostics, {
                    bufnr = bufnr,
                    lnum = tonumber(ln) - 1,
                    col = 0,
                    severity = severity_level,
                    message = msg,
                    source = "cppcheck",
                })
            end
        end
        return diagnostics
    end,
}

-- Define QML linter
lint.linters.qmllint = {
    cmd = "qmllint",
    args = { "-" },
    stdin = true,
    stream = "stderr",
    parser = function(output, bufnr)
        local diagnostics = {}
        for _, line in ipairs(vim.split(output, "\n")) do
            -- Pattern for qmllint errors
            local pattern = "stdin:(%d+):(%d+): (.+)"
            local ln, col, msg = string.match(line, pattern)
            if ln and col and msg then
                table.insert(diagnostics, {
                    bufnr = bufnr,
                    lnum = tonumber(ln) - 1,
                    col = tonumber(col) - 1,
                    severity = vim.diagnostic.severity.ERROR,
                    message = msg,
                    source = "qmllint",
                })
            end
        end
        return diagnostics
    end,
}

-- Define Clippy linter
lint.linters.clippy = {
    cmd = "cargo",
    args = { "clippy", "--message-format=json" },
    stdin = false,
    stream = "stdout",
    parser = function(output, bufnr)
        local diagnostics = {}
        for _, line in ipairs(vim.split(output, "\n")) do
            if line ~= "" then
                local ok, parsed = pcall(vim.json.decode, line)
                if ok and parsed.reason == "compiler-message" then
                    local message = parsed.message
                    local spans = message.spans
                    if spans and #spans > 0 then
                        local span = spans[1]
                        local severity = vim.diagnostic.severity.HINT
                        if message.level == "warning" then
                            severity = vim.diagnostic.severity.WARN
                        elseif message.level == "error" or message.level == "hard_error" then
                            severity = vim.diagnostic.severity.ERROR
                        end
                        
                        table.insert(diagnostics, {
                            bufnr = bufnr,
                            lnum = span.line_start - 1,
                            col = span.column_start - 1,
                            end_lnum = span.line_end - 1,
                            end_col = span.column_end - 1,
                            severity = severity,
                            message = message.message,
                            source = "clippy",
                        })
                    end
                end
            end
        end
        return diagnostics
    end,
}

-- Define ZLS linter (using zls diagnostics)
lint.linters.zls = {
    cmd = "zls",
    args = { "--enable-build-on-save" },
    stdin = false,
    stream = "stderr",
    parser = function(output, bufnr)
        local diagnostics = {}
        for _, line in ipairs(vim.split(output, "\n")) do
            -- Parse ZLS diagnostic format
            local pattern = "([^:]+):(\\d+):(\\d+): (%a+): (.+)"
            local file, ln, col, severity, msg = string.match(line, pattern)
            if ln and col and severity and msg then
                local severity_level = vim.diagnostic.severity.WARN
                if severity == "error" then
                    severity_level = vim.diagnostic.severity.ERROR
                elseif severity == "hint" then
                    severity_level = vim.diagnostic.severity.HINT
                end
                
                table.insert(diagnostics, {
                    bufnr = bufnr,
                    lnum = tonumber(ln) - 1,
                    col = tonumber(col) - 1,
                    severity = severity_level,
                    message = msg,
                    source = "zls",
                })
            end
        end
        return diagnostics
    end,
}

-- Define golangci-lint linter
lint.linters.golangcilint = {
    cmd = "golangci-lint",
    args = { "run", "--out-format", "checkstyle" },
    stdin = false,
    stream = "stdout",
    parser = function(output, bufnr)
        local diagnostics = {}
        -- Parse checkstyle XML output from golangci-lint
        for line in vim.gsplit(output, "\n") do
            -- Pattern for checkstyle errors
            local file, ln, col, severity, msg = string.match(line, '<error line="(%d+)" column="(%d+)" severity="(%a+)" message="([^"]+)"')
            if ln and col and severity and msg then
                local severity_level = vim.diagnostic.severity.WARN
                if severity == "error" then
                    severity_level = vim.diagnostic.severity.ERROR
                end
                
                table.insert(diagnostics, {
                    bufnr = bufnr,
                    lnum = tonumber(ln) - 1,
                    col = tonumber(col) - 1,
                    severity = severity_level,
                    message = msg,
                    source = "golangci-lint",
                })
            end
        end
        return diagnostics
    end,
}

-- Define dotnet build linter
lint.linters.dotnet_build = {
    cmd = "dotnet",
    args = { "build", "--no-restore", "--no-dependencies" },
    stdin = false,
    stream = "stderr",
    parser = function(output, bufnr)
        local diagnostics = {}
        -- Parse MSBuild output format
        for _, line in ipairs(vim.split(output, "\n")) do
            -- Pattern for MSBuild errors/warnings
            local pattern = "([^:]+):(%a+)%s+([^:]+):%s+(.+)%s+%[(.+)%]"
            local file, severity, code, msg, project = string.match(line, pattern)
            
            if file and severity and code and msg then
                -- Extract line and column info from file path if available
                local line_col_pattern = "(.+)%((%d+),(%d+)%)"
                local path, ln, col = string.match(file, line_col_pattern)
                
                if path and ln and col then
                    local severity_level = vim.diagnostic.severity.WARN
                    if severity:lower() == "error" then
                        severity_level = vim.diagnostic.severity.ERROR
                    end
                    
                    table.insert(diagnostics, {
                        bufnr = bufnr,
                        lnum = tonumber(ln) - 1,
                        col = tonumber(col) - 1,
                        severity = severity_level,
                        message = "[" .. code .. "] " .. msg,
                        source = "dotnet-build",
                    })
                end
            end
        end
        return diagnostics
    end,
}

-- Define Checkstyle linter for Java
lint.linters.checkstyle = {
    cmd = "checkstyle",
    args = { "-f", "checkstyle", "-" },
    stdin = true,
    stream = "stdout",
    parser = function(output, bufnr)
        local diagnostics = {}
        -- Parse Checkstyle XML output
        for line in vim.gsplit(output, "\n") do
            -- Pattern for Checkstyle errors
            local file, ln, col, severity, msg = string.match(line, '<error line="(%d+)" column="(%d+)" severity="(%a+)" message="([^"]+)"')
            if ln and col and severity and msg then
                local severity_level = vim.diagnostic.severity.WARN
                if severity == "error" then
                    severity_level = vim.diagnostic.severity.ERROR
                end
                
                table.insert(diagnostics, {
                    bufnr = bufnr,
                    lnum = tonumber(ln) - 1,
                    col = tonumber(col) - 1,
                    severity = severity_level,
                    message = msg,
                    source = "checkstyle",
                })
            end
        end
        return diagnostics
    end,
}

-- Define Ruff linter for Python
lint.linters.ruff = {
    cmd = "ruff",
    args = { "check", "--output-format", "checkstyle", "-" },
    stdin = true,
    stream = "stdout",
    parser = function(output, bufnr)
        local diagnostics = {}
        -- Parse checkstyle XML output from ruff
        for line in vim.gsplit(output, "\n") do
            -- Pattern for checkstyle errors
            local file, ln, col, severity, msg = string.match(line, '<error line="(%d+)" column="(%d+)" severity="(%a+)" message="([^"]+)"')
            if ln and col and severity and msg then
                local severity_level = vim.diagnostic.severity.WARN
                if severity == "error" then
                    severity_level = vim.diagnostic.severity.ERROR
                end
                
                table.insert(diagnostics, {
                    bufnr = bufnr,
                    lnum = tonumber(ln) - 1,
                    col = tonumber(col) - 1,
                    severity = severity_level,
                    message = msg,
                    source = "ruff",
                })
            end
        end
        return diagnostics
    end,
}

-- Define Luacheck linter for Lua
lint.linters.luacheck = {
    cmd = "luacheck",
    args = { "--formatter", "checkstyle", "--codes", "--ranges", "--filename", "stdin", "-" },
    stdin = true,
    stream = "stdout",
    parser = function(output, bufnr)
        local diagnostics = {}
        -- Parse checkstyle XML output from luacheck
        for line in vim.gsplit(output, "\n") do
            -- Pattern for checkstyle errors
            local file, ln, col, end_col, severity, code, msg = string.match(line, '<error line="(%d+)" column="(%d+)" end_column="(%d+)" severity="(%a+)" code="(%a+)" message="([^"]+)"')
            if ln and col and severity and msg then
                local severity_level = vim.diagnostic.severity.WARN
                if severity == "error" then
                    severity_level = vim.diagnostic.severity.ERROR
                end
                
                table.insert(diagnostics, {
                    bufnr = bufnr,
                    lnum = tonumber(ln) - 1,
                    col = tonumber(col) - 1,
                    end_col = tonumber(end_col),
                    severity = severity_level,
                    message = "[" .. code .. "] " .. msg,
                    source = "luacheck",
                })
            end
        end
        return diagnostics
    end,
}

-- Define HTMLHint linter for HTML
lint.linters.htmlhint = {
    cmd = "htmlhint",
    args = { "--format", "checkstyle", "--stdin-filename", "%filepath" },
    stdin = true,
    stream = "stdout",
    parser = function(output, bufnr)
        local diagnostics = {}
        -- Parse checkstyle XML output from htmlhint
        for line in vim.gsplit(output, "\n") do
            -- Pattern for checkstyle errors
            local file, ln, col, severity, msg = string.match(line, '<error line="(%d+)" column="(%d+)" severity="(%a+)" message="([^"]+)"')
            if ln and col and severity and msg then
                local severity_level = vim.diagnostic.severity.WARN
                if severity == "error" then
                    severity_level = vim.diagnostic.severity.ERROR
                end
                
                table.insert(diagnostics, {
                    bufnr = bufnr,
                    lnum = tonumber(ln) - 1,
                    col = tonumber(col) - 1,
                    severity = severity_level,
                    message = msg,
                    source = "htmlhint",
                })
            end
        end
        return diagnostics
    end,
}

-- Define Stylelint linter for CSS/SCSS
lint.linters.stylelint = {
    cmd = "stylelint",
    args = { "--formatter", "json", "--stdin-filename", "%filepath" },
    stdin = true,
    stream = "stdout",
    parser = function(output, bufnr)
        local diagnostics = {}
        local ok, parsed = pcall(vim.json.decode, output)
        if ok and type(parsed) == "table" then
            for _, warning in ipairs(parsed) do
                if warning.warnings then
                    for _, w in ipairs(warning.warnings) do
                        local severity = vim.diagnostic.severity.WARN
                        if w.severity == "error" then
                            severity = vim.diagnostic.severity.ERROR
                        end
                        
                        table.insert(diagnostics, {
                            bufnr = bufnr,
                            lnum = w.line - 1,
                            col = w.column - 1,
                            severity = severity,
                            message = w.text,
                            source = "stylelint",
                        })
                    end
                end
            end
        end
        return diagnostics
    end,
}

return {}