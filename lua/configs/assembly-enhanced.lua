-- Enhanced Assembly Development Configuration
-- Improvements for professional assembly development

-- Cross-platform assembler detection
local function detect_assemblers()
    local assemblers = {}
    local tools = {
        nasm = "nasm",
        gas = "as", 
        masm = "ml64",
        yasm = "yasm",
        fasm = "fasm"
    }
    
    for name, cmd in pairs(tools) do
        if vim.fn.executable(cmd) == 1 then
            assemblers[name] = cmd
        end
    end
    return assemblers
end

-- Architecture detection
local function get_arch()
    local uname = vim.fn.system("uname -m"):gsub("\n", "")
    if uname:match("x86_64") or uname:match("amd64") then
        return "x64"
    elseif uname:match("i[3-6]86") then
        return "x86"
    elseif uname:match("arm") or uname:match("aarch64") then
        return "arm"
    end
    return "x64" -- default
end

-- Enhanced register completion
local function setup_asm_completion()
    local registers = {
        x64 = {"rax", "rbx", "rcx", "rdx", "rsi", "rdi", "rbp", "rsp", "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15"},
        x86 = {"eax", "ebx", "ecx", "edx", "esi", "edi", "ebp", "esp"},
        arm = {"r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", "r8", "r9", "r10", "r11", "r12", "sp", "lr", "pc"}
    }
    
    local instructions = {
        "mov", "add", "sub", "mul", "div", "cmp", "jmp", "call", "ret", "push", "pop",
        "and", "or", "xor", "not", "shl", "shr", "test", "lea", "nop", "int", "syscall"
    }
    
    -- Set up completion source
    vim.api.nvim_create_autocmd("FileType", {
        pattern = {"asm", "nasm", "gas"},
        callback = function()
            local arch = get_arch()
            local completions = vim.tbl_extend("force", registers[arch] or registers.x64, instructions)
            vim.b.asm_completions = completions
        end
    })
end

-- Debugger integration improvements
local function setup_debugger_integration()
    vim.api.nvim_create_user_command("AsmGDB", function()
        local name = vim.fn.expand("%:r")
        if vim.fn.executable("gdb") == 1 then
            -- Create GDB init file for assembly debugging
            local gdb_init = {
                "set disassembly-flavor intel",
                "layout asm",
                "layout regs",
                "break _start"
            }
            vim.fn.writefile(gdb_init, ".gdbinit_asm")
            vim.cmd("!gdb -x .gdbinit_asm " .. name)
        end
    end, {})
    
    -- LLDB support for macOS
    vim.api.nvim_create_user_command("AsmLLDB", function()
        local name = vim.fn.expand("%:r")
        if vim.fn.executable("lldb") == 1 then
            vim.cmd("!lldb " .. name)
        end
    end, {})
end

-- Performance profiling integration
local function setup_profiling()
    vim.api.nvim_create_user_command("AsmProfile", function()
        local name = vim.fn.expand("%:r")
        if vim.fn.executable("perf") == 1 then
            vim.cmd("!perf record -g ./" .. name .. " && perf report")
        elseif vim.fn.executable("valgrind") == 1 then
            vim.cmd("!valgrind --tool=callgrind ./" .. name)
        end
    end, {})
end

-- Assembly documentation and reference
local function setup_documentation()
    local doc_sources = {
        intel = "https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html",
        amd = "https://developer.amd.com/resources/developer-guides-manuals/",
        arm = "https://developer.arm.com/documentation/"
    }
    
    vim.api.nvim_create_user_command("AsmRef", function(opts)
        local instruction = opts.args ~= "" and opts.args or vim.fn.expand("<cword>")
        -- Try multiple documentation sources
        local commands = {
            "man " .. instruction,
            "info " .. instruction,
            "curl -s 'https://www.felixcloutier.com/x86/" .. instruction .. "' | grep -A 5 'Description'"
        }
        
        for _, cmd in ipairs(commands) do
            local result = vim.fn.system(cmd)
            if vim.v.shell_error == 0 and result ~= "" then
                vim.cmd("new | put ='" .. result:gsub("'", "''") .. "'")
                return
            end
        end
        vim.notify("No documentation found for: " .. instruction, vim.log.levels.WARN)
    end, { nargs = "?" })
end

-- Enhanced build system with multiple targets
local function setup_enhanced_build()
    vim.api.nvim_create_user_command("AsmBuildAll", function()
        local file = vim.fn.expand("%")
        local name = vim.fn.expand("%:r")
        local assemblers = detect_assemblers()
        
        for asm_name, asm_cmd in pairs(assemblers) do
            local output = name .. "_" .. asm_name
            if asm_name == "nasm" then
                vim.cmd("!" .. asm_cmd .. " -f elf64 " .. file .. " -o " .. output .. ".o && ld " .. output .. ".o -o " .. output)
            elseif asm_name == "gas" then
                vim.cmd("!" .. asm_cmd .. " --64 " .. file .. " -o " .. output .. ".o && ld " .. output .. ".o -o " .. output)
            end
        end
    end, {})
end

-- Assembly project structure
local function create_asm_project()
    local project_structure = {
        "src/",
        "include/",
        "build/",
        "docs/",
        "tests/"
    }
    
    for _, dir in ipairs(project_structure) do
        vim.fn.mkdir(dir, "p")
    end
    
    -- Create Makefile
    local makefile_content = {
        "ASM = nasm",
        "ASMFLAGS = -f elf64",
        "LD = ld",
        "SRCDIR = src",
        "BUILDDIR = build",
        "",
        "SOURCES = $(wildcard $(SRCDIR)/*.asm)",
        "OBJECTS = $(SOURCES:$(SRCDIR)/%.asm=$(BUILDDIR)/%.o)",
        "TARGET = $(BUILDDIR)/program",
        "",
        "all: $(TARGET)",
        "",
        "$(TARGET): $(OBJECTS)",
        "\t$(LD) $^ -o $@",
        "",
        "$(BUILDDIR)/%.o: $(SRCDIR)/%.asm",
        "\t@mkdir -p $(BUILDDIR)",
        "\t$(ASM) $(ASMFLAGS) $< -o $@",
        "",
        "clean:",
        "\trm -rf $(BUILDDIR)",
        "",
        ".PHONY: all clean"
    }
    
    vim.fn.writefile(makefile_content, "Makefile")
    vim.notify("Assembly project structure created", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("AsmProject", create_asm_project, {})

-- Initialize all enhancements
setup_asm_completion()
setup_debugger_integration()
setup_profiling()
setup_documentation()
setup_enhanced_build()

return {
    detect_assemblers = detect_assemblers,
    get_arch = get_arch,
    create_asm_project = create_asm_project
}