return {
    name = "markdown preview",
    builder = function()
        local file = vim.fn.expand("%:p")
        local cmd = { file }
        if vim.bo.filetype == "markdown" then
            cmd = { "glow", file }
        end
        return {
            cmd = cmd,
            description = "Uses glow"
            --[[ components = {
                { "restart_on_save", delay = 200, interrupt = false, paths = { file } }, -- NOTE: handled in MdPreview usercommand for now
                "default",
            }, ]]
        }
    end,
    --[[ condition = {
    filetype = { "sh", "python", "go" },
  }, ]]
}
