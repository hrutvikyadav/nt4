local M = {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "nvimdev/lspsaga.nvim",
            config = function()
                require("lspsaga").setup({
                    symbol_in_winbar = {
                        enable = false
                    },
                    lightbulb = {
                        sign = false
                    }
                })
            end,
        },
        "b0o/schemastore.nvim",
        {
            "VidocqH/lsp-lens.nvim",
            enabled = false,
            cmd = "LspLensToggle",
            config = function()
                require("lsp-lens").setup({})
            end,
        },
        -- require("riaari.neoconf")
        { "Hoffs/omnisharp-extended-lsp.nvim" },
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

local navic = require("nvim-navic")

M.on_attach = function(client, bufnr)
    lsp_keymaps(bufnr)

    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    -- nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
    vim.keymap.set({"n", "i"}, "<C-s>", function() vim.lsp.buf.signature_help() end, { buffer = bufnr, desc = "Signature Documentation"})

    nmap("<leader>vrn", vim.lsp.buf.rename, "[R]e[n]ame")
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

    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)

        local winbar_components = {
            -- "%#WinbarFilename#", -- Switch highlight to WinbarFilename
            "%<",                -- Truncates the file path if it becomes too long
            -- "%f",                -- Full file path
            "%{v:lua.Only_filename()}",                --  file name
            -- "%#NavicText#",         -- Switch back to Normal highlight
            " :: ",                 -- Adds a separator
            "%{%v:lua.require'nvim-navic'.get_location()%}", -- from navic readme
        }

        vim.o.winbar = table.concat(winbar_components)
    end

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    -- local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
        })
    end

    -- print(client.name .. " attached")
    if client.name == "omnisharp" then
        local omnisharp_extended = require("omnisharp_extended")
        -- -- replaces vim.lsp.buf.definition()
        -- nnoremap gd <cmd>lua require('omnisharp_extended').lsp_definition()<cr>
        vim.keymap.set("n", "gd", function() omnisharp_extended.lsp_definition() end, { buffer = bufnr, desc = "LSP: [G]oto [D]efinition" })
        -- -- replaces vim.lsp.buf.type_definition()
        -- nnoremap <leader>D <cmd>lua require('omnisharp_extended').lsp_type_definition()<cr>
        vim.keymap.set("n", "gT", function() omnisharp_extended.lsp_type_definition() end, { buffer = bufnr, desc = "LSP: [D]efinition" })
        -- -- replaces vim.lsp.buf.references()
        -- nnoremap gr <cmd>lua require('omnisharp_extended').lsp_references()<cr>
        vim.keymap.set("n", "gr", function() omnisharp_extended.lsp_references() end, { buffer = bufnr, desc = "LSP: [G]oto [R]eferences" })
        -- -- replaces vim.lsp.buf.implementation()
        -- nnoremap gi <cmd>lua require('omnisharp_extended').lsp_implementation()<cr>
        vim.keymap.set("n", "gi", function() omnisharp_extended.lsp_implementation() end, { buffer = bufnr, desc = "LSP: [G]oto [I]mplementation" })
    end

end

function M.common_capabilities()
    local capabilites = vim.lsp.protocol.make_client_capabilities()
    capabilites.textDocument.completion.completionItem.snippetSupport = true

    -- NOTE: experimental
    capabilites = vim.tbl_deep_extend('force', capabilites, require('cmp_nvim_lsp').default_capabilities())
    --
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
        "arduino_language_server",
        "pyright",
        "omnisharp"
    }

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    -- vim.lsp.handlers["textDocument/signatureHelp"] =
    --     vim.lsp.with(vim.lsp.handlers.signatureHelp, { border = "rounded" })
    require("lspconfig.ui.windows").default_options.border = "rounded"

    for _, server in pairs(servers) do
        local signature_help_handler = vim.lsp.handlers["textDocument/signatureHelp"]
        -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        --     signature_help_handler, {
        --         border = "rounded",
        --     }
        -- )

        local opts = {
            on_attach = M.on_attach,
            capabilities = M.common_capabilities(), -- FIXME: the key is capabilities not common_capabilities
            handlers = {
                ["textDocument/signatureHelp"] = vim.lsp.with(
                    signature_help_handler, {
                        border = "rounded",
                    }
                )
            },
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
        --
        if server == "arduino_language_server" then
            print("setting up arduino_language_server")
            opts.cmd = {
                "/home/hrutvik_/go/bin/arduino-language-server",
                "-clangd", "/home/hrutvik_/.local/share/nvim/mason/packages/clangd/clangd_18.1.3/bin/clangd",
                "-cli", "~/.local/bin/arduino-cli",
                "-cli-config", "~/.arduino15/arduino-cli.yaml",
                "-fqbn", "arduino:avr:uno",
            }
            opts.capabilities = {}
            opts.filetypes = { "arduino" }
        end

	if server == "omnisharp" then
		print("setting up omni")
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

sign({ name = "DiagnosticSignError", text = "" })
sign({ name = "DiagnosticSignWarn", text = "" })
sign({ name = "DiagnosticSignHint", text = "" })
sign({ name = "DiagnosticSignInfo", text = "" })
-- work for firacode
--  error = "", "", "", "", "",

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    focusable = true,
    float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
})

return M
