local M = { "ThePrimeagen/harpoon",
    branch = "harpoon2",
}

function M.config()

    local harpoon = require('harpoon')
    harpoon:setup{}

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files, opts)
        opts = opts or {}
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new(opts, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
                results = file_paths,
            }),
            -- previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter(opts),
        }):find()
    end

    vim.keymap.set("n", "<localleader>e", function() toggle_telescope(harpoon:list(), require("telescope.themes").get_dropdown{}) end,
        { desc = "Open harpoon window" })

    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

    harpoon:extend({
        UI_CREATE = function(cx)
            vim.keymap.set("n", "<C-v>", function()
                harpoon.ui:select_menu_item({ vsplit = true })
            end, { buffer = cx.bufnr })

            vim.keymap.set("n", "<C-x>", function()
                harpoon.ui:select_menu_item({ split = true })
            end, { buffer = cx.bufnr })

            vim.keymap.set("n", "<C-t>", function()
                harpoon.ui:select_menu_item({ tabedit = true })
            end, { buffer = cx.bufnr })
        end,
    })
end

return M
