local template_definition = {
    name = "format react.js",
    builder = function()
        -- local files = "src/**/{*.tsx,*.ts} ./*.js"
        -- npx prettier --write src/**/{*.tsx,*.ts} ./*.js
        local file = vim.fn.expand("%:p")
        --
        local cmd = { "npx", "prettier" }
        -- local args = { "--write", "." } -- format all files
        local args = { "--write", file } -- format current file

        return {
            cmd = cmd,
            args = args,
            components = { "format.reload_file", "default" },
        }
    end,
    desc = "with prettier",
    condition = {
        filetype = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    },
}

return template_definition
