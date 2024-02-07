local M = { "tpope/vim-fugitive" }

function M.config()
    vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "FUGITIVE [g]it [s]tatus" })
end

return M
