local Job = require("plenary.job")
local M = { "ThePrimeagen/git-worktree.nvim" }

_G.h_git_branch_complete = function (arg_lead)
    local results = {}
    local handle = io.popen("git branch -a --format='%(refname:short)'")
    if handle then
        for line in handle:lines() do
            if line:find(arg_lead, 1, true) then
                table.insert(results, line)
            end
        end
        handle:close()
    end
    return results
end

local function prepare_worktree(branch, callback)
    if not branch or branch == "" then
        print("Error: Branch name required.")
        return
    end

    Job:new({
        command = "git",
        args = { "fetch", "origin" },
        on_exit = function(_, fetch_exit)
            if fetch_exit ~= 0 then
                print("git fetch failed")
                return
            end

            Job:new({
                command = "git",
                args = { "branch", "--track", branch, "origin/" .. branch },
                on_exit = function(_, track_exit)
                    if track_exit == 0 then
                        print("Tracking branch created for " .. branch)
                    else
                        print("Tracking branch may already exist. Continuing...")
                    end
                    if callback then vim.schedule(callback) end
                end,
            }):start()
        end,
    }):start()
end

function M.config()
    local Worktree = require("git-worktree")
    local harpoon = require('harpoon')

    Worktree.setup({
        change_directory_command = "cd", -- default: "cd",
        update_on_change = true, -- default: true,
        update_on_change_command = "e .", -- default: "e .",
        clearjumps_on_change = true, -- default: true,
        autopush = false, -- default: false,
    })

    require("telescope").load_extension("git_worktree")

    vim.keymap.set("n", "<leader>gww", function()
        require("telescope").extensions.git_worktree.git_worktrees()
    end)
    -- <Enter> - switches to that worktree
    -- <c-d> - deletes that worktree
    -- <c-f> - toggles forcing of the next deletion
    vim.keymap.set("n", "<leader>gwc", function()
        local branch = vim.fn.input("Branch name: ", "", "customlist,v:lua.h_git_branch_complete")
        prepare_worktree(branch, function()
            require("telescope").extensions.git_worktree.create_git_worktree()
        end)
    end)

    -- INFO: Hooks
    -- op = Operations.Switch, Operations.Create, Operations.Delete
    -- metadata = table of useful values (structure dependent on op)
    --      Switch
    --          path = path you switched to
    --          prev_path = previous worktree path
    --      Create
    --          path = path where worktree created
    --          branch = branch name
    --          upstream = upstream remote name
    --      Delete
    --          path = path where worktree deleted

    Worktree.on_tree_change(function(op, metadata)
        if op == Worktree.Operations.Switch then
            print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
            vim.schedule(function()
                vim.cmd("Telescope my-telescope-spartan-plugin taskwarrior")
            end)
        end
        if op == Worktree.Operations.Create then
            print("Created worktree at " .. metadata.path .. " for branch " .. metadata.branch)
            -- open harpoon one_off list
            vim.schedule(function() harpoon.ui:toggle_quick_menu(harpoon:list("one_off")) end)
        end
        if op == Worktree.Operations.Delete then
            print("Deleted worktree at " .. metadata.path)
        end
    end)
end

return M
