local M = {
    "hrsh7th/nvim-cmp", -- Autocompletion
    event = "InsertEnter",
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp" }, -- Required
        -- from rust setup
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-buffer" },
        {
            "petertriho/cmp-git",
            dependencies = "nvim-lua/plenary.nvim",
            ft = "gitcommit",
            config = function()
                require("cmp_git").setup() -- needed?
            end,
        },
        -- engine
        {
            "L3MON4D3/LuaSnip",
            -- follow latest release.
            version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            --event = 'InsertEnter',
            dependencies = { "rafamadriz/friendly-snippets" },
            build = (function()
                -- Build Step is needed for regex support in snippets
                -- This step is not supported in many windows environments
                -- Remove the below condition to re-enable on windows
                if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                    return
                end
                return 'make install_jsregexp'
            end)(),

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

                vim.keymap.set({ "i" }, "<C-K>", function()
                    ls.expand()
                    end, { silent = true })
                vim.keymap.set({ "i", "s" }, "<C-L>", function()
                    ls.jump(1)
                    end, { silent = true })
                vim.keymap.set({ "i", "s" }, "<C-J>", function()
                    ls.jump(-1)
                    end, { silent = true })

                vim.keymap.set({ "i", "s" }, "<C-E>", function()
                    if ls.choice_active() then
                    ls.change_choice(1)
                    end
                    end, { silent = true })

                -- custom snippets
                require("riaari.snippets")
            end,
        }, -- Required
        {
            "roobert/tailwindcss-colorizer-cmp.nvim",
            ft = { "html", "javascriptreact", "typescriptreact" },
            -- optionally, override the default options:
            config = function()
                require("tailwindcss-colorizer-cmp").setup({
                    color_square_width = 2,
                })
            end,
        },
    },
}

function M.config()
    require("luasnip.loaders.from_vscode").lazy_load()

    local kind_icons = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
    }

    local cmp = require("cmp")
    local luasnip = require("luasnip")
    --local cmp_action = require('lsp-zero').cmp_action()
    local cmp_select_opts = { behaviour = cmp.SelectBehavior.Select }

    local check_backspace = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
    end

    cmp.setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        sources = {
            { name = "cody" },
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "nvim_lsp_signature_help" },
            { name = "luasnip" },
            { name = "buffer", keyword_length = 4, max_item_count = 8 },
            { name = "path" },
            --{ name = 'neorg' },
        },
        mapping = {
            ["<C-l>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
            ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
            --["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
            --["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
            ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<C-e>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ["<C-y>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expandable() then
                luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif check_backspace() then
                    fallback()
                    -- require("neotab").tabout()
                else
                    fallback()
                    -- require("neotab").tabout()
                end
                end, {
                    "i",
                    "s",
            }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
                else
                    fallback()
                end
                end, {
                    "i",
                    "s",
            }),
            --[[
            -- from original
            --
            ['<Tab>'] = cmp_action.luasnip_supertab(),
            ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
            --['<Up>'] = cmp.mapping.select_prev_item(cmp_select_opts),
            --['<Down>'] = cmp.mapping.select_next_item(cmp_select_opts),
            ['<C-p>'] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.select_prev_item(cmp_select_opts)
                else
                    cmp.complete()
                end
            end),
            ['<C-n>'] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.select_next_item(cmp_select_opts)
                else
                    cmp.complete()
                end
            end),
            --]]
        },
        completion = {
            autocomplete = false,
        },
        confirm_opts = {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        formatting = {
            -- changing the order of fields so the icon is the first
            fields = { "abbr", "kind", "menu" },

            -- here is where the change happens
            format = function(entry, item)
                item.kind = string.format("%s %s", kind_icons[item.kind], item.kind) -- This concatonates the icons with the name of the item kind

                local menu_icon = {
                    nvim_lsp = "λ",
                    luasnip = "⋗",
                    buffer = "Ω",
                    path = "🖫",
                    nvim_lua = "Π",
                    git = "",
                }
                item.menu = menu_icon[entry.source.name]
                return require("tailwindcss-colorizer-cmp").formatter(entry, item)
            end,
            expandable_indicator = true,
        },
        experimental = {
            ghost_text = true,
        },
    })

    -- autopairs integration
    -- If you want insert `(` after select function or method item
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
            { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
        }),
    })
end

return M
