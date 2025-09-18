
vim.api.nvim_create_autocmd(
    {
        "BufNewFile",
        "BufRead",
    },
    {
        pattern = "*.typ",
        callback = function()
            local buf = vim.api.nvim_get_current_buf()
            -- vim.api.nvim_buf_set_option(buf, "filetype", "typst")
            vim.bo[buf].filetype = "typst"
        end
    }
)

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt.listchars = { tab = '<->', lead = '»', trail = '·', nbsp = '␣' ,multispace = '•', leadmultispace = '»·'}
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    local win = vim.api.nvim_get_current_win()
    local config = vim.api.nvim_win_get_config(win)

    -- Check if it's a floating window (relative ~= "")
    if config.relative ~= "" then
      vim.wo.statusline = " FLOAT "   -- minimal statusline for floats
    elseif vim.bo.buftype == "prompt" then
      vim.wo.statusline = " PROMPT "
    else
      vim.wo.statusline = vim.o.statusline -- restore global statusline
    end
  end,
})
