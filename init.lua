require("riaari.launch")
require("riaari.options")
require("riaari.remaps")
require("riaari.usercommands")

require("riaari.autocommands")
require("riaari.colors")

--need to add specs before loading lazy
spec("riaari.colorscheme") -- darkplus for now
spec("riaari.colorscheme2") -- rosepine
spec("riaari.colorscheme3") -- tokyonight
spec("riaari.colorscheme4") -- fluoromachine
spec("riaari.colorscheme5") -- nightowl
spec("riaari.neoconf")
spec("riaari.neodev")
spec("riaari.telescope")
spec("riaari.telescope-ui-select")
spec("riaari.treesitter")
spec("riaari.treesitter-context")
spec("riaari.harpoon")
spec("riaari.fugitive")
spec("riaari.undotree")
spec("riaari.schemastore")

spec("riaari.mason")
spec("riaari.lspconfig")
spec("riaari.cmp")
spec("riaari.ts-tools")
spec("riaari.rustacean")
spec("riaari.go-nvim")

spec("riaari.fidget")
spec("riaari.ibl")
spec("riaari.gitsigns")
spec("riaari.trouble")
spec("riaari.git-worktree")
spec("riaari.nvim-surround")
spec("riaari.vim-illuminate")
spec("riaari.zenmode")
spec("riaari.todo-comments")
-- spec("riaari.comment")
spec("riaari.overseer")
spec("riaari.vim-v-multi")
spec("riaari.autotags")
spec("riaari.autopairs")
-- spec("riaari.devdocs")
spec("riaari.copilot")
spec("riaari.cellauto")
spec('riaari.gen')
spec("riaari.obsidian")

spec("riaari.emmet-vim")
spec("riaari.package-info")
spec("riaari.import-cost")

-- spec("riaari.luarocks")
-- spec("riaari.restclient")

-- spec("riaari.codesnap")
spec("riaari.ror")
spec("riaari.dadbod")

spec("riaari.navigator")

-- spec("riaari.sg")

spec("riaari.ufo")
spec("riaari.rainbow-delimiters")


require("riaari.lazy")
