local M = {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    -- or                              , branch = '0.1.x',
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
}

function M.config()

    require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
            ['ui-select'] = {
                require('telescope.themes').get_dropdown(),
            },
        },
    }


    require("telescope").load_extension("fzf")
    pcall(require("telescope").load_extension, "ui-select")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "TELESCOPE [s]earch pwd [f]iles" })
    vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "TELESCOPE git files" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "TELESCOPE live grep pwd files" })

    vim.keymap.set("n", "<leader>Gc", builtin.git_commits, { desc = "TELESCOPE [G]it [c]ommits" })
    vim.keymap.set("n", "<leader>Gb", builtin.git_branches, { desc = "TELESCOPE [G]it [b]ranches" })
end

return M
