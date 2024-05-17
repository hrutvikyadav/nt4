local M = {
    'maxmx03/fluoromachine.nvim',
    config = function ()
        local fm = require 'fluoromachine'

        fm.setup {
            glow = true,
            theme = 'fluoromachine', -- fluoromachine, retrowave, delta
            transparent = "full" -- "full"
        }

        vim.cmd.colorscheme 'fluoromachine'
        vim.cmd([[set cursorline]])
    end
}

return M
