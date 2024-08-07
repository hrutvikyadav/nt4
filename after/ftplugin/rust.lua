-- WARN: Do not set `vim.g.rustaceanvim` in after/ftplugin/rust.lua, as the file is sourced after the plugin is initialized

local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
  "n",
  "<leader>ca",
  function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr }
)

vim.keymap.set(
  "n",
  "K",
  function()
    vim.cmd.RustLsp({ 'hover', 'actions' })
  end,
  { silent = true, buffer = bufnr }
)
