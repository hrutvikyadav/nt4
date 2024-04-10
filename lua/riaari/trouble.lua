local M = {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "TroubleToggle",
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
}

function M.config()
    require("trouble").setup({})

    -- Lua
    vim.keymap.set("n", "<leader>xx", function()
        require("trouble").open()
    end)
    vim.keymap.set("n", "<leader>xw", function()
        require("trouble").open("workspace_diagnostics")
    end)
    vim.keymap.set("n", "<leader>xd", function()
        require("trouble").open("document_diagnostics")
    end)
    vim.keymap.set("n", "<leader>xq", function()
        require("trouble").open("quickfix")
    end)
    vim.keymap.set("n", "<leader>xl", function()
        require("trouble").open("loclist")
    end)
    -- :Trouble lsp_references
    -- vim.keyma.set("n", "gR", function() require("trouble").open("lsp_references") end)
    vim.keymap.set("n", "<leader>xn", function()
        require("trouble").next({ skip_groups = true, jump = true })
    end)
    vim.keymap.set("n", "<leader>xp", function()
        require("trouble").previous({ skip_groups = true, jump = true })
    end)
    vim.keymap.set("n", "<leader>x1", function()
        require("trouble").first({ skip_groups = true, jump = true })
    end)
    vim.keymap.set("n", "<leader>x0", function()
        require("trouble").last({ skip_groups = true, jump = true })
    end)
end

return M
