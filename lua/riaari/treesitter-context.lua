local M = {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
        -- separator = ">",
        -- How many lines the window should span. Values <= 0 mean no limit.
        max_lines = 8,
    },
    event = { "BufReadPre", "BufNewFile" },
}

return M
