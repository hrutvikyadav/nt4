-- https://luals.github.io/wiki/settings/
return {
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
            runtime = {
                version = "LuaJIT",
                special = {
                    spec = "require",
                },
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.stdpath("config") .. "/lua",
                    -- [ "$HOME/.local/share/nvim/lazy/tokyonight.nvim" ] = true , -- INFO: load the types from this plugin
                },
            },
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
