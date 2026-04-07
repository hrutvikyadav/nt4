vim.pack.add({
    "https://github.com/rose-pine/neovim",
    "https://github.com/nvim-lua/plenary.nvim", -- harpoon and telescope
    {
        src = "https://github.com/ThePrimeagen/harpoon",
        -- Git branch, tag, or commit hash
        version = "harpoon2",
    },
    "https://github.com/nvim-treesitter/nvim-treesitter", -- WARN: TSUpdate ???
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
    "https://github.com/tpope/vim-fugitive",

    "https://github.com/nvim-telescope/telescope-fzf-native.nvim", -- build = "make",
    {
        src = "https://github.com/nvim-telescope/telescope.nvim",
        version = vim.version.range('0.2'),
    },
    "https://github.com/tpope/vim-obsession",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/stevearc/oil.nvim",
})

require("riaari.colorscheme2").config()
require("riaari.harpoon").config()
require('nvim-treesitter').install {
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "typescript",
    "rust",
    "javascript",
    "html",
    "toml",
    "tsx",
    "ocaml",
    "go",
    -- for rest client
    "xml",
    "http",
    "json",
    "graphql",
}
require('treesitter-context').setup( {
    -- separator = ">",
    -- How many lines the window should span. Values <= 0 mean no limit.
    max_lines = 8,
})
require("riaari.fugitive").config()
require("riaari.telescope").config()
require("riaari.obsession").config()

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

require("snacks").setup({
    picker = { enabled = true }, -- actions picker
    terminal = { enabled = true }, -- terminal for running spec actions
})

vim.keymap.set("n", "<leader>sb", function() Snacks.picker.buffers() end, {desc = "Buffers" })
vim.keymap.set("n", "<leader>sn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, {desc = "Find Config File" })
vim.keymap.set("n", "<leader>sf", function() Snacks.picker.files() end, {desc = "Find Files" })
vim.keymap.set("n", "<C-p>", function() Snacks.picker.git_files() end, {desc = "Find Git Files" })
vim.keymap.set("n", "<leader>s.", function() Snacks.picker.recent() end, {desc = "Recent" })
-- git
vim.keymap.set("n", "<leader>gb", function() Snacks.picker.git_branches() end, {desc = "Git Branches" })
vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log() end, {desc = "Git Log" })

vim.keymap.set("n", "<leader>gL", function() Snacks.picker.git_log_line() end, {desc = "Git Log Line" })
-- vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, {desc = "Git Status" })
vim.keymap.set("n", "<leader>gz", function() Snacks.picker.git_stash() end, {desc = "Git Stash" })
-- vim.keymap.set("n", "<leader>gd", function() Snacks.picker.git_diff() end, {desc = "Git Diff (Hunks)" })
vim.keymap.set("n", "<leader>g/", function() Snacks.picker.git_log_file() end, {desc = "Git Log File" })
-- Grep
vim.keymap.set("n", "<leader>/", function() Snacks.picker.lines() end, {desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>s/", function() Snacks.picker.grep_buffers() end, {desc = "Grep Open Buffers" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, {desc = "Grep" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, {desc = "Visual selection or word" })
-- search
-- { '<localleader>tr"', function() Snacks.picker.registers() end, desc = "Registers" },
vim.keymap.set("n", "<localleader>t/", function() Snacks.picker.search_history() end, {desc = "Search History" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, {desc = "Help Pages" })
vim.keymap.set("n", "<leader>si", function() Snacks.picker.icons() end, {desc = "Icons" })
vim.keymap.set("n", "<leader>sj", function() Snacks.picker.jumps() end, {desc = "Jumps" })
vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, {desc = "Keymaps" })
vim.keymap.set("n", "<leader>sm", function() Snacks.picker.marks() end, {desc = "Marks" })
vim.keymap.set("n", "<leader>sr", function() Snacks.picker.resume() end, {desc = "Resume" })

local Nlsp = require("neo.lsp")

require("riaari.fidget").config()
require("riaari.nvim-navic").config()
require("lazydev").setup({})
Nlsp.lsp_config()

require("neo.completion")

vim.schedule(function()
    vim.pack.add({
        "https://github.com/lewis6991/gitsigns.nvim",
        "https://github.com/ThePrimeagen/git-worktree.nvim",
    })

    require("riaari.gitsigns").config()
    require("riaari.git-worktree").config()

    local as = require("abshelper.scanner")
    as.setup()
    require("revision_catalyst").setup()
end)
