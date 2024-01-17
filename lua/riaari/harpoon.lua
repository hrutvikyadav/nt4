local M = {"theprimeagen/harpoon"}

function M.config()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    vim.keymap.set("n", "<leader>a", mark.add_file, { desc = '[a]dd to harpoon list' })
    vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = '[e]xplore harpoon list' })

    vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = 'navigate [1]st item in harpoon list' })
    vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = 'navigate [2]nd item in harpoon list' })
    vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = 'navigate [3]rd item in harpoon list' })
    vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { desc = 'navigate [4]th item in harpoon list' })
end

return M
