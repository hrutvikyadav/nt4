local M = {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
        separator = ">",
    },
    event = { "BufReadPre", "BufNewFile" },
}

return M
