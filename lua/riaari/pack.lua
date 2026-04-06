vim.pack.add({
    "https://github.com/rose-pine/neovim",
    "https://github.com/nvim-lua/plenary.nvim", -- harpoon and telescope
    {
        src = "https://github.com/ThePrimeagen/harpoon",
        -- Git branch, tag, or commit hash
        versiofind_filesn = "harpoon2",
    },
    "https://github.com/nvim-treesitter/nvim-treesitter", -- WARN: TSUpdate ???
    "https://github.com/tpope/vim-fugitive",

    "https://github.com/nvim-telescope/telescope-fzf-native.nvim", -- build = "make",
    {
        src = "https://github.com/nvim-telescope/telescope.nvim",
        version = vim.version.range('0.2'),
    },
    "https://github.com/tpope/vim-obsession",

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
require("riaari.fugitive").config()
require("riaari.telescope").config()
require("riaari.obsession").config()

local Nlsp = require("neo.lsp")

require("riaari.fidget").config()
require("riaari.nvim-navic").config()
require("lazydev").setup({})
Nlsp.lsp_config()

require("neo.completion")
