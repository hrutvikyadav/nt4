local M = {
    'numToStr/Navigator.nvim'
}

function M.config()
    require('Navigator').setup()

    vim.keymap.set({'n', 't'}, '<C-h>', '<CMD>NavigatorLeft<CR>')
    vim.keymap.set({'n', 't'}, '<C-l>', '<CMD>NavigatorRight<CR>')
    vim.keymap.set({'n', 't'}, '<C-k>', '<CMD>NavigatorUp<CR>')
    vim.keymap.set({'n', 't'}, '<C-j>', '<CMD>NavigatorDown<CR>')
    -- vim.keymap.set({'n', 't'}, '<C-p>', '<CMD>NavigatorPrevious<CR>')

end

return M

