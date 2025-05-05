
local M = {
    'kristijanhusak/vim-dadbod-ui',
    cmd = {
        'DBUI',
        'DBUIToggle',
        'DBUIAddConnection',
        'DBUIFindBuffer',
    },
    init = function()
        -- Your DBUI configuration
        vim.g.db_ui_use_nerd_fonts = 1
    end,

    --[[ dependencies = { { 'tpope/vim-dadbod', lazy = true }, { 'kristijanhusak/vim-dadbod-completion', lazy = true }, -- ft = { 'sql', 'mysql', 'plsql' }, 'kristijanhusak/vim-dadbod-completion' }, ]]
    dependencies = {
        {
            'tpope/vim-dadbod',
            -- cmd = 'DadBod',
        },
        {
            'kristijanhusak/vim-dadbod-completion',
            ft = { 'sql', 'mysql', 'plsql' },
            lazy = true
        },
    }
}

return M
