local M = {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
        broad_search = true,
        choose_target = function(target)
        return vim.iter(target):find(function(item)
            if string.match(item, "DAS.sln") then
                return item
            end
        end)
    end
    },
}

return M
