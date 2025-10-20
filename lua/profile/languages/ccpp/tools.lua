-- added-by-agent: ccpp-setup 20251020
-- mason: none
-- manual: sudo pacman -S clang-format clang-tidy cppcheck cmake bear

local M = {}

function M.setup()
  -- Setup conform.nvim for formatting if available
  local conform_ok, conform = pcall(require, "conform")
  if conform_ok then
    conform.setup({
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        qml = { "qmlformat" },
      },
      format_on_save = true,
    })
  end

  -- Helper function to run commands in a terminal buffer
  local function run_in_term(cmd, title)
    vim.cmd("botright new")
    local buf = vim.api.nvim_get_current_buf()
    local chan = vim.api.nvim_open_term(buf, {})
    vim.api.nvim_buf_set_name(buf, title)
    vim.fn.jobstart(cmd, {
      on_stdout = function(_, data)
        data = table.concat(data, "\n")
        vim.api.nvim_chan_send(chan, data)
      end,
      on_stderr = function(_, data)
        data = table.concat(data, "\n")
        vim.api.nvim_chan_send(chan, data)
      end,
      stdout_buffered = true,
      stderr_buffered = true,
    })
  end

  -- Create compile_commands.json using CMake or Bear
  vim.api.nvim_create_user_command("MakeCompileDB", function()
    local choice = vim.fn.input({
      prompt = "Choose build system:\n1) CMake\n2) Bear + Make\nChoice (1/2): ",
    })

    if choice == "1" then
      run_in_term(
        {"sh", "-c", "cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && cmake --build build && ln -sf build/compile_commands.json ."},
        "[CompileDB - CMake]"
      )
    elseif choice == "2" then
      run_in_term(
        {"sh", "-c", "bear -- make"},
        "[CompileDB - Bear]"
      )
    end
  end, {})

  -- Run clang-tidy on current file
  vim.api.nvim_create_user_command("ClangTidy", function()
    local file = vim.fn.expand("%:p")
    run_in_term(
      {"sh", "-c", string.format("clang-tidy -p=./ %s", file)},
      "[Clang-Tidy]"
    )
  end, {})

  -- Run cppcheck on project
  vim.api.nvim_create_user_command("CppCheck", function()
    local dir = vim.fn.input("Directory to check: ", vim.fn.getcwd(), "dir")
    run_in_term(
      {"sh", "-c", string.format("cppcheck --enable=all %s", dir)},
      "[CppCheck]"
    )
  end, {})
end

return M
