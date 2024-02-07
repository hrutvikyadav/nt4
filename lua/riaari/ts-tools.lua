local M = {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {},
}

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap

	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
	--vim.kbufnr, eymap.set('n', '<leader>D', vim.lsp.buf.type_definition, {buffer = true, desc = 'LSP: type [D]efinition'})
	keymap(bufnr, "n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)

	keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
	keymap(bufnr, "n", "<leader>Ds", "<cmd>Telescope lsp_document_symbols<cr>", opts)
	keymap(bufnr, "n", "<leader>Ws", "<cmd>Telescope lsp_workspace_symbols<cr>", opts)
	-- toggle inlay hints
	keymap(bufnr, "n", "<leader>tlh", "<cmd>lua require('riaari.lspconfig').toggle_inlay_hints()<cr>", opts)
	-- codelens action
	keymap(bufnr, "n", "<leader>tll", "<cmd>lua vim.lsp.codelens.run()<cr>", opts)
end

function M.config()
	require("typescript-tools").setup({
		on_attach = function(client, bufnr)
			lsp_keymaps(bufnr)

			--[[ if client.supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(bufnr, true)
				end ]]
		end,
		settings = {
			publish_diagnostic_on = "insert_leave",
			tsserver_file_preferences = {
				includeInlayParameterNameHints = "none", -- Supported values: 'none', 'literals', 'all'. Default: 'none'
				includeCompletionsForModuleExports = true,
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = false,
				includeInlayVariableTypeHints = false,
				includeInlayVariableTypeHintsWhenTypeMatchesName = false,
				includeInlayPropertyDeclarationTypeHints = false,
				includeInlayFunctionLikeReturnTypeHints = false,
				includeInlayEnumMemberValueHints = false,
				quotePreference = "single",
			},
			-- tsserver_format_options = {
			--     allowIncompleteCompletions = false,
			--     allowRenameOfImportPath = false,
			-- }

			-- CodeLens
			-- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
			-- possible values: ("off"|"all"|"implementations_only"|"references_only")
			code_lens = "off",
			disable_member_code_lens = true,
		},
	})
end

return M
