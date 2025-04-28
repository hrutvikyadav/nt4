local M = {}

function M.wtf_redux()
    local line = vim.api.nvim_get_current_line()
    local word = line:match("use%w+Query")

    -- Strip `useLazy` or `use`, and `Query` from word
    local core = word:gsub("^useLazy", ""):gsub("^use", ""):gsub("Query$", "")
    if core == word then
        print("Pattern not matched or nothing to strip.")
        return
    end

    -- Lowercase the first letter
    local search_term = core:sub(1,1):lower() .. core:sub(2)

    -- Build exact match vimgrep (word-boundary match)
    local escaped = vim.fn.escape(search_term, '\\/.*$^~[]')
    local pattern = [[\V\<]] .. escaped .. [[\>]]

    -- Search current buffer
    vim.cmd("vimgrep /" .. pattern .. "/gj %")
    vim.cmd("copen")
end

function M.other_util()
    print("other_util")
end


vim.keymap.set("n", "<leader>lu", function()
  local utils = M
  local options = {}

  for name, _ in pairs(utils) do
    table.insert(options, name)
  end

  table.sort(options)

  vim.ui.select(options, { prompt = "Select Lua Utility:" }, function(choice)
    if choice then
      utils[choice]()
    end
  end)
end, { desc = "Run Lua Utility" })
