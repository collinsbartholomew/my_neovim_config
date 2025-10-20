require("lualine").setup({
  options = {
    theme = "tokyonight",
    globalstatus = true,
  },
  sections = {
    lualine_c = {
      { "filename", path = 1 },
      { require("nvim-navic").get_location, cond = require("nvim-navic").is_available },
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
  },
})

return {}