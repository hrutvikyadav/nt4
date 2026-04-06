vim.pack.add( {
    --#region CMP
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/xzbdmw/colorful-menu.nvim",
    {
        -- "",
        src = "https://github.com/L3MON4D3/LuaSnip",
        version = vim.version.range('2.5'),
    },
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range('1.10'),
    },
    --#endregion CMP
})

local function luasnip_config()

    -- "L3MON4D3/LuaSnip",
    -- -- follow latest release.
    -- version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- --event = 'InsertEnter',
    -- dependencies = { "rafamadriz/friendly-snippets" },

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
end

local blink_opts = {
    keymap = {preset = "default"},

    appearance = {
        nerd_font_variant = 'normal',
    },

    sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                -- make lazydev completions top priority (see `:h blink.cmp`)
                score_offset = 100,
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

    cmdline = {
        keymap = { preset = 'inherit' },
        completion = { menu = { auto_show = false } },
    },

}

luasnip_config()
require('blink.cmp').setup(blink_opts)
