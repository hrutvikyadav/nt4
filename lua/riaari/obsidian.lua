local M = {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    -- ft = "markdown",
    cmd = "Obsidian",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",

        -- see below for full list of optional dependencies 👇
    },
    --[[ opts = {
            workspaces = {
                {
                    name = "personal",
                    path = "/mnt/c/Users/ArbinLab3/Desktop/Pers/Devlogs/Obsidian/KB",
                    -- "~/vaults/personal"
                },
                { name = "work", path = "/mnt/c/Users/ArbinLab3/Desktop/Pers/Devlogs/Obsidian/Home", },
            },
        }, ]]
}

function M.config()
    require("obsidian").setup({
        workspaces = {
            {
                name = "personal",
                path = "/mnt/c/Users/Admin/Desktop/Pers/Devlogs/Obsidian/KB",
                -- "~/vaults/personal"
            },
            { name = "work", path = "/mnt/c/Users/Admin/Desktop/Pers/Devlogs/Obsidian/Home" },
            { name = "shared-work", path = "/mnt/c/Users/Admin/OneDrive - Arbin Instruments/Arbin India Software Obsidian Vault" }
            --  C:\Users\ArbinLab3\OneDrive - Arbin Instruments\Arbin India Software Obsidian Vault
        },
        ui = {
            -- useful to disable if working with render-markdown nvim
            enable = true,
        },
    })

    vim.keymap.set("n", "<localleader>oi", "<cmd>ObsidianTags index<cr>", {}) -- goto index quickly
    vim.keymap.set("n", "<localleader>ot", "<cmd>ObsidianTags<cr>", {}) -- search tags
    vim.keymap.set("n", "<localleader>os", "<cmd>ObsidianSearch<cr>", {}) -- Create notes quickly and more..
    vim.keymap.set("n", "<localleader>oq", "<cmd>ObsidianQuickSwitch<cr>", {}) -- Switch between notes
    vim.keymap.set("n", "<localleader>orn", function()
        local n = vim.fn.input("NewName> ")
        vim.cmd("ObsidianRename " .. n)
    end, {})
    vim.keymap.set("n", "<localleader>ow", "<cmd>ObsidianWorkspace<cr>", {}) -- switch workspace
    vim.keymap.set("n", "<localleader>ob", "<cmd>ObsidianBacklinks<cr>", {}) -- backlinks

end

return M
