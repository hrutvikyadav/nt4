local M = {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    -- or                              , branch = '0.1.x',
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-telescope/telescope-dap.nvim",
        -- INFO: my first plugin extension wohoo!
        { "hrutvikyadav/my-telescope-spartan-plugin", branch = "dev" },
        { "desdic/agrolens.nvim" },
    },
}

function M.config()

    require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
            border = false,
            mappings = {
                i = { ['<c-enter>'] = 'to_fuzzy_refine' },
            },
        },
        -- pickers = {}
        extensions = {
            fzf = {},
            -- ['ui-select'] = {
            --     require('telescope.themes').get_dropdown({
            --         border = true,
            --     }),
            -- },
            -- ["my-telescope-spartan-plugin"] = {
            --     features = {
            --         "Task",
            --         -- "Time",
            --         -- "Bug",
            --     },
            --     maps = {
            --         -- WARN: disabled for now
            --         actions = {
            --             task_info = "<C-i>",
            --             task_edit = "<C-e>",
            --             task_terminal = "<C-t>",
            --             task_start = "<C-s>",
            --             task_stop = "<C-x>",
            --             task_annotate = "<C-a>",
            --             tasks_weekly_log = "<C-d>",
            --         },
            --     }
            -- },
            -- agrolens = {},
        },
    }


    require("telescope").load_extension("fzf")
    pcall(require("telescope").load_extension, "ui-select")
    local builtin = require("telescope.builtin")
    vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope find files' })
    -- require('telescope').load_extension('dap')
    -- require("telescope").load_extension("my-telescope-spartan-plugin")
    -- require("telescope").load_extension('harpoon')
    -- require "telescope".load_extension("agrolens")

    -- local builtin = require("telescope.builtin")
    -- vim.keymap.set("n", "<leader>sf", function()
    --     builtin.find_files { winblend = 0 }
    -- end, { desc = "TELESCOPE [s]earch pwd [f]iles" })
    -- vim.keymap.set("n", "<C-p>", function ()
    --     builtin.git_files(require("telescope.themes").get_ivy {
    --         winblend = 0,
    --         border = false,
    --         attach_mappings = function(_, map)
    --             map("i", "asdf", function(_prompt_bufnr)
    --                 print "You typed asdf"
    --             end)
    --
    --             map({"i", "n"}, "<C-o>", function(_prompt_bufnr)
    --                 print "You typed <C-r>"
    --             end)
    --
    --             -- needs to return true if you want to map default_mappings and
    --             -- false if not
    --             return true
    --         end,
    --     } )
    -- end , { desc = "TELESCOPE git files" })
    -- vim.keymap.set("n", "<leader>sg", function()
    --     builtin.live_grep(require("telescope.themes").get_ivy { winblend = 0, border = false,  } )
    -- end, { desc = "TELESCOPE live grep pwd files" })
    --
    -- vim.keymap.set("n", "<leader>gc", function()
    --     builtin.git_commits(require("telescope.themes").get_ivy { winblend = 0, border = false,  } )
    -- end, { desc = "TELESCOPE [G]it [c]ommits" })
    -- vim.keymap.set("n", "<leader>gz", function()
    --     builtin.git_stash(require("telescope.themes").get_ivy { winblend = 0, border = false,  } )
    -- end, { desc = "TELESCOPE [G]it [z]stash" })
    -- vim.keymap.set("n", "<leader>g/c", function()
    --     builtin.git_bcommits(require("telescope.themes").get_ivy { winblend = 0, border = false,  } )
    -- end, { desc = "TELESCOPE [G]it [B]commits" })
    -- vim.keymap.set("n", "<leader>gb", function()
    --     builtin.git_branches(require("telescope.themes").get_ivy { winblend = 0, border = false,  } )
    -- end, { desc = "TELESCOPE [G]it [b]ranches" })
    -- vim.keymap.set("n", "<leader>ss", function()
    --     builtin.grep_string(require("telescope.themes").get_ivy { winblend = 0, border = false,  } )
    -- end, { desc = "TELESCOPE [G]it [b]ranches" })
    --
    -- -- from kickstart
    -- vim.keymap.set('n', '<leader>sr', function()
    --     builtin.resume(require("telescope.themes").get_ivy { winblend = 0, border = false,  } )
    -- end, { desc = '[S]earch [R]esume' })
    -- vim.keymap.set('n', '<leader>s.', function()
    --     builtin.oldfiles(require("telescope.themes").get_ivy { winblend = 0, border = false,  } )
    -- end, { desc = '[S]earch Recent Files ("." for repeat)' })
    -- vim.keymap.set('n', '<leader>sb', function()
    --     builtin.buffers(require("telescope.themes").get_ivy { winblend = 0, border = false,  } )
    -- end, { desc = '[ ] Find existing buffers' })
    -- vim.keymap.set('n', '<leader>sh', function()
    --     builtin.help_tags(require("telescope.themes").get_ivy { winblend = 0, border = false,  } )
    -- end, { desc = '[ ] Find help' })
    --
    -- vim.keymap.set('n', '<localleader>tq', function() builtin.quickfixhistory(require("telescope.themes").get_ivy { winblend = 0, border = false,  } ) end, { desc = '[ ] Find quickfixhistory' })
    -- vim.keymap.set('n', '<localleader>tc', function() builtin.command_history(require("telescope.themes").get_ivy { winblend = 0, border = false,  } ) end, { desc = '[ ] Find command_history' })
    -- vim.keymap.set('n', '<localleader>t/', function() builtin.search_history(require("telescope.themes").get_ivy { winblend = 0, border = false,  } ) end, { desc = '[ ] Find search_history' })
    -- vim.keymap.set('n', '<localleader>tr', function() builtin.registers(require("telescope.themes").get_ivy { winblend = 0, border = false,  } ) end, { desc = '[ ] Find registers' })
    -- vim.keymap.set('n', '<localleader>tj', function() builtin.jumplist(require("telescope.themes").get_ivy { winblend = 0, border = false,  } ) end, { desc = '[ ] Find jumps' })
    -- vim.keymap.set('n', '<localleader>tt', function() builtin.treesitter(require("telescope.themes").get_ivy { winblend = 0, border = false,  } ) end, { desc = '[ ] Find treesitter nodes' })
    -- vim.keymap.set('n', '<localleader>tk', function() builtin.keymaps(require("telescope.themes").get_ivy { winblend = 0, border = false,  } ) end, { desc = '[ ] Find keymaps' })
    --
    -- -- spell suggest
    -- vim.keymap.set("n", "z=", function()
    --     builtin.spell_suggest(require("telescope.themes").get_ivy { winblend = 0, border = false,  } )
    -- end, {desc = "TELESCOPE Spell Suggestions"})
    --
    -- -- Slightly advanced example of overriding default behavior and theme
    -- vim.keymap.set('n', '<leader>/', function()
    --     -- You can pass additional configuration to telescope to change theme, layout, etc.
    --     builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    --         winblend = 0,
    --         previewer = false,
    --     })
    -- end, { desc = '[/] Fuzzily search in current buffer' })
    --
    -- -- Also possible to pass additional configuration options.
    -- --  See `:help telescope.builtin.live_grep()` for information about particular keys
    -- vim.keymap.set('n', '<leader>s/', function()
    --     builtin.live_grep {
    --         grep_open_files = true,
    --         prompt_title = 'Live Grep in Open Files',
    --     }
    -- end, { desc = '[S]earch [/] in Open Files' })
    --
    -- -- Shortcut for searching your neovim configuration files
    -- vim.keymap.set('n', '<leader>sn', function()
    --     builtin.find_files { cwd = vim.fn.stdpath 'config' }
    -- end, { desc = '[S]earch [N]eovim files' })
    --
    -- vim.keymap.set("n", "<leader>sst", function()
    --     local config_opts = {} -- optional config for picker
    --     -- example config ->
    --     config_opts = require("telescope.themes").get_ivy{ winblend = 0, border = false,}
    --     require("telescope").extensions["my-telescope-spartan-plugin"].taskwarrior(config_opts)
    -- end)
end

return M
