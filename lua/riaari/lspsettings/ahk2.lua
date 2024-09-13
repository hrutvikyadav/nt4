local function custom_attach(client, bufnr)
  require("lsp_signature").on_attach({
    bind = true,
    use_lspsaga = false,
    floating_window = true,
    fix_pos = true,
    hint_enable = true,
    hi_parameter = "Search",
    handler_opts = { "double" },
  })
end

return  {
    autostart = true,
    cmd = {
        "node",
        vim.fn.expand("$HOME/pers/vscode-autohotkey2-lsp/server/dist/server.js"),
        -- pers/vscode-autohotkey2-lsp/server/dist
        "--stdio"
    },
    filetypes = { "ahk", "autohotkey", "ah2" },
    init_options = {
        locale = "en-us",
        InterpreterPath = "/mnt/c/Users/Admin/AppData/Local/Programs/AutoHotkey/v2/AutoHotkey64.exe",
        -- C:\Users\Admin\AppData\Local\Programs\AutoHotkey\v2\AutoHotkey64.exe
        -- Same as initializationOptions for Sublime Text4, convert json literal to lua dictionary literal
    },
    single_file_support = true,
    flags = { debounce_text_changes = 500 },
    -- capabilities = capabilities,
    -- on_attach = custom_attach,
}
