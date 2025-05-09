local M = {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    dependencies = {
        "ray-x/lsp_signature.nvim",
        enabled = false,
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            require("lsp_signature").setup(opts)
        end,
    },
}

vim.g.rustaceanvim = {
    server = {
        on_attach = function(client, bufnr)
            -- require("lsp_signature").on_attach({
            --     bind = true, -- This is mandatory, otherwise border config won't get registered.
            --     handler_opts = {
            --         border = "rounded",
            --     },
            -- }, bufnr)

            local opts = { noremap = true, silent = true }
            local keymap = vim.api.nvim_buf_set_keymap
            vim.keymap.set({"n", "i"}, "<C-s>", function() vim.lsp.buf.signature_help() end, { buffer = bufnr, desc = "Signature Documentation"})

            -- toggle inlay hints
            keymap(bufnr, "n", "<leader>vi", "<cmd>lua require('riaari.lspconfig').toggle_inlay_hints()<cr>", opts)
        end,
    },
    dap = {
        autoload_configurations = false,
    },
}

return M
