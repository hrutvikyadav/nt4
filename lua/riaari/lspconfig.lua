local M = {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "nvimdev/lspsaga.nvim",
            config = function()
                require("lspsaga").setup({})
            end,
        },
        {
            "VidocqH/lsp-lens.nvim",
            enabled = false,
            cmd = "LspLensToggle",
            config = function()
                require("lsp-lens").setup({})
            end,
        },
        require("riaari.neoconf")
    },
}

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
    keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    --vim.kbufnr, eymap.set('n', '<leader>D', vim.lsp.buf.type_definition, {buffer = true, desc = 'LSP: type [D]efinition'})
    keymap(bufnr, "n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)

    keymap(bufnr, "n", "<leader>Ds", "<cmd>Telescope lsp_document_symbols<cr>", opts)
    keymap(bufnr, "n", "<leader>Ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", opts)
    -- toggle inlay hints
    keymap(bufnr, "n", "<leader>tlh", "<cmd>lua require('riaari.lspconfig').toggle_inlay_hints()<cr>", opts)
    -- codelens action
    keymap(bufnr, "n", "<leader>tll", "<cmd>lua vim.lsp.codelens.run()<cr>", opts)

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
end

M.on_attach = function(client, bufnr)
    lsp_keymaps(bufnr)

    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", function()
        vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } })
    end, "[C]ode [A]ction")

    -- Lesser used LSP functionality
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    if client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr} )
    end

    -- TODO: if client supports signature help, print a message
    if client.supports_method("textDocument/signatureHelp") then
        print("Client supports signature help")
    end
end

function M.common_capabilities()
    local capabilites = vim.lsp.protocol.make_client_capabilities()
    capabilites.textDocument.completion.completionItem.snippetSupport = true

    return capabilites
end

M.toggle_inlay_hints = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
end

function M.config()
    local lspconfig = require("lspconfig")
    -- local icons = require("riaari.icons") TODO: add icons later

    local servers = {
        "lua_ls",
        -- "tsserver", WARN: setup by typescript-tools
        "jsonls",
        "tailwindcss",
        "clangd",
        "gopls",
        "tinymist",
        "nil_ls",
        "ahk2",
    }

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signatureHelp, { border = "rounded" })
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

        -- INFO: needed to setup custom lsp server START
        -- i.e. one which is not listed in lspconfig configurations.md
        if server == "ahk2" then
            print("setting up ahk2")
            local configs = require "lspconfig.configs"
            configs["ahk2"] = { default_config = opts }
        end
        -- custom lsp server END

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

sign({ name = "DiagnosticSignError", text = "" })
sign({ name = "DiagnosticSignWarn", text = "" })
sign({ name = "DiagnosticSignHint", text = "" })
sign({ name = "DiagnosticSignInfo", text = "" })
-- work for firacode
--  error = "", "", "", "", "",

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    focusable = true,
    float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
})

return M
