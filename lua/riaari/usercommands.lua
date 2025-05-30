vim.api.nvim_create_user_command("EditorSupport", function()
    -- hi Whitespace guifg=#CC0000 highlight spaces from listchars -- NOTE: linked to NonText by default;; with IBL off, this can be changed to modify colors of listchars
    -- for darkplus ->
    vim.cmd("hi Whitespace guifg=#1e1e1e")
    -- hi OnlySpaces guibg=#CC0000-- hl for lines with only spaces and trailing spaces
    vim.api.nvim_set_hl(0, "OnlySpaces", { bg = "#CC0000" })
    -- match OnlySpaces /\s\+$/
    -- highlight rightMargin guibg=#eb6f92 guifg=#21202e
    vim.api.nvim_set_hl(0, "rightMargin", { bg = "#eb6f92", fg = "#21202e", blend = 90 })
    -- 3match rightMargin /.\%>81v/
    vim.cmd([[
        match OnlySpaces /\s\+$/
        set list!
        IBLToggle
        IBLToggle
    ]])
end, {})

function HP(obj)
    print(vim.inspect(obj))
end
