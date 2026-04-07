-- Only do this when not done yet for this buffer
if vim.b.did_ftplugin then
    print("Avoided loading ftplugin again!")
    return
end

vim.b.did_ftplugin = 1

vim.pack.add({
    {
        src = "https://github.com/obsidian-nvim/obsidian.nvim",
        version = vim.version.range('*')
    }
})

require("riaari.obsidian").config()

vim.bo.commentstring = "<!-- %s -->"

vim.cmd("set conceallevel=2")
vim.cmd("set wrap")

vim.api.nvim_create_user_command("MarkdownView", function ()
    vim.cmd("set conceallevel=3")
    vim.cmd("set concealcursor=nc")
end, {})

vim.api.nvim_create_user_command("MarkdownEdit", function ()
    vim.cmd("set conceallevel=2")
    vim.cmd([[set concealcursor=]])
end, {})
