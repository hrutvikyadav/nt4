local M = {}

function M.wtf_redux()
    local line = vim.api.nvim_get_current_line()
    local word = line:match("use%w+Query")

    -- Strip `useLazy` or `use`, and `Query` from word
    local core = word:gsub("^useLazy", ""):gsub("^use", ""):gsub("Query$", "")
    if core == word then
        vim.notify("Pattern not matched or nothing to strip.", vim.log.levels.ERROR)
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

function M.add_harpoon_default_bak(optional_path)
    local path = optional_path or (vim.fn.getcwd() .. "/.harpoon")
    local file = io.open(path, "a")
    if file then
        file:write("-- From the 🌙\n")
        file:close()
        print(".harpoon file created at " .. path)
    else
        print("Failed to create .harpoon file at " .. path)
    end
end


function M.copy_existing_harpoon_bak_to_clipboard()
    local path = vim.fn.getcwd() .. "/.harpoon"
    local file = io.open(path, "r")

    if file then
        local content = file:read("*a")
        file:close()

        -- Copy to system clipboard (requires `+clipboard` support in Neovim)
        vim.fn.setreg("+", content)
        print(".harpoon file copied to clipboard.")
    else
        print("No .harpoon file found at " .. path .. "\nRun a train on the moon")
    end
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
        vim.notify(".env.development created at " .. env_path, vim.log.levels.INFO)
    else
        vim.notify("Failed to write .env.development", vim.log.levels.ERROR)
    end

    -- Write to .envrc
    local envrc_file = io.open(envrc_path, "w")
    if envrc_file then
        envrc_file:write("export " .. line)
        envrc_file:close()
        vim.notify(".envrc created at " .. envrc_path, vim.log.levels.INFO)
    else
        vim.notify("Failed to write .envrc", vim.log.levels.ERROR)
    end
end

function M.azure_pr()
    vim.system({ "wsl-open", "https://dev.azure.com/arbinSW/_git/MITS11" })
end

function M.reload_rose_pine()
    require("riaari.colorscheme2").config()
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

return M
