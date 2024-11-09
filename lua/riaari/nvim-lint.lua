
local M = {
    "mfussenegger/nvim-lint"
}

function M.config()
    local lint = require("lint")

    lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },

    }

    -- INFO: Two ways to use the default linters
    -- 1. Execute on events
    -- local lint_au_group = vim.api.nvim_create_augroup("lint", { clear = true })
    -- local events = { "BufEnter", "BufWritePost", "InsertLeave" }
    -- vim.api.nvim_create_autocmd(events, {
    --     group = lint_au_group,
    --     callback = function()
    --         lint.try_lint()
    --     end,
    -- })

    -- INFO:
    -- 2. Or run manually with keymap
    -- keymap leader v l to lint
    vim.keymap.set("n", "<leader>vl", function()
        print("linting")
        lint.try_lint()
    end)
end

return M
