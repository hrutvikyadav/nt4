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

function M.add_mits11_default_envrc()

    local cwd = vim.fn.getcwd()
    local path = cwd:match("WebConsole$") and cwd or (cwd .. "/WebConsole")

    local env_path = path .. "/.env.development"
    local envrc_path = path .. "/.envrc"
    local line = "VITE_API_BASE_URL='http://localhost:9999'\n"

    -- Create WebPages directory if it doesn't exist
    -- vim.fn.mkdir(path, "p")

    -- Write to .env.development
    local env_file = io.open(env_path, "w")
    if env_file then
        env_file:write(line)
        env_file:close()
        print(".env.development created at " .. env_path)
    else
        print("Failed to write .env.development")
    end

    -- Write to .envrc
    local envrc_file = io.open(envrc_path, "w")
    if envrc_file then
        envrc_file:write("export " .. line)
        envrc_file:close()
        print(".envrc created at " .. envrc_path)
    else
        print("Failed to write .envrc")
    end
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
