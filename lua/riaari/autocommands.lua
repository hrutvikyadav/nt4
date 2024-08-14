
vim.api.nvim_create_autocmd(
    {
        "BufNewFile",
        "BufRead",
    },
    {
        pattern = "*.typ",
        callback = function()
            local buf = vim.api.nvim_get_current_buf()
            -- vim.api.nvim_buf_set_option(buf, "filetype", "typst")
            vim.bo[buf].filetype = "typst"
        end
    }
)
