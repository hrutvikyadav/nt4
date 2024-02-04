local M = {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	-- or                              , branch = '0.1.x',
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
}

function M.config()
	require("telescope").load_extension("fzf")

	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "TELESCOPE [s]earch pwd [f]iles" })
	vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "TELESCOPE git files" })
	vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "TELESCOPE live grep pwd files" })

	vim.keymap.set("n", "<leader>Gc", builtin.git_commits, { desc = "TELESCOPE [G]it [c]ommits" })
	vim.keymap.set("n", "<leader>Gb", builtin.git_branches, { desc = "TELESCOPE [G]it [b]ranches" })
end

return M
