local M = {
    'echasnovski/mini.hipatterns',
    version = false,
    enabled = false
}

function M.config()
    local hipatterns = require('mini.hipatterns')
    hipatterns.setup({
        highlighters = {
            -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            -- fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
            -- hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
            -- todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
            -- note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },

            -- Highlight hex color strings (`#rrggbb`) using that color
            hex_color = hipatterns.gen_highlighter.hex_color(),

            issue_status_todo = {
                pattern = '%f[%w]To Do%f[%W]',
                group = 'MiniHipatternsTodo', -- You can also define your own group
            },
            issue_status_inprogress = {
                pattern = '%f[%w]In Progress%f[%W]',
                group = 'MiniHipatternsHack',
            },
            issue_status_blocked = {
                pattern = '%f[%w]Blocked%f[%W]',
                group = 'MiniHipatternsFixme',
            },
            issue_status_onhold = {
                pattern = '%f[%w]OnHold%f[%W]',
                group = 'MiniHipatternsFixme',
            },
        },
    })
end

local N = {
    "folke/paint.nvim",
    config = function()
        -----------------------------------------------------------------------
        --- Rose pine pallete start
        -----------------------------------------------------------------------
        -- vim.api.nvim_set_hl(0, "PaintTodo", {
        --     -- fg = "#eb6f92", -- love
        --     -- fg = "#c4a7e7", -- iris
        --     fg = "#ebbcba", -- rose
        --     bg = "#1f1d2e", -- base
        --     italic = true
        -- })
        --
        -- vim.api.nvim_set_hl(0, "PaintInProgress", {
        --     -- fg = "#f6c177", -- gold
        --     fg = "#31748f", -- pine
        --     bg = "#1f1d2e", -- base
        --     italic = true
        -- })
        --
        -- vim.api.nvim_set_hl(0, "PaintBlocked", {
        --     -- fg = "#ebbcba", -- rose
        --     fg = "#eb6f92", -- love
        --     bg = "#1f1d2e", -- base
        --     bold = true,
        --     italic = true,
        --     underline = true
        -- })
        --
        -- vim.api.nvim_set_hl(0, "PaintOnHold", {
        --     -- fg = "#9ccfd8", -- foam
        --     fg = "#eb6f92", -- love
        --     bg = "#1f1d2e", -- base
        --     bold = true,
        --     underline = true
        -- })
        -----------------------------------------------------------------------
        --- Rose pine pallete end
        -----------------------------------------------------------------------

        -----------------------------------------------------------------------
        --- Rose pine dawn pallete start
        -----------------------------------------------------------------------

        vim.api.nvim_set_hl(0, "PaintTodo", {
            bg = "#575279", -- text
            fg = "#f2e9e1", -- surface
            bold = true,
        })

        vim.api.nvim_set_hl(0, "PaintInProgress", {
            bg = "#286983", -- pine
            fg = "#f2e9e1", -- surface
            bold = true,
        })

        vim.api.nvim_set_hl(0, "PaintBlocked", {
            bg = "#b4637a", -- rose
            fg = "#f2e9e1", -- surface
            italic = true,
            bold = true,
            underline = true,
        })

        vim.api.nvim_set_hl(0, "PaintOnHold", {
            bg = "#b4637a", -- foam
            fg = "#f2e9e1", -- surface
            bold = true,
            italic = true,
        })
        -----------------------------------------------------------------------
        --- Rose pine dawn pallete end
        -----------------------------------------------------------------------

        require("paint").setup({
            ---@type PaintHighlight[]
            highlights = {
                {
                    -- filter can be a table of buffer options that should match,
                    -- or a function called with buf as param that should return true.
                    -- The example below will paint @something in comments with Constant
                    -- filter = { filetype = "lua" },
                    filter = function(buf)
                        return true
                    end,
                    pattern = '%f[%w]To Do%f[%W]',
                    hl = "PaintTodo",
                },
                {
                    filter = function(buf)
                        return true
                    end,
                    pattern = '%f[%w]In Progress%f[%W]',
                    hl = "PaintInProgress",
                },
                {
                    filter = function(buf)
                        return true
                    end,
                    pattern = '%f[%w]Blocked%f[%W]',
                    hl = "PaintBlocked",
                },
                {
                    filter = function(buf)
                        return true
                    end,
                    pattern = '%f[%w]OnHold%f[%W]',
                    hl = "PaintOnHold",
                }
            },
        })
    end,
}

return N
