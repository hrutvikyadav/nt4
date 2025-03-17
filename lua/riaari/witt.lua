local M = {
    "typed-rocks/witt-neovim",
    -- only load for typescript files and react files
    ft = { "typescript", "typescriptreact" },
    config = function()
        require("witt")
    end
}

return M

