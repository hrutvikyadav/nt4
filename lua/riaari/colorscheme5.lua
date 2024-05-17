local M = {
  "oxfist/night-owl.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

local default_opts = {
    bold = true,
    italics = true,
    underline = true,
    undercurl = true,
    transparent_background = true,
}

function M.config()
  require("night-owl").setup(default_opts)
  vim.cmd.colorscheme("night-owl")
end

return M
