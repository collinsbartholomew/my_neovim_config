---
-- Assembly templates
local M = {}

-- NASM template
function M.nasm_template()
    local template = [[
section .data
    msg db 'Hello, World!', 0xA
    len equ $ - msg

section .text
    global _start

_start:
    ; write message
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg        ; message
    mov rdx, len        ; length
    syscall

    ; exit
    mov rax, 60         ; sys_exit
    mov rdi, 0          ; status
    syscall
]]

    -- Create a new buffer and set the content
    vim.cmd("enew")
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(template, "\n"))
    vim.api.nvim_buf_set_option(buf, 'filetype', 'asm')
    vim.api.nvim_buf_set_option(buf, 'buftype', '')
    vim.api.nvim_buf_set_name(buf, 'main.asm')
end

-- GAS template
function M.gas_template()
    local template = [[
.section .data
    msg: .ascii "Hello, World!\n"
    len = . - msg

.section .text
    .global _start

_start:
    # write message
    mov $1, %rax        # sys_write
    mov $1, %rdi        # stdout
    mov $msg, %rsi      # message
    mov $len, %rdx      # length
    syscall

    # exit
    mov $60, %rax       # sys_exit
    mov $0, %rdi        # status
    syscall
]]

    -- Create a new buffer and set the content
    vim.cmd("enew")
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(template, "\n"))
    vim.api.nvim_buf_set_option(buf, 'filetype', 'gas')
    vim.api.nvim_buf_set_option(buf, 'buftype', '')
    vim.api.nvim_buf_set_name(buf, 'main.s')
end

return M