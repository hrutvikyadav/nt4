--
-- see ../temp.lua
-- TODO: design the public api and extract everything except keymaps into revision_catalyst module
print("catalyse your learning - mainly revision")

local M = {}
M.config = {
    -- Highlight group mapping
    hl_groups = {
        y = 'DiagnosticWarn',
        v = 'DiagnosticHint',
        g = 'DiagnosticInfo',
        r = 'DiagnosticError',
        b = 'Keyword',
    }
}

function M.setup(user_config)
    M.config = vim.tbl_deep_extend("force", M.config, user_config or {})
    local rc = require("revision_catalyst.catalyst")
    HP( rc.build_highlighter(M.config))
    vim.keymap.set('v', '<leader>h', rc.prompt_and_highlight, { desc = 'Highlight visual selection' })
    vim.keymap.set('n', '<localleader>md', rc.prompt_and_remove_highlight, { desc = 'remove a Highlight' })

    vim.keymap.set('n', '<localleader>mp', rc.npersist_highlights, { desc = 'persist highlights' })
    vim.keymap.set('n', '<localleader>ml', rc.nresume_highlights, { desc = 'load highlights' })

end

return M
