local M = {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}, -- this is equalent to setup({}) function
}

function M.config()
    require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "vim" },
    })
end
return M
