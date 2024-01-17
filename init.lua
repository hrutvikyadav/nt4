require('riaari.launch')
require('riaari.options')
require('riaari.remaps')

--need to add specs before loading lazy
spec('riaari.colorscheme') -- darkplus for now
-- spec('riaari.neoconf')
-- spec('riaari.neodev')
spec('riaari.telescope')
spec('riaari.treesitter')
spec('riaari.treesitter-context')
spec('riaari.harpoon')
spec('riaari.fugitive')

require('riaari.lazy')

