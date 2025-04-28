
return {
    settings = {
        gopls = {
            ["ui.inlayhints.hints"] = {
                compositeLiteralFields = true,
                constantValues = true,
                parameterNames = true
            },
            ["ui.codelenses"] = {
                -- gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = false,
                tidy = true,
                upgrade_dependency = true,
                vendor = true
            },

        }
    }
}
