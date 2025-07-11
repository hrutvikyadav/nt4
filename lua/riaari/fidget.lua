local M = {
    "j-hui/fidget.nvim",
    enabled = false
}

function M.config()
    require("fidget").setup({})
end

return M
