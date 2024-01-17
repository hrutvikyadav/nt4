-- this module is the plugin spec for colorscheme
--
local M = {
    'LunarVim/darkplus.nvim',
    lazy = false,
    priority = 1000,
}

function M.config()
    vim.cmd.colorscheme("darkplus")
end

return M
