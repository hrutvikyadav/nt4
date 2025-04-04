local M = { "ThePrimeagen/harpoon",
    branch = "harpoon2",
}

function M.config()

    local harpoon = require('harpoon')
    harpoon:setup( {
        [ "cmd" ] = {

            -- When you call list:add() this function is called and the return
            -- value will be put in the list at the end.
            --
            -- which means same behavior for prepend except where in the list the
            -- return value is added
            --
            -- @param possible_value string only passed in when you alter the ui manual
            add = function(possible_value)
                -- get the current line idx
                local idx = vim.fn.line(".")

                -- read the current line
                local cmd = vim.api.nvim_buf_get_lines(0, idx - 1, idx, false)[1]
                if cmd == nil then
                    return nil
                end

                return {
                    value = cmd,
                    context = { my_custom_context = "Just for context this is from the readme" },
                }
            end,

            --- This function gets invoked with the options being passed in from
            --- list:select(index, <...options...>)
            --- @param list_item {value: any, context: any}
            --- @param list { ... }
            --- @param option any
            select = function(list_item, list, option)
                local tvals = table.concat(list_item.context, " ")
                -- inspect list_item.context 👇
                vim.inspect(list_item.context)
                --
                -- WOAH, IS THIS HTMX LEVEL XSS ATTACK??
                -- vim.cmd("echo " .. list_item.value .. tvals)
                print("Selected: " .. list_item.value .. " " .. tvals)
            end

        },
        [ "bookmarks" ] = {

            -- When you call list:add() this function is called and the return
            -- value will be put in the list at the end.
            --
            -- which means same behavior for prepend except where in the list the
            -- return value is added
            --
            -- @param possible_value string only passed in when you alter the ui manual
            add = function(possible_value)
                -- get the current line idx
                local idx = vim.fn.line(".")

                -- read the current line
                local cmd = vim.api.nvim_buf_get_lines(0, idx - 1, idx, false)[1]
                if cmd == nil then
                    return nil
                end

                return {
                    value = cmd,
                    context = { some_context = "Just for context this is from the readme" },
                }
            end,

            --- This function gets invoked with the options being passed in from
            --- list:select(index, <...options...>)
            --- @param list_item {value: any, context: any}
            --- @param list { ... }
            --- @param option any
            select = function(list_item, list, option)
                -- print(vim.inspect(list_item.context))
                vim.cmd([[!wsl-open ]] .. list_item.value)
            end

        },

        [ "one_off" ] = {

            -- @param possible_value string only passed in when you alter the ui manual
            add = function(possible_value)
                -- get the current line idx
                local idx = vim.fn.line(".")

                -- read the current line
                local cmd = vim.api.nvim_buf_get_lines(0, idx - 1, idx, false)[1]
                if cmd == nil then
                    return nil
                end

                return {
                    value = cmd,
                    context = { "Just for context this is from the readme" },
                }
            end,

            --- This function gets invoked with the options being passed in from
            --- list:select(index, <...options...>)
            --- @param list_item {value: any, context: any}
            --- @param list { ... }
            --- @param option any
            select = function(list_item, list, option)
                local parts = vim.split(list_item.value, "::")
                -- vim.cmd([[call system("tmux neww ]] .. list_item.value .. [[ ")]] )
                -- neww -S -n .. parts[1] .. -c .. vim.fn.getcwd() .. [[ ]] .. parts[2])
                vim.cmd([[call system("tmux neww -S -n ]] .. parts[1] .. [[ -c ]] .. vim.fn.getcwd() .. [[ ]] .. parts[2] .. [[ ")]] )
            end

        }

    } )

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

    -- vim.keymap.set("n", "<localleader>ha", function() harpoon:list("cmd"):add() end)
    -- vim.keymap.set("n", "<localleader><C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list("cmd")) end) -- only for testing
    vim.keymap.set("n", "<localleader>hb", function() harpoon.ui:toggle_quick_menu(harpoon:list("bookmarks")) end)
    vim.keymap.set("n", "<localleader>ho", function() harpoon.ui:toggle_quick_menu(harpoon:list("one_off")) end)

    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "[h", function() harpoon:list():prev() end)
    vim.keymap.set("n", "]h", function() harpoon:list():next() end)

    vim.keymap.set("n", "[H", function() harpoon:list("one_off"):prev() end)
    vim.keymap.set("n", "]H", function() harpoon:list("one_off"):next() end)

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
