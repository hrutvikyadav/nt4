local M = { "ThePrimeagen/git-worktree.nvim" }

function M.config()
    require("git-worktree").setup({
        change_directory_command = "cd", -- default: "cd",
        update_on_change = true, -- default: true,
        update_on_change_command = "e .", -- default: "e .",
        clearjumps_on_change = true, -- default: true,
        autopush = false, -- default: false,
    })

    require("telescope").load_extension("git_worktree")

    vim.keymap.set("n", "<leader>Gww", function()
        require("telescope").extensions.git_worktree.git_worktrees()
    end)
    -- <Enter> - switches to that worktree
    -- <c-d> - deletes that worktree
    -- <c-f> - toggles forcing of the next deletion
    vim.keymap.set("n", "<leader>Gwc", function()
        require("telescope").extensions.git_worktree.create_git_worktree()
    end)
end

return M
