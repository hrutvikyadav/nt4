local M = {
    "pmizio/typescript-tools.nvim",
    event = {
        "BufReadPre *.ts,*.tsx,*.js,*.jsx,*.vue,*.json",
        "BufNewFile *.ts,*.tsx,*.js,*.jsx,*.vue,*.json",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "neovim/nvim-lspconfig",
        {
            "ray-x/lsp_signature.nvim",
            enabled = false,
            event = "VeryLazy",
            opts = {},
            config = function(_, opts)
                require("lsp_signature").setup(opts)
            end,
        },
        --[[ {
            "VidocqH/lsp-lens.nvim",
            cmd = "LspLensToggle",
            config = function()
                require("lsp-lens").setup({})
            end,
        }, ]]
    },
    opts = {},
}

local function lsp_keymaps(bufnr)
    -- print("Setting up keymaps for LSP")
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    --vim.kbufnr, eymap.set('n', '<leader>D', vim.lsp.buf.type_definition, {buffer = true, desc = 'LSP: type [D]efinition'})
    keymap(bufnr, "n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    keymap(bufnr, "n", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)

    keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
    keymap(bufnr, "n", "<leader>Ds", "<cmd>Telescope lsp_document_symbols<cr>", opts)
    keymap(bufnr, "n", "<leader>Ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", opts)
    -- toggle inlay hints
    keymap(bufnr, "n", "<leader>vi", "<cmd>lua require('riaari.lspconfig').toggle_inlay_hints()<cr>", opts)
    -- codelens action
    keymap(bufnr, "n", "<leader>tll", "<cmd>lua vim.lsp.codelens.run()<cr>", opts)
    -- lesser used
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- Create a command `:Format` local to the LSP buffer
    --[[ vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" }) ]]

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", function()
        vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } })
    end, "[C]ode [A]ction")
end

function M.config()
    local signature_help_handler = vim.lsp.handlers["textDocument/signatureHelp"]

    require("typescript-tools").setup({
        on_attach = function(client, bufnr)
            -- print("Attaching to LSP")
            lsp_keymaps(bufnr)

            if client.supports_method("textDocument/inlayHint") then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr} )
            end
            -- require("lsp_signature").on_attach({
            --     bind = true, -- This is mandatory, otherwise border config won't get registered.
            --     handler_opts = {
            --         border = "rounded",
            --     },
            -- }, bufnr)


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
        end,
        settings = {
            publish_diagnostic_on = "insert_leave",
            tsserver_file_preferences = {
                includeInlayParameterNameHints = "all", -- Supported values: 'none', 'literals', 'all'. Default: 'none'
                includeCompletionsForModuleExports = true,
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
                quotePreference = "single",
            },
            -- tsserver_format_options = {
            --     allowIncompleteCompletions = false,
            --     allowRenameOfImportPath = false,
            -- }
            -- Code actions
            -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
            -- "remove_unused_imports"|"organize_imports") -- or string "all"
            -- to include all supported code actions
            -- specify commands exposed as code_actions
            expose_as_code_action = { "fix_all", "add_missing_imports", "remove_unused", "remove_unused_imports", "organize_imports" },

            -- CodeLens
            -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
            -- possible values: ("off"|"all"|"implementations_only"|"references_only")
            code_lens = "off",
            disable_member_code_lens = true,
        },
        handlers = {
            ["textDocument/signatureHelp"] = vim.lsp.with(
                signature_help_handler, {
                    border = "rounded",
                }
            )
        },
    })
end

return M
