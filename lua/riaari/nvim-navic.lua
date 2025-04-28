local M = {
    "SmiteshP/nvim-navic",
}

function M.config()
    require("nvim-navic").setup({
        highlight = true,
    })

    vim.api.nvim_set_hl(0, "WinBar", { fg = "#908caa", bg = "none" })
    vim.api.nvim_set_hl(0, "WinbarFilename", { bold = true })
end

return M
