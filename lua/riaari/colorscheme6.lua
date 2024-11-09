
local M = {
    "mellow-theme/mellow.nvim",
    lazy = false,
    priority = 1000,
}

function M.config()
    -- Example config in lua

    -- Configure the appearance
    vim.g.mellow_italic_functions = true
    -- vim.g.mellow_bold_functions = true
    vim.g.mellow_transparent = true
    vim.g.mellow_bold_keywords = true


    -- Load the colorscheme
    vim.cmd([[colorscheme mellow]])
end

return M
