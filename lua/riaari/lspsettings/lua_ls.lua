-- https://luals.github.io/wiki/settings/
---@type vim.lsp.Config
return {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                },
                special = {
                    spec = "require",
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths
                    -- here.
                    -- '${3rd}/luv/library'
                    -- '${3rd}/busted/library'
                }
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = {
                --   vim.api.nvim_get_runtime_file('', true),
                -- }
            }
        })
    end,

    --#region NO NVIM-LSPCONFIG
    -- Command and arguments to start the server.
    -- cmd = { '/home/c3zbane/.local/share/nvim/mason/bin/lua-language-server' },
    -- Filetypes to automatically attach to.
    -- filetypes = { 'lua' },
    -- Sets the "workspace" to the directory where any of these files is found.
    -- Files that share a root directory will reuse the LSP server connection.
    -- Nested lists indicate equal priority, see |vim.lsp.Config|.
    -- root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    --#endregion NO NVIM-LSPCONFIG
    ---@type lspconfig.settings.lua_ls
    settings = {
        Lua = {
            format = {
                enable = false,
            },
            diagnostics = {
                globals = { "vim", "spec" },
                -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                -- disable = { "missing-fields" },
            },
            -- runtime = {
            --     version = "LuaJIT",
            --     special = {
            --         spec = "require",
            --     },
            -- },
            -- workspace = {
            --     checkThirdParty = false,
            --     library = {
            --         vim.fn.expand("$VIMRUNTIME/lua"),
            --         vim.fn.stdpath("config") .. "/lua",
            --         -- [ "$HOME/.local/share/nvim/lazy/tokyonight.nvim" ] = true , -- INFO: load the types from this plugin
            --     },
            -- },
            hint = {
                enable = true,
                arrayIndex = "Disable", -- "Enable" | "Auto" | "Disable"
                await = true,
                paramName = "All", -- "All" | "Literal" | "Disable"
                paramType = true,
                semicolon = "All", -- "All" | "SameLine" | "Disable"
                setType = true,
            },
            signatureHelp = {
                enable = true,
            },
            codeLens = {
                enable = true,
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
