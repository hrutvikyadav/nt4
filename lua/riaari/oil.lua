local M = {
    "stevearc/oil.nvim",
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    }
}

function M.config()
    require("oil").setup({
        -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.      default_file_explorer = true,
        columns = {
            "icon",
            "permissions",
            "size",
            "mtime",
        },
    })

    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end

return M
