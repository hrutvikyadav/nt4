require("riaari.launch")
require("riaari.options")
require("riaari.remaps")
require("riaari.usercommands")

--need to add specs before loading lazy
spec("riaari.colorscheme") -- darkplus for now
--spec('riaari.colorscheme2') -- rosepine
spec("riaari.neoconf")
spec("riaari.neodev")
spec("riaari.telescope")
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

spec("riaari.fidget")
spec("riaari.ibl")
spec("riaari.gitsigns")
spec("riaari.trouble")
spec("riaari.git-worktree")
spec("riaari.nvim-surround")
spec("riaari.vim-illuminate")
spec("riaari.zenmode")
spec("riaari.todo-comments")
spec("riaari.comment")
spec("riaari.overseer")
spec("riaari.vim-v-multi")
--spec('riaari.devdocs')
--TODO: enable copilot in Github
spec("riaari.copilot")
spec("riaari.cellauto")
--spec('riaari.gen')

require("riaari.lazy")
