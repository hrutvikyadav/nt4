local template_definition = {
	name = "format Lua",
	builder = function()
		local cmd = { "stylua", "init.lua", "lua/" }
		local args = { "--no-editorconfig" }

		return {
			cmd = cmd,
			components = { "format.reload_file", "default" },
		}
	end,
	desc = "with prettier",
	condition = {
		filetype = { "lua" },
	},
}

return template_definition
