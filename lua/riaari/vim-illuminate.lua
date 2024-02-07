local M = {
    "RRethy/vim-illuminate",
    event = {
        "BufEnter *.lua",
        "BufEnter *.go",
        "BufEnter *.rs",
        "BufEnter *.nix",
        "BufEnter *.c",
        "BufEnter *.ml",
        "BufEnter *.html",
        "BufEnter *.js",
        "BufEnter *.jsx",
        "BufEnter *.ts",
        "BufEnter *.tsx",
    },
}

function M.config()
    require("illuminate").configure({
        filetype_denylist = {
            "fugitive",
            "help",
            "gitcommit",
            "fugitiveblame",
        },
    })
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { underline = false, bg = "#363B54" })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { underline = false, bg = "#363B54" })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { underline = false, bg = "#363B54" })
    --:hi IlluminatedWordText gui=underline guibg=
end

return M
