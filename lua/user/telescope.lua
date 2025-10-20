local telescope = require("telescope")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key",
      },
    },
  },
  extensions = {
    -- Add if needed
  },
})

telescope.load_extension("harpoon")
-- Other extensions

return {}