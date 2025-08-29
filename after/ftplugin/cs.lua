-- after/ftplugin/cs.lua

-- function to return the current solution string
function Roslyn_solution()
  return vim.g.roslyn_nvim_selected_solution or "[no solution]"
end

-- append to existing statusline (use %{} for runtime eval)
vim.opt_local.statusline = vim.opt_local.statusline:get() ..
  " │ %{v:lua.Roslyn_solution()}"

local roslyn_diag_augroup = vim.api.nvim_create_augroup('roslyn_diag_augroup', { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = "*.cs",
    group = roslyn_diag_augroup,
    callback = function()
        print("cs callback was called")
        local clients = vim.lsp.get_clients({ name = "roslyn" })
        if not clients or #clients == 0 then
            return
        end

        local client = assert(vim.lsp.get_client_by_id(clients[1].id))
        local buffers = vim.lsp.get_buffers_by_client_id(clients[1].id)
        for _, buf in ipairs(buffers) do
            local params = { textDocument = vim.lsp.util.make_text_document_params(buf) }
            client:request("textDocument/diagnostic", params, nil, buf)
        end
    end,
})
