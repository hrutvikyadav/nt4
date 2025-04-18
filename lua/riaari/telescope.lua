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
    },
}

function M.config()

    require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
            ['ui-select'] = {
                require('telescope.themes').get_dropdown(),
            },
            ["my-telescope-spartan-plugin"] = {
                features = {
                    "Task",
                    -- "Time",
                    -- "Bug",
                },
                maps = {
                    -- WARN: disabled for now
                    actions = {
                        task_info = "<C-i>",
                        task_edit = "<C-e>",
                        task_terminal = "<C-t>",
                        task_start = "<C-s>",
                        task_stop = "<C-x>",
                        task_annotate = "<C-a>",
                        tasks_weekly_log = "<C-d>",
                    },
                }
            },

        },
    }


    require("telescope").load_extension("fzf")
    pcall(require("telescope").load_extension, "ui-select")
    require('telescope').load_extension('dap')
    require("telescope").load_extension("my-telescope-spartan-plugin")
    require("telescope").load_extension('harpoon')

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "TELESCOPE [s]earch pwd [f]iles" })
    vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "TELESCOPE git files" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "TELESCOPE live grep pwd files" })

    vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "TELESCOPE [G]it [c]ommits" })
    vim.keymap.set("n", "<leader>g/c", builtin.git_bcommits, { desc = "TELESCOPE [G]it [B]commits" })
    vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "TELESCOPE [G]it [b]ranches" })

    -- from kickstart
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- spell suggest
    vim.keymap.set("n", "z=", builtin.spell_suggest, {desc = "TELESCOPE Spell Suggestions"})

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- Also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
        }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })

    vim.keymap.set("n", "<leader>sst", function()
        local config_opts = {} -- optional config for picker
        -- example config ->
        config_opts = require("telescope.themes").get_ivy{}
        require("telescope").extensions["my-telescope-spartan-plugin"].taskwarrior(config_opts)
    end)
end

return M
