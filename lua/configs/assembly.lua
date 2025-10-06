-- Modern Assembly Language Configuration

-- Enhanced assembly file detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.asm", "*.s", "*.S", "*.nasm", "*.masm", "*.gas", "*.inc" },
	callback = function()
		local filename = vim.fn.expand("%:t")

		-- Set appropriate filetype based on extension
		if filename:match("%.nasm$") or filename:match("%.inc$") then
			vim.bo.filetype = "nasm"
		elseif filename:match("%.gas$") or filename:match("%.[sS]$") then
			vim.bo.filetype = "gas"
		else
			vim.bo.filetype = "asm"
		end

		-- Assembly-specific settings
		vim.bo.commentstring = "; %s"
		vim.bo.tabstop = 4 -- Changed to 4 for consistency
		vim.bo.shiftwidth = 4
		vim.bo.expandtab = false
		vim.bo.autoindent = true
		vim.bo.smartindent = false

		-- Visual settings
		vim.opt_local.number = true
		vim.opt_local.relativenumber = true
		vim.opt_local.wrap = false
		vim.opt_local.colorcolumn = "80"
		vim.opt_local.textwidth = 80
		vim.opt_local.cursorline = true
	end,
})

-- Enhanced assembly keymaps with error handling
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "asm", "nasm", "gas" },
	callback = function()
		local opts = { buffer = true, silent = true }

		-- Smart build commands based on filetype
		local function get_assembler()
			local ft = vim.bo.filetype
			if ft == "nasm" then
				return "nasm -f elf64"
			end
			if ft == "gas" then
				return "as --64"
			end
			return "nasm -f elf64" -- default
		end

		-- Build and run commands with error handling
		vim.keymap.set("n", "<F5>", function()
			local asm = get_assembler()
			local file = vim.fn.expand("%")
			local name = vim.fn.expand("%:r")
			vim.cmd("!" .. asm .. " " .. file .. " -o " .. name .. ".o && ld " .. name .. ".o -o " .. name)
		end, opts)

		vim.keymap.set("n", "<F6>", function()
			local name = vim.fn.expand("%:r")
			if vim.fn.executable(name) == 1 then
				vim.cmd("!" .. name)
			else
				vim.notify("Executable not found: " .. name, vim.log.levels.ERROR)
			end
		end, opts)

		vim.keymap.set("n", "<F7>", function()
			local name = vim.fn.expand("%:r")
			if vim.fn.executable("gdb") == 1 then
				vim.cmd("!gdb " .. name)
			else
				vim.notify("GDB not installed", vim.log.levels.ERROR)
			end
		end, opts)

		vim.keymap.set("n", "<F8>", function()
			local name = vim.fn.expand("%:r")
			if vim.fn.executable("objdump") == 1 then
				vim.cmd("!objdump -d " .. name)
			else
				vim.notify("objdump not available", vim.log.levels.ERROR)
			end
		end, opts)

		-- Assembly-specific shortcuts with validation
		vim.keymap.set("n", "<leader>ab", function()
			local asm = get_assembler()
			local file = vim.fn.expand("%")
			vim.cmd("!" .. asm .. " " .. file)
		end, opts)

		vim.keymap.set("n", "<leader>al", "<cmd>!ld %:r.o -o %:r<cr>", opts)
		vim.keymap.set("n", "<leader>ar", "<cmd>!./%:r<cr>", opts)
		vim.keymap.set("n", "<leader>ad", "<cmd>!gdb %:r<cr>", opts)
		vim.keymap.set(
			"n",
			"<leader>ao",
			'<cmd>!objdump -d %:r > %:r.dump && echo "Disassembly saved to %:r.dump"<cr>',
			opts
		)
		vim.keymap.set("n", "<leader>ah", "<cmd>!hexdump -C %:r | head -20<cr>", opts)
	end,
})

-- Enhanced assembly syntax highlighting
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "asm", "nasm", "gas" },
	callback = function()
		-- Modern x86-64 syntax highlighting
		vim.cmd([[
      " Registers (x86-64)
      syntax match asmRegister /\v<[re]?[abcd][xlh]>/
      syntax match asmRegister /\v<[re]?[sd]i[lx]?>/
      syntax match asmRegister /\v<[re]?[sb]p[lx]?>/
      syntax match asmRegister /\v<r[89][dwb]?>/
      syntax match asmRegister /\v<r1[0-5][dwb]?>/
      syntax match asmRegister /\v<[xyz]mm[0-9]+>/

      " Instructions (comprehensive set)
      syntax match asmInstruction /\v<(mov|movq|movl|movw|movb)>/
      syntax match asmInstruction /\v<(add|sub|mul|div|imul|idiv)>/
      syntax match asmInstruction /\v<(cmp|test|and|or|xor|not|neg)>/
      syntax match asmInstruction /\v<(shl|shr|sal|sar|rol|ror)>/
      syntax match asmInstruction /\v<(jmp|je|jne|jz|jnz|jl|jle|jg|jge|ja|jae|jb|jbe)>/
      syntax match asmInstruction /\v<(call|ret|push|pop|lea|nop)>/
      syntax match asmInstruction /\v<(int|syscall|sysenter|sysexit)>/
      syntax match asmInstruction /\v<(enter|leave|pusha|popa)>/

      " Directives
      syntax match asmDirective /\v<\.(section|global|extern|data|text|bss|rodata)>/
      syntax match asmDirective /\v<\.(byte|word|dword|qword|ascii|asciz)>/
      syntax match asmDirective /\v<(db|dw|dd|dq|resb|resw|resd|resq)>/

      " Numbers and addresses
      syntax match asmNumber /\v<0x[0-9a-fA-F]+>/
      syntax match asmNumber /\v<[0-9]+[bB]?>/
      syntax match asmNumber /\v<\$[0-9a-fA-F]+>/

      " Labels
      syntax match asmLabel /\v^[a-zA-Z_][a-zA-Z0-9_]*:/

      " Comments
      syntax match asmComment /\v;.*$/

      " Highlighting
      highlight link asmRegister Special
      highlight link asmInstruction Keyword
      highlight link asmDirective PreProc
      highlight link asmNumber Number
      highlight link asmLabel Function
      highlight link asmComment Comment
    ]])
	end,
})

-- Assembly project templates
local function create_asm_template(template_type)
	local templates = {
		hello_world = {
			"section .data",
			"    msg db 'Hello, World!', 0xA",
			"    msg_len equ $ - msg",
			"",
			"section .text",
			"    global _start",
			"",
			"_start:",
			"    ; write system call",
			"    mov rax, 1      ; sys_write",
			"    mov rdi, 1      ; stdout",
			"    mov rsi, msg    ; message",
			"    mov rdx, msg_len ; length",
			"    syscall",
			"",
			"    ; exit system call",
			"    mov rax, 60     ; sys_exit",
			"    mov rdi, 0      ; exit status",
			"    syscall",
		},
		function_template = {
			"section .text",
			"    global _start",
			"",
			"_start:",
			"    ; Your code here",
			"    call my_function",
			"",
			"    ; exit",
			"    mov rax, 60",
			"    mov rdi, 0",
			"    syscall",
			"",
			"my_function:",
			"    ; Function implementation",
			"    ret",
		},
	}

	local lines = templates[template_type] or templates.hello_world
	vim.api.nvim_put(lines, "l", true, true)
end

-- Assembly template commands
vim.api.nvim_create_user_command("AsmHelloWorld", function()
	create_asm_template("hello_world")
end, {})

vim.api.nvim_create_user_command("AsmFunction", function()
	create_asm_template("function_template")
end, {})

-- Assembly build system
vim.api.nvim_create_user_command("AsmBuild", function()
	local file = vim.fn.expand("%")
	local name = vim.fn.expand("%:r")
	vim.cmd("!" .. string.format("nasm -f elf64 %s -o %s.o && ld %s.o -o %s", file, name, name, name))
end, {})

vim.api.nvim_create_user_command("AsmRun", function()
	local name = vim.fn.expand("%:r")
	vim.cmd("!" .. name)
end, {})

vim.api.nvim_create_user_command("AsmDebug", function()
	local name = vim.fn.expand("%:r")
	vim.cmd("!gdb " .. name)
end, {})

-- Assembly documentation lookup
vim.api.nvim_create_user_command("AsmDoc", function(opts)
	local instruction = opts.args ~= "" and opts.args or vim.fn.expand("<cword>")
	vim.cmd("!man " .. instruction .. ' 2>/dev/null || echo "No manual entry for ' .. instruction .. '"')
end, { nargs = "?" })

