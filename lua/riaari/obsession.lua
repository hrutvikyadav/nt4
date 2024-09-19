local M = {
    "tpope/vim-obsession"
}

function M.config()
    local session_file = vim.fn.getcwd() .. "/Session.vim"

    if vim.fn.filereadable(session_file) == 1 then
        print("Session file exists")
    else
        vim.cmd "Obsession"
    end
end

return M
