local M = {
    "tpope/vim-obsession"
}

function M.config()
    local session_file = vim.fn.getcwd() .. "/Session.vim"

    if vim.fn.filereadable(session_file) == 1 then
        vim.notify("Session file exists", vim.log.levels.INFO)
    else
        -- vim.cmd "Obsession"
        print("Obsess")
        vim.schedule(function ()
            vim.cmd("Obsession")
        end)
    end
end

return M
