local M_git = {
    module = 'blink-cmp-git',
    name = 'Git',
    -- only enable this source when filetype is gitcommit, markdown, or 'octo'
    enabled = function()
        return vim.tbl_contains({ 'octo', 'gitcommit', 'markdown' }, vim.bo.filetype)
    end,
    --- @module 'blink-cmp-git'
    --- @type blink-cmp-git.Options
    opts = {
        commit = {
            -- You may want to customize when it should be enabled
            -- The default will enable this when `git` is found and `cwd` is in a git repository
            -- enable = function() end
            -- You may want to change the triggers
            -- triggers = { ':' },
        },
        git_centers = {
            github = {
                -- Those below have the same fields with `commit`
                -- Those features will be enabled when `git` and `gh` (or `curl`) are found and
                -- remote contains `github.com`
                -- issue = {
                --     get_token = function() return '' end,
                -- },
                -- pull_request = {
                --     get_token = function() return '' end,
                -- },
                -- mention = {
                --     get_token = function() return '' end,
                --     get_documentation = function(item)
                --         local default = require('blink-cmp-git.default.github')
                --             .mention.get_documentation(item)
                --         default.get_token = function() return '' end
                --         return default
                --     end
                -- }
            },
            gitlab = {
                -- Those below have the same fields with `commit`
                -- Those features will be enabled when `git` and `glab` (or `curl`) are found and
                -- remote contains `gitlab.com`
                -- issue = {
                --     get_token = function() return '' end,
                -- },
                -- NOTE:
                -- Even for `gitlab`, you should use `pull_request` rather than`merge_request`
                -- pull_request = {
                --     get_token = function() return '' end,
                -- },
                -- mention = {
                --     get_token = function() return '' end,
                --     get_documentation = function(item)
                --         local default = require('blink-cmp-git.default.gitlab')
                --            .mention.get_documentation(item)
                --         default.get_token = function() return '' end
                --         return default
                --     end
                -- }
            }
        }
    }
}

local M = {
    'saghen/blink.cmp',

    version = "1.*",

    dependencies = {
        "xzbdmw/colorful-menu.nvim",
        {
            'Kaiser-Yang/blink-cmp-git',
        },
        { 'disrupted/blink-cmp-conventional-commits' },
        {
            "L3MON4D3/LuaSnip",
            -- follow latest release.
            version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            --event = 'InsertEnter',
            dependencies = { "rafamadriz/friendly-snippets" },
            config = function()
                local ls = require("luasnip")
                local types = require("luasnip.util.types")
                ls.setup({
                    history = true,
                    -- Update more often, :h events for more info.
                    update_events = "TextChanged,TextChangedI",
                    -- Snippets aren't automatically removed if their text is deleted.
                    -- `delete_check_events` determines on which events (:h events) a check for
                    -- deleted snippets is performed.
                    -- This can be especially useful when `history` is enabled.
                    delete_check_events = "TextChanged",
                    ext_opts = {
                        [types.choiceNode] = {
                            active = {
                                virt_text = { { "choiceNode", "Comment" } },
                            },
                        },
                    },
                    enable_autosnippets = true,
                })

                vim.keymap.set({ "i" }, "<M-e>", function()
                    ls.expand()
                end, { silent = true })
                vim.keymap.set({ "i", "s" }, "<C-L>", function()
                    ls.jump(1)
                end, { silent = true })
                vim.keymap.set({ "i", "s" }, "<C-J>", function()
                    ls.jump(-1)
                end, { silent = true })

                vim.keymap.set({ "i", "s" }, "<M-,>", function()
                    if ls.choice_active() then
                        ls.change_choice(1)
                    end
                end, { silent = true })

                -- custom snippets
                require("riaari.snippets")
            end,
        }, -- Required
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {preset = "default"},

        appearance = {
            nerd_font_variant = 'normal',
        },

        sources = {
            default = {"lazydev", "lsp", "path", "snippets", "buffer", "git", "conventional_commits", },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
                git = M_git,
                conventional_commits = {
                    name = 'Conventional Commits',
                    module = 'blink-cmp-conventional-commits',
                    enabled = function()
                        return vim.bo.filetype == 'gitcommit'
                    end,
                    ---@module 'blink-cmp-conventional-commits'
                    ---@type blink-cmp-conventional-commits.Options
                    opts = {}, -- none so far
                },
            },
        },


        completion = {
            -- NOTE:
            -- completion.menu.auto_show = false -- only show menu on manual <C-space>
            -- completion.ghost_text.show_with_menu = false -- only show when menu is closed
            menu = {
                -- border = 'single',
                -- NOTE: normal
                -- draw = { columns = { { "label", "label_description", gap = 1 }, { "kind_icon", gap = 1 }, { "kind" } }, },
                -- NOTE: with colorful menu plugin
                draw = {
                    -- We don't need label_description now because label and label_description are already
                    -- combined together in label by colorful-menu.nvim.
                    columns = { { "kind_icon" }, { "label", gap = 1 } },
                    components = {
                        label = {
                            text = function(ctx)
                                return require("colorful-menu").blink_components_text(ctx)
                            end,
                            highlight = function(ctx)
                                return require("colorful-menu").blink_components_highlight(ctx)
                            end,
                        },
                    },
                },
                auto_show = false,
            },
            documentation = { auto_show = false },
            ghost_text = {
                enabled = true,
                show_with_menu = false,
            },
        },

        signature = {
            enabled = true,
            -- You may want to set signature.window.show_documentation = false to only show the signature, and not the documentation
        },

        snippets = { preset = "luasnip" },

    },

    opts_extend = {"sources.default"},

}

return M
