local M = {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { 'folke/neodev.nvim' },
}

local function lsp_keymaps(bufnr)
    local opts = {noremap = true, silent = true}
    local keymap = vim.api.nvim_buf_set_keymap

    keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    keymap(bufnr, 'n', 'gr', '<cmd>Telescope lsp_references()<cr>', opts)
    keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    keymap(bufnr, 'n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    --vim.kbufnr, eymap.set('n', '<leader>D', vim.lsp.buf.type_definition, {buffer = true, desc = 'LSP: type [D]efinition'})
    keymap(bufnr, 'n', 'gT', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)

    keymap(bufnr, 'n', '<leader>Ds', '<cmd>Telescope lsp_document_symbols<cr>', opts)
    keymap(bufnr, 'n', '<leader>Ws', '<cmd>Telescope lsp_workspace_symbols<cr>', opts)
end

M.on_attach = function(client, bufnr)
    lsp_keymaps(bufnr)

    if client.supports_method "textDocument/inlayHint" then
        vim.lsp.inlay_hint.enable(bufnr, true)
    end
end

function M.common_capabilities()
    local capabilites = vim.lsp.protocol.make_client_capabilities()
    capabilites.textDocument.completion.completionItem.snippetSupport = true

    return capabilites
end

function M.config()
    local lspconfig = require("lspconfig")
    -- local icons = require("riaari.icons") TODO: add icons later

    local servers = {
        "lua_ls",
        "tsserver",
        "jsonls"
    }

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {border ="rounded"})
    require("lspconfig.ui.windows").default_options.border = "rounded"

    for _, server in pairs(servers) do
        local opts = {
            on_attach = M.on_attach,
            common_capabilities = M.common_capabilities(),

        }

        local require_ok, settings = pcall(require, "riaari.lspsettings." .. server)
        if require_ok then
            opts = vim.tbl_deep_extend("force", settings, opts)
        end

        if server == "lua_ls" then
            print"setting up neodev"
            require("neodev").setup({})
        end

        lspconfig[server].setup(opts)
    end
end

-- LSP Diagnostics Options Setup
local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = opts.name,
    })
end

sign({ name = 'DiagnosticSignError', text = "" })
sign({ name = 'DiagnosticSignWarn', text = "" })
sign({ name = 'DiagnosticSignHint', text = "" })
sign({ name = 'DiagnosticSignInfo', text = "" })
-- work for firacode
--  error = "", "", "", "", "",

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    focusable = true,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

return M
