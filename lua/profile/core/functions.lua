--Custom functions
local M = {}

-- Toggle diagnostics
function M.toggle_diagnostics()
	if vim.g.diagnostics_enabled == nil then
		vim.g.diagnostics_enabled = true
	end

	vim.g.diagnostics_enabled = not vim.g.diagnostics_enabled

	if vim.g.diagnostics_enabled then
		vim.diagnostic.enable()
		print("Diagnostics enabled")
	else
		vim.diagnostic.disable()
		print("Diagnostics disabled")
	end
end

-- Check if required tools for assembly development are installed
function M.check_asm_tools()
	local tools = {
		{ name = "asm-lsp", cmd = "asm-lsp" },
		{ name = "nasm", cmd = "nasm" },
		{ name = "as (GAS)", cmd = "as" },
		{ name = "ld", cmd = "ld" },
		{ name = "gdb", cmd = "gdb" },
		{ name = "objdump", cmd = "objdump" },
		{ name = "readelf", cmd = "readelf" },
		{ name = "checksec", cmd = "checksec" },
		{ name = "valgrind", cmd = "valgrind" },
		{ name = "asmfmt", cmd = "asmfmt" },
	}

	local missing_tools = {}
	local installed_tools = {}

	for _, tool in ipairs(tools) do
		local found = vim.fn.executable(tool.cmd) == 1
		if found then
			table.insert(installed_tools, tool.name)
		else
			table.insert(missing_tools, tool.name)
		end
	end

	print("=== Assembly Development Tools ===")
	print("Installed tools:")
	for _, tool in ipairs(installed_tools) do
		print("  ✓ " .. tool)
	end

	if #missing_tools > 0 then
		print("\nMissing tools:")
		for _, tool in ipairs(missing_tools) do
			print("  ✗ " .. tool)
		end
		print("\nInstall missing tools for full assembly support")
	else
		print("\nAll tools installed! You're ready for assembly development.")
	end
end

-- Quick compile and run for assembly
function M.asm_run()
	local bufname = vim.api.nvim_buf_get_name(0)
	local basename = vim.fn.fnamemodify(bufname, ":r")
	local extension = vim.fn.fnamemodify(bufname, ":e")

	if extension =="asm" then
		-- NASM compilation
		local cmd = string.format(
			"nasm -f elf64 %s.asm -o %s.o && ld %s.o -o %s && ./%s",
			basename,
			basename,
			basename,
			basename,
			basename
		)
		vim.cmd("!" .. cmd)
	elseif extension == "s" or extension == "S" then
		-- GAS compilation
		local cmd = string.format(
			"as %s.%s -o %s.o && ld %s.o -o%s && ./%s",
			basename,
			extension,
			basename,
			basename,
			basename,
			basename
		)
		vim.cmd("!" .. cmd)
	else
		print("Not an assembly file")
	end
end

-- Check if required tools for C++development are installed
function M.check_cpp_tools()
	local tools = {
		{ name = "clangd", cmd = "clangd" },
		{ name = "clang-tidy", cmd = "clang-tidy" },
		{ name = "clang-format", cmd = "clang-format" },
	{ name = "cppcheck", cmd = "cppcheck" },
		{ name = "gdb", cmd = "gdb" },
		{ name = "lldb", cmd = "lldb" },
		{ name = "codelldb", cmd = "codelldb" },
{ name = "cmake", cmd = "cmake" },
		{ name = "bear", cmd = "bear" },
		{ name = "valgrind", cmd = "valgrind" },
		{ name = "qmlls", cmd = "qmlls"},
		{ name = "qmllint", cmd = "qmllint" },
		{ name = "qmlscene", cmd = "qmlscene" },
	}

	local missing_tools = {}
	local installed_tools = {}

	for _, tool in ipairs(tools) do
		local found = vim.fn.executable(tool.cmd) == 1
		if found then
			table.insert(installed_tools, tool.name)
		else
			table.insert(missing_tools, tool.name)
		end
	end

	print("=== C/C++ Development Tools ===")
	print("Installed tools:")
	for _, tool in ipairs(installed_tools) do
		print("  ✓ " .. tool)
	end

	if #missing_tools > 0 then
		print("\nMissing tools:")
		for _, tool in ipairs(missing_tools) do
			print(" ✗ " .. tool)
		end
		print("\nInstall missing tools for full C/C++ support")
	else
		print("\nAll tools installed! You're ready for C/C++ development.")
	end
end

-- Create a new C++ class with header and implementation
function M.create_cpp_class()
	local class_name = vim.fn.input("Class name: ")
	if class_name == "" then
	print("No class name provided")
		return
	end

	local header_name = class_name .. ".hpp"
	local impl_name = class_name .. ".cpp"

	-- Create header file content
	local header_content = {
		"#pragma once",
		"",
		"#include <iostream>",
		"",
		"class " .. class_name .. " {",
		"public:",
		"    " .. class_name .. "();",
		"    ~" .. class_name .. "();",
		"",
		"private:",
		"    // Private members",
		"};",
		"",
	}

	-- Create implementation file content
	local impl_content = {
		'#include "' .. header_name .. '"',
		"",
		class_name .. "::" .. class_name .. "() {",
		"    // Constructor implementation",
		"}",
		"",
		class_name .. "::~" .. class_name .. "(){",
		"    // Destructor implementation",
		"}",
		"",
	}

	-- Create new buffers and populate them
	local header_buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_lines(header_buf, 0, -1, false, header_content)
	vim.api.nvim_buf_set_name(header_buf, header_name)

	local impl_buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_lines(impl_buf, 0, -1, false, impl_content)
	vim.api.nvim_buf_set_name(impl_buf, impl_name)

-- Switch to header buffer
	vim.api.nvim_set_current_buf(header_buf)

	print("Created " .. header_name .. " and " .. impl_name)
end

-- Check if required tools for Rust development are installed
function M.check_rust_tools()
	local tools = {
		{ name = "rust-analyzer", cmd = "rust-analyzer" },
		{ name = "rustc", cmd = "rustc" },
		{ name = "cargo", cmd = "cargo" },
		{ name = "rustfmt", cmd = "rustfmt" },
		{ name = "clippy",cmd = "clippy" },
		{ name = "codelldb", cmd = "codelldb" },
		{ name = "cargo-audit", cmd = "cargo-audit" },
		{ name = "cargo-expand", cmd = "cargo-expand" },
		{ name = "cargo-valgrind", cmd = "cargo-valgrind" },
		{ name = "cargo-llvm-cov", cmd = "cargo-llvm-cov" },
	}

	local missing_tools = {}
	local installed_tools = {}

	for _, tool in ipairs(tools) do
		local found = vim.fn.executable(tool.cmd) == 1
		if found then
			table.insert(installed_tools, tool.name)
		else
			table.insert(missing_tools, tool.name)
		end
	end

	print("=== RustDevelopment Tools ===")
	print("Installed tools:")
	for _, tool in ipairs(installed_tools) do
		print("  ✓ " .. tool)
	end

	if #missing_tools > 0 then
		print("\nMissing tools:")
		for _, tool in ipairs(missing_tools) do
			print("  ✗" .. tool)
		end
		print("\nInstall missing tools for full Rustsupport")
	else
		print("\nAll tools installed! You're ready for Rust development.")
	end
end

-- Create a new Rust module
function M.create_rust_module()
	local module_name = vim.fn.input("Module name: ")
	if module_name == "" then
		print("No module name provided")
	return
	end

	local mod_file = module_name .. ".rs"

	-- Create module file content
	local mod_content = {
		"//! " .. module_name .. " module",
		"",
		"/// A sample function",
		"pub fn hello() {",
		'    println!("Hellofrom ' .. module_name .. '!");',
		"}",
		"",
	}

	-- Create new buffer and populate it
	local mod_buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_lines(mod_buf, 0, -1, false, mod_content)
	vim.api.nvim_buf_set_name(mod_buf, mod_file)

	-- Switch to module buffer
	vim.api.nvim_set_current_buf(mod_buf)

	print("Created " .. mod_file)
end

-- Check if required tools for Zig development are installed
function M.check_zig_tools()
	local tools = {
		{name = "zls", cmd = "zls" },
		{ name = "zig", cmd = "zig" },
		{ name = "codelldb", cmd = "codelldb" },
	}

	local missing_tools = {}
	local installed_tools = {}

	for _, tool in ipairs(tools)do
		local found = vim.fn.executable(tool.cmd) == 1
		if found then
			table.insert(installed_tools, tool.name)
		else
			table.insert(missing_tools, tool.name)
		end
	end

	print("=== ZigDevelopment Tools ===")
	print("Installed tools:")
	for _, tool in ipairs(installed_tools) do
		print("  ✓ " .. tool)
	end

	if #missing_tools > 0 then
		print("\nMissing tools:")
		for _, tool in ipairs(missing_tools) do
			print("  ✗" .. tool)
		end
		print("\nInstall missing tools for full Zigsupport")
	else
		print("\nAll tools installed! You're ready for Zig development.")
	end
end

-- Create a new Zig module
function M.create_zig_module()
	local module_name = vim.fn.input("Module name: ")
	if module_name == "" then
		print("No module name provided")
	return
	end

	local mod_file = module_name .. ".zig"

	-- Create module file content
	local mod_content = {
		'const std = @import("std");',
		"",
		"pub fn hello() void {",
		'    std.debug.print("Hello from ' .. module_name .. '!\\n");',
		"}",
		"",
'test "hello test" {',
		"    hello();",
		"}",
		"",
	}

	-- Create new buffer and populate it
	local mod_buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_lines(mod_buf, 0, -1, false, mod_content)
	vim.api.nvim_buf_set_name(mod_buf, mod_file)

	-- Switch to module buffer
	vim.api.nvim_set_current_buf(mod_buf)

	print("Created " .. mod_file)
end

-- ReloadLua module
function M.reload_lua_module()
  local bufname = vim.api.nvim_buf_get_name(0)
  local modname = bufname:gsub(vim.fn.expand("~/.config/nvim/lua/"), ""):gsub("\\.lua$", ""):gsub("/", ".")
  
  -- Remove from package.loaded
  package.loaded[modname] = nil
  
  -- Try to reload
  local success, result = pcall(require, modname)
  if success then
    print("Successfully reloaded " .. modname)
  else
    print("Error reloading " .. modname .. ": " .. result)
end
end

--Web development functions
function M.run_npm_script()
    local script = vim.fn.input("npm run: ")
    if script ~= "" then
        vim.cmd("belowright new | terminal npm run " .. script)
    end
end

function M.run_yarn_script()
    local script = vim.fn.input("yarn: ")
    if script ~= "" then
        vim.cmd("belowright new | terminal yarn " .. script)
    end
end

function M.run_pnpm_script()
    local script = vim.fn.input("pnpm: ")
    if script ~= "" then
        vim.cmd("belowright new | terminal pnpm " .. script)
    end
end

return M

