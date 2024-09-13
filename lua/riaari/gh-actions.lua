local M = {
    'topaxi/gh-actions.nvim',
    keys = {
        { '<leader>ga', '<cmd>GhActions<cr>', desc = 'Open Github Actions' },
    },
    -- optional, you can also install and use `yq` instead.
    -- build = 'make',
    ---@type GhActionsConfig
    opts = {},
}

return M
