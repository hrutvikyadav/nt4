local M = {
    "the-coding-doggo/batman.nvim",
}

function M.config()
    require('batman').setup({
        -- Theme selection
        theme = "nolan", -- Default theme theme will go back to this theme when running :BatmanRestore
        randomizer = false, -- Randomize theme on every startup
        use_persistence = true, -- Persist themes Picked with :Batman [theme] or :BatmanPreview"

        -- Background options
        transparent_background = false, -- Enable transparent background

        -- Style overrides

        -- Syntax highlighting styles
        styles = {
            comments = { "italic" },
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = { "bold" },
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
        },

        -- LSP styling
        lsp_styles = {
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
                ok = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
                ok = { "underline" },
            },
            inlay_hints = {
                background = true,
            },
        },

        -- LSP Semantic Token Support
        lsp = {
            enabled = true, -- Enable LSP semantic token support
            semantic_tokens = true, -- Enable semantic token highlighting
            diagnostics = true, -- Enable LSP diagnostics styling
            custom_colors = {}, -- Custom semantic token color overrides
            semantic_token_types = {
                -- Enable/disable specific semantic token types
                variable = true,
                ["function"] = true,
                type = true,
                method = true,
                ["keyword"] = true,
                operator = true,
                string = true,
            },
        },

        -- Color customization
        color_overrides = {}, -- Override specific colors
        custom_highlights = {}, -- Custom highlight groups

        -- Filetype-specific themes
        theme_per_file_type = {
            python = "joker_night",    -- Joker theme for Python files
            javascript = "future",     -- Cyberpunk theme for JavaScript
            markdown = "classic",      -- Classic theme for Markdown
            lua = "arkham",           -- Arkham theme for Lua files
        },
    })

    -- vim.cmd("colorscheme )
end

return M

