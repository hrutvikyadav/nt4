local M = {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  keys = {
    { "<localleader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" }, -- search and jump to one of muliple matches visible in across buffers
    { "<localleader>S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" }, -- jump to one of multiple visible treesitter nodes
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" }, -- perform an operation but at a remote location instead of the current cursor location, i.e. in o mode, first search -> jump then do a motion
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" }, -- perform an operation but on remote treesitter nodes surrounding your search instead of the current cursor location, i.e. in o mode, first search text then select a surrounding node to jump to and execute the operation

    { "<localleader><C-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" }, -- start search with /, then instead of pressing n or N a bunch of times, use this to jump to any match
  },
}

return M
