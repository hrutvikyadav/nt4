require("riaari.launch")
require("riaari.options")
require("riaari.remaps")
require("riaari.usercommands")
require("riaari.myutil")
require("riaari.moreutilz")

require("riaari.autocommands")
-- require("riaari.colors") loaded on after/colors

--need to add specs before loading lazy
spec("riaari.colorscheme") -- darkplus for now
spec("riaari.colorscheme2") -- rosepine
spec("riaari.colorscheme3") -- tokyonight
spec("riaari.colorscheme4") -- fluoromachine
spec("riaari.colorscheme5") -- nightowl
-- spec("riaari.neoconf")
spec("riaari.neodev")
spec("riaari.harpoon")
spec("riaari.telescope")
spec("riaari.telescope-ui-select")
spec("riaari.treesitter")
spec("riaari.treesitter-context")
spec("riaari.fugitive")
spec("riaari.undotree")
-- spec("riaari.schemastore")
spec("riaari.oil")

spec("riaari.nvim-navic")

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
-- spec("riaari.vim-illuminate")
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
spec("riaari.debug")

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
-- spec("riaari.neogit")
-- spec("riaari.gh-actions")
-- spec("riaari.octo")

spec("riaari.obsession")
spec("riaari.nvim-lint")

-- spec("riaari.ts_comment_string")
-- spec("riaari.witt")
spec("riaari.rssfeed")
spec("riaari.flash")
-- spec("riaari.sleuth")

-- mellow
-- spec("riaari.colorscheme6")
-- everforest
-- sherbet
-- oh-lucy
--
spec("riaari.dealwithit")
spec("riaari.early-retirement")

-- spec("riaari.avante")
spec("riaari.marks")
spec("riaari.hlpatterns")

require("riaari.lazy")
