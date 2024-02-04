local component = {
    desc = "reload file (:e!) on format done",
    constructor = function(params)
        return {
            on_exit = function(self, task, code)
                --[[ vim.print(self)
                vim.print(task)
                vim.print(code) ]]
                if code == 0 then
                    vim.cmd('e!')
                end
            end
        }
    end
}

return component
