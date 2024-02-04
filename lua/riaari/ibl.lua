local M = {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	cmd = "IBLToggle",
}

function M.config()
	require("ibl").setup({
		-- char = '┊', `┋`,  `▏`, `│`
		indent = { char = "│", highlight = "Comment" },
		--[[ indent = {
                char = "│",
                priority = 2,
            }, ]]
		-- whitespace = { highlight = { "DiagnosticError", "NonText" } },
		-- whitespace = { highlight = { "IndentGuideLight", "IndentGuideLight2", "IndentGuideDark" } }, -- Suited for light bg
		-- whitespace = { highlight = { "IndentGuideDark2", "NonText", "IndentGuideBlack" } }, -- Suited for transparent bg
		-- whitespace = { highlight = { "IndentGuideRed5", "IndentGuideRed6", "IndentGuideRed7" } }, -- shades of red
		--whitespace = { highlight = { "CursorColumn", "WhiteSpace" } }, -- shades of dark
		scope = {
			show_start = false,
			show_end = false,

			highlight = {
				"Function",
				"Label",
			},
		},
		--show_trailing_blankline_indent = false,
	})
end

return M
