-- Custom functions

function _G.custom_fold_text()
  local line = vim.fn.getline(vim.v.foldstart)
  local folded = vim.v.foldend - vim.v.foldstart + 1
  return line .. "  " .. folded .. " lines "
end

vim.o.foldtext = "v:lua.custom_fold_text()"

-- Example custom script: Generate boilerplate for Java class
function _G.generate_java_class()
  local class_name = vim.fn.input("Class name: ")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "public class " .. class_name .. " {",
    "    public static void main(String[] args) {",
    "        System.out.println(\"Hello, World!\");",
    "    }",
    "}",
  })
end

vim.api.nvim_create_user_command("JavaBoiler", "lua generate_java_class()", {})

-- Other custom functions as needed