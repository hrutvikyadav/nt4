local M = {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
}

function M.config()
    require("rose-pine").setup({
        variant = "auto", -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
            terminal = true,
            legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
            migrations = true, -- Handle deprecated options automatically
        },

        styles = {
            bold = true,
            italic = true,
            transparency = false,
        },

        groups = {
            border = "muted",
            link = "iris",
            panel = "surface",

            error = "love",
            hint = "iris",
            info = "foam",
            note = "pine",
            todo = "rose",
            warn = "gold",

            git_add = "foam",
            git_change = "rose",
            git_delete = "love",
            git_dirty = "rose",
            git_ignore = "muted",
            git_merge = "iris",
            git_rename = "pine",
            git_stage = "iris",
            git_text = "rose",
            git_untracked = "subtle",

            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
        },

        highlight_groups = {
            -- Comment = { fg = "foam" },
            -- VertSplit = { fg = "muted", bg = "muted" },
            -- :hi Folded guifg=#e0def4 guibg=#26233a
            Folded = { fg = "text", bg = "overlay" }, -- for better looking UFO folds

            -- rainbow parens + IBL highlights START
            -- Red1 = { fg = "#ffcf00", bold = true, undercurl = true },
            -- Red2 = { fg = "#ff4000", bold = true, undercurl = true },
            -- Red3 = { fg = "#ff8000", bold = true, undercurl = true },
            --
            -- Red4 = { fg = "#ffffff", bg = "#bf4040"},
            -- Red5 = { fg = "#ffffff", bg = "#cc3333"},
            -- Red6 = { fg = "#ffffff", bg = "#d92626"},
            --
            -- SatRand1 = { fg = "#996673", bold = true, undercurl = true },
            -- SatRand2 = { fg = "#736699", bold = true, undercurl = true },
            -- SatRand3 = { fg = "#996699", bold = true, undercurl = true },
            -- rainbow parens + IBL highlights END
        },

        before_highlight = function(group, highlight, palette)
            -- Disable all undercurls
            -- if highlight.undercurl then
            --     highlight.undercurl = false
            -- end
            --
            -- Change palette colour
            -- if highlight.fg == palette.pine then
            --     highlight.fg = palette.foam
            -- end
        end,
    })

    vim.cmd.colorscheme "rose-pine"
    -- vim.cmd("colorscheme rose-pine-main")
    -- vim.cmd("colorscheme rose-pine-moon")
    -- vim.cmd("colorscheme rose-pine-dawn")
end

return M
