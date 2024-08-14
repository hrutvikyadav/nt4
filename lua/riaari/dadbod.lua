
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
            lazy = true,
            init = function()
                vim.g.vim_dadbod_completion_mark = "[DBOD]"
            end,
            config = function()
                vim.cmd(
                    [[ autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} }) ]]
                )
            end
        }, -- ft = { 'sql', 'mysql', 'plsql' },
    }
}

return M
