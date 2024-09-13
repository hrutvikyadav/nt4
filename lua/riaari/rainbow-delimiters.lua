local M = {
    "HiPhish/rainbow-delimiters.nvim",
    -- only load on filetype markdown and ocaml or on cmd Rainbowz
    -- ft = { "markdown", "ocaml" },
    -- cmd = "Rainbowz",
}

function M.config()
    local rainbow_delimiters = require 'rainbow-delimiters'

    require('rainbow-delimiters.setup').setup({
        strategy = {
            [''] = rainbow_delimiters.strategy['global'],
            vim = rainbow_delimiters.strategy['local'],
        },
        query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
        },
        priority = {
            [''] = 110,
            lua = 210,
        },
        highlight = {
            -- 'RainbowDelimiterRed',
            -- 'RainbowDelimiterYellow',
            -- 'RainbowDelimiterBlue',
            -- 'RainbowDelimiterOrange',
            -- 'RainbowDelimiterGreen',
            -- 'RainbowDelimiterViolet',
            -- 'RainbowDelimiterCyan',
            -- 'Red1',
            -- 'Red2',
            -- 'Red3',
            -- 'Red4',
            -- 'Red5',
            -- 'Red6',
            'SatRand1',
            'SatRand2',
            'SatRand3',
        },
    })
end

return M
