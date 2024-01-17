local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { 'BufReadPre', 'BufNewFile' },
}

function M.config()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "typescript", "rust", "javascript", "html",
        "toml", "tsx", "ocaml" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        --autotag = { enable = true }
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-space>",
                node_incremental = "<C-space>",
                scope_incremental = false,
                node_decremental = "<C-Left>"
            }
        },
    })
    vim.cmd([[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    set nofoldenable                     " Disable folding at startup.
    ]])
end

return M
