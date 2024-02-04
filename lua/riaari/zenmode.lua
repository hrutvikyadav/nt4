local M = {
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	config = function()
		require("hplugins.zenmode")
	end,
	dependencies = {
		"folke/twilight.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}

function M.config()
	local zen = require("zen-mode")

	vim.keymap.set("n", "<leader>Z", function()
		zen.toggle({
			--window = {
			--    width = .60,
			--}
		})
	end, { desc = "Toggle ZenMode" })
end

return M
