local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
}

function M.config()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
        ensure_installed = {
            "c",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "typescript",
            "rust",
            "javascript",
            "html",
            "toml",
            "tsx",
            "ocaml",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        --autotag = { enable = true }
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-space>",
                node_incremental = "<C-space>",
                scope_incremental = false,
                node_decremental = "<C-Left>",
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["a="] = { query = "@assignment.outer", desc = "Select around `=` assignment statement" },
                    ["i="] = { query = "@assignment.inner", desc = "Select inside `=` assignment statement" },
                    ["l="] = { query = "@assignment.lhs", desc = "Select Left side `=` assignment statement" },
                    ["r="] = { query = "@assignment.rhs", desc = "Select Right side `=` assignment statement" },

                    ["aa"] = { query = "@parameter.outer", desc = "Select around Function Args/Params" },
                    ["ia"] = { query = "@parameter.inner", desc = "Select inside Function Args/Params" },

                    ["a/"] = { query = "@conditional.outer", desc = "Select around conditional" },
                    ["i/"] = { query = "@conditional.inner", desc = "Select inside conditional" },

                    ["al"] = { query = "@loop.outer", desc = "Select around loop" },
                    ["il"] = { query = "@loop.inner", desc = "Select inside loop" },

                    ["af"] = { query = "@call.outer", desc = "Select around Function call" },
                    ["if"] = { query = "@call.inner", desc = "Select inside Function call" },

                    ["am"] = { query = "@function.outer", desc = "Select around Function definition" },
                    ["im"] = { query = "@function.inner", desc = "Select inside Function definition" },

                    ["ac"] = { query = "@class.outer", desc = "Select around class" },
                    ["ic"] = { query = "@class.inner", desc = "Select inside class" },
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>Tna"] = "@parameter.inner", -- swap param with next one
                    ["<leader>Tnm"] = "@function.outer", -- swap function with next one
                    ["<leader>Tnf"] = { query = "@call.outer", desc = "swap with next function call" },
                },
                swap_previous = {
                    ["<leader>Tpa"] = "@parameter.inner", -- swap param with prev one
                    ["<leader>Tpm"] = "@function.outer", -- swap function with prev one
                    ["<leader>Tpf"] = { query = "@call.outer", desc = "swap with prev function call" },
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]f"] = { query = "@call.outer", desc = "Goto Next function Call Start" },
                    ["]m"] = { query = "@function.outer", desc = "Goto Next Class Start" },
                    ["]["] = { query = "@class.outer", desc = "Next class start" },
                    --
                    -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
                    ["]l"] = { query = "@loop.*", desc = "Goto Next Loop Start" },
                    -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
                    --
                    -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                    -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                    ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                    ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                    --
                    ["]o"] = { query = "@comment.outer", desc = "Goto Next Comment start" },
                },
                goto_next_end = {
                    ["]F"] = { query = "@call.outer", desc = "Goto Next function Call End" },
                    ["]M"] = { query = "@function.outer", desc = "Goto Next Class End" },
                    ["]]"] = { query = "@class.outer", desc = "Next class End" },
                    ["]L"] = { query = "@loop.*", desc = "Goto Next Loop End" },
                    ["]O"] = { query = "@comment.outer", "Goto Next Comment end" },
                },
                goto_previous_start = {
                    ["[f"] = { query = "@call.outer", desc = "Goto Prev function Call Start" },
                    ["[m"] = "@function.outer",
                    ["[["] = { query = "@class.outer", desc = "Prev class start" },
                    ["[l"] = { query = "@loop.*", desc = "Goto Prev Loop Start" },
                    ["[o"] = { query = "@comment.outer", "Goto Prev Comment start" },
                },
                goto_previous_end = {
                    ["[F"] = { query = "@call.outer", desc = "Goto Prev function Call End" },
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                    ["[L"] = { query = "@loop.*", desc = "Goto Prev Loop End" },
                    ["[O"] = { query = "@comment.outer", "Goto Prev Comment end" },
                },
                -- Below will go to either the start or the end, whichever is closer.
                -- Use if you want more granular movements
                -- Make it even more gradual by adding multiple queries and regex.
                goto_next = {
                    ["]/"] = "@conditional.outer",
                },
                goto_previous = {
                    ["[/"] = "@conditional.outer",
                },
            },
            lsp_interop = {
                enable = true,
                border = "none",
                floating_preview_opts = {},
                peek_definition_code = {
                    ["<leader>TPf"] = "@function.outer",
                    ["<leader>TPF"] = "@class.outer",
                },
            },
        },
    })

    vim.cmd([[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    set nofoldenable                     " Disable folding at startup.
    ]])

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    -- Repeat movement with ; and ,
    -- ensure ; goes forward and , goes backward regardless of the last direction
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

    -- vim way: ; goes to the direction you were moving.
    -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
end

return M
