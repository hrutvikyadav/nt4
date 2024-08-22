local M = {
    'barrett-ruth/import-cost.nvim',
    -- only load on javascript and typescript files or react files
    ft = {'javascript', 'typescript', 'javascriptreact', 'typescriptreact'},
    build = 'sh install.sh npm',
    -- if on windows
    -- build = 'pwsh install.ps1 yarn',
    config = true
}

return M
