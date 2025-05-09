local M = {
    "williamboman/mason.nvim",
    cmd = "Mason",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        -- "neovim/nvim-lspconfig",
    },
}

function M.config()
    require("mason").setup({
        ui = { border = "rounded" },
    })

    require("mason-lspconfig").setup({
        ensure_installed = {
            -- "tsserver", -- BUG: name changed??
            "eslint",
            "rust_analyzer",
            "lua_ls",
        },
    })
end

return M
