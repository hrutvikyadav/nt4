local M = {}

vim.pack.add({
    --#region LSP
    "https://github.com/SmiteshP/nvim-navic",
    "https://github.com/j-hui/fidget.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/folke/lazydev.nvim",
    --#endregion LSP
})

-- vim.lsp.config["lua_ls"] = require("riaari.lspsettings.lua_ls")
-- vim.lsp.config("lua_ls", require("riaari.lspsettings.lua_ls"))
-- vim.lsp.enable("lua_ls")

function M.lsp_keymaps(bufnr)
-- - "gra" (Normal and Visual mode) is mapped to |vim.lsp.buf.code_action()|
-- - "gri" is mapped to |vim.lsp.buf.implementation()|
-- - "grn" is mapped to |vim.lsp.buf.rename()|
-- - "grr" is mapped to |vim.lsp.buf.references()|
-- - "grt" is mapped to |vim.lsp.buf.type_definition()|
-- - "grx" is mapped to |vim.lsp.codelens.run()|
-- - "gO" is mapped to |vim.lsp.buf.document_symbol()|
-- - CTRL-S (Insert mode) is mapped to |vim.lsp.buf.signature_help()|
-- - |v_an| and |v_in| fall back to LSP |vim.lsp.buf.selection_range()| if
--   treesitter is not active.
-- - |gx| handles `textDocument/documentLink`. Example: with gopls, invoking gx
--   on "os" in this Go code will open documentation externally: >
--     package nvim 
--     import ( "os")

-- BUFFER-LOCAL DEFAULTS
--
-- - 'omnifunc' is set to |vim.lsp.omnifunc()|, use |i_CTRL-X_CTRL-O| to trigger
--   completion.
-- - 'tagfunc' is set to |vim.lsp.tagfunc()|. This enables features like
--   go-to-definition, |:tjump|, and keymaps like |CTRL-]|, |CTRL-W_]|,
--   |CTRL-W_}| to utilize the language server.
-- - 'formatexpr' is set to |vim.lsp.formatexpr()|, so you can format lines via
--   |gq| if the language server supports it.
--   - To opt out of this use |gw| instead of gq, or clear 'formatexpr' on |LspAttach|.
-- - |K| is mapped to |vim.lsp.buf.hover()| unless 'keywordprg' is customized or
--   a custom keymap for `K` exists.
-- - Document colors are enabled for highlighting color references in a document.
--   - To opt out call `vim.lsp.document_color.enable(false, { bufnr = ev.buf })` on |LspAttach|.
--
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    keymap(bufnr, "n", "gr", "<cmd>lua Snacks.picker.lsp_references()<cr>", opts)
    keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    --vim.kbufnr, eymap.set('n', '<leader>D', vim.lsp.buf.type_definition, {buffer = true, desc = 'LSP: type [D]efinition'})
    keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)

    keymap(bufnr, "n", "<leader>Ds", "<cmd>lua Snacks.picker.lsp_symbols()<cr>", opts)
    keymap(bufnr, "n", "<leader>Ws", "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>", opts)

    -- toggle inlay hints
    vim.keymap.set("n",  "<leader>vi", function()
        require("riaari.mylspconfig").toggle_inlay_hints()
    end)

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })

    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    -- nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
    vim.keymap.set({"n"}, "<C-s>", function() vim.lsp.buf.signature_help() end, { buffer = bufnr, desc = "Signature Documentation"})

    nmap("<leader>ca", function()
        vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } })
    end, "[C]ode [A]ction")

    -- Lesser used LSP functionality
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- vim.keymap.set("n", "<leader>vce", vim.lsp.codelens.refresh, { desc = "Vim CodeLens Enable" })
    -- vim.keymap.set("n", "<leader>vcd", vim.lsp.codelens.clear, { desc = "Vim CodeLens Disable" })
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

        -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
        -- if client:supports_method('textDocument/completion') then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
            -- client.server_capabilities.completionProvider.triggerCharacters = chars

            -- vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = false})
        -- end

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        -- if not client:supports_method('textDocument/willSaveWaitUntil')
        --     and client:supports_method('textDocument/formatting') then
        --     vim.api.nvim_create_autocmd('BufWritePre', {
        --         group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
        --         buffer = ev.buf,
        --         callback = function()
        --             vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        --         end,
        --     })
        -- end
        M.lsp_keymaps(ev.buf)

        vim.lsp.document_color.enable(true, { bufnr = ev.buf }, { style='virtual'})

        if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf } )
        end

        -- TODO: if client supports signature help, print a message
        if client:supports_method("textDocument/signatureHelp") then
            vim.notify("Client supports signature help", vim.log.levels.INFO)
        end

        local navic = require("nvim-navic")
        if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, ev.buf)

            local winbar_components = {
                -- "%#WinbarFilename#", -- Switch highlight to WinbarFilename
                -- "%<",                -- Truncates the file path if it becomes too long
                -- "%f",                -- Full file path
                -- "%{v:lua.Only_filename()}",                --  file name
                -- "%#NavicText#",         -- Switch back to Normal highlight
                -- " :: ",                 -- Adds a separator
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
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = ev.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = ev.buf,
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

        print(client.name .. " attached")
        -- if client.name == "omnisharp" then
        --     local omnisharp_extended = require("omnisharp_extended")
        --     -- -- replaces vim.lsp.buf.definition()
        --     -- nnoremap gd <cmd>lua require('omnisharp_extended').lsp_definition()<cr>
        --     vim.keymap.set("n", "gd", function() omnisharp_extended.lsp_definition() end, { buffer = bufnr, desc = "LSP: [G]oto [D]efinition" })
        --     -- -- replaces vim.lsp.buf.type_definition()
        --     -- nnoremap <leader>D <cmd>lua require('omnisharp_extended').lsp_type_definition()<cr>
        --     vim.keymap.set("n", "gT", function() omnisharp_extended.lsp_type_definition() end, { buffer = bufnr, desc = "LSP: [D]efinition" })
        --     -- -- replaces vim.lsp.buf.references()
        --     -- nnoremap gr <cmd>lua require('omnisharp_extended').lsp_references()<cr>
        --     vim.keymap.set("n", "gr", function() omnisharp_extended.lsp_references() end, { buffer = bufnr, desc = "LSP: [G]oto [R]eferences" })
        --     -- -- replaces vim.lsp.buf.implementation()
        --     -- nnoremap gi <cmd>lua require('omnisharp_extended').lsp_implementation()<cr>
        --     vim.keymap.set("n", "gi", function() omnisharp_extended.lsp_implementation() end, { buffer = bufnr, desc = "LSP: [G]oto [I]mplementation" })
        -- end

        -- if client.name == "ruby_lsp" then
            -- add_ruby_deps_command(client, bufnr)
        -- end
    end,
})


function M.lsp_config()
    local servers = {
        "lua_ls",
        "ts_ls", -- "tsserver", WARN: setup by typescript-tools
        "jsonls",
        -- "tailwindcss",
        "clangd",
        "gopls",
        "tinymist",
        "nil_ls",
        "ahk2",
        "arduino_language_server",
        "basedpyright",
        -- "omnisharp",
        "roslyn",
        "harper_ls",
        "jdtls",
        "rust_analyzer",
        "ruby_lsp"
    }

    for _, server in pairs(servers) do

        local opts = {
            -- capabilities = Hlspconfig.common_capabilities(), -- FIXME: the key is capabilities not common_capabilities
        }

        vim.lsp.config('*', opts)

        local require_ok, settings = pcall(require, "riaari.lspsettings." .. server)
        if require_ok then
            opts = vim.tbl_deep_extend("force", settings, opts)
        end

        if server == "omnisharp" then
            -- print("setting up omni")
        end

        local my_roslyn = {
            ["csharp|inlay_hints"] = {
                -- csharp_enable_inlay_hints_for_implicit_object_creation = true,
                -- csharp_enable_inlay_hints_for_implicit_variable_types = true,
                dotnet_enable_inlay_hints_for_literal_parameters = true,
                dotnet_enable_inlay_hints_for_indexer_parameters = true,
                dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                dotnet_enable_inlay_hints_for_other_parameters = true,
                dotnet_enable_inlay_hints_for_parameters = true,
                csharp_enable_inlay_hints_for_types = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                csharp_enable_inlay_hints_for_implicit_object_creation = true,

            },
            ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = true,
                dotnet_enable_tests_code_lens = true,
            },
            -- csharp|symbol_search.dotnet_search_reference_assemblies
            -- csharp|background_analysis.dotnet_analyzer_diagnostics_scope
            -- csharp|background_analysis.dotnet_compiler_diagnostics_scope
            ["csharp|symbol_search"] = {
                dotnet_search_reference_assemblies = true
            },
            ["csharp|background_analysis"] = {
                dotnet_analyzer_diagnostics_scope = "fullSolution",
                dotnet_compiler_diagnostics_scope = "fullSolution",
            }
        }

        if server == "roslyn" then
            vim.lsp.config("roslyn", {
                -- on_attach = M.on_attach, replaced by autocommand
                -- capabilities = M.common_capabilities(),
                settings = {
                    ["csharp|background_analysis"] = {
                        dotnet_analyzer_diagnostics_scope = "fullSolution",
                        dotnet_compiler_diagnostics_scope = "fullSolution"
                    },
                    ["csharp|code_lens"] = {
                        dotnet_enable_references_code_lens = true
                    },
                    ["csharp|completion"] = {
                        dotnet_provide_regex_completions = true,
                        dotnet_show_completion_items_from_unimported_namespaces = true,
                        dotnet_show_name_completion_suggestions = true
                    },
                    ["csharp|inlay_hints"] = {
                        csharp_enable_inlay_hints_for_implicit_object_creation = true,
                        csharp_enable_inlay_hints_for_implicit_variable_types = true,
                        csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                        csharp_enable_inlay_hints_for_types = true,
                        dotnet_enable_inlay_hints_for_indexer_parameters = true,
                        dotnet_enable_inlay_hints_for_literal_parameters = true,
                        dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                        dotnet_enable_inlay_hints_for_other_parameters = true,
                        dotnet_enable_inlay_hints_for_parameters = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true
                    },
                    ["csharp|symbol_search"] = {
                        dotnet_search_reference_assemblies = true
                    }
                }
            })
        else
            vim.lsp.config(server, opts)
            vim.lsp.enable(server)
        end
    end
end

return M
