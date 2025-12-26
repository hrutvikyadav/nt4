return {
    settings = {
        typescript = {
            -- Code Lens preferences
            -- [language].implementationsCodeLens.enabled: boolean;
            -- [language].referencesCodeLens.enabled: boolean;
            -- [language].referencesCodeLens.showOnAllFunctions: boolean;
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true
            },
            -- [language].inlayHints.includeInlayEnumMemberValueHints: boolean;
            -- [language].inlayHints.includeInlayFunctionLikeReturnTypeHints: boolean;
            -- [language].inlayHints.includeInlayFunctionParameterTypeHints: boolean;
            -- [language].inlayHints.includeInlayParameterNameHints: 'none' | 'literals' | 'all';
            -- [language].inlayHints.includeInlayParameterNameHintsWhenArgumentMatchesName: boolean;
            -- [language].inlayHints.includeInlayPropertyDeclarationTypeHints: boolean;
            -- [language].inlayHints.includeInlayVariableTypeHints: boolean;
            -- [language].inlayHints.includeInlayVariableTypeHintsWhenTypeMatchesName: boolean;
            inlayHints = {
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayVariableTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayVariableTypeHints = true,

                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
    }
}
