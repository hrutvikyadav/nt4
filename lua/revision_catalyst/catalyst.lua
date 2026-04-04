local M = {}
local Helpers = {}

-- Temporary highlights storage
local temp_highlights = {}

-- TODO: not sure what to do with this
-- function _G.Nclear_temp_highlights()
--     for _, id in ipairs(temp_highlights) do
--         local delete_ok, success = pcall(vim.fn.matchdelete, id)
--         if delete_ok then
--             print("success?:" .. success)
--         else
--             print("failed")
--         end
--     end
--     temp_highlights = {}
-- end


local function prompt_and_remove_highlight()
    if #temp_highlights == 0 then
        -- vim.notify('No temporary highlights', vim.log.levels.INFO)
        print('no high to remove')
        return
    end

    -- Get current matches to display pattern info
    local matches = vim.fn.getmatches()
    local match_map = {}
    for _, match in ipairs(matches) do
        match_map[match.id] = match
    end

    -- Create display items
    local items = {}
    for _, id in ipairs(temp_highlights) do
        local match = match_map[id]
        if match then
            table.insert(items, {
                id = id,
                display = string.format('%s (%s)', match.pattern, match.group)
            })
        end
    end

    vim.ui.select(
        items,
        {
            prompt = 'Remove highlight:',
            format_item = function(item)
                return item.display
            end,
        },
        function(choice)
            if not choice then return end
            -- Remove the highlight
            vim.fn.matchdelete(choice.id)
            -- Remove from temp_highlights table
            for i, id in ipairs(temp_highlights) do
                if id == choice.id then
                    table.remove(temp_highlights, i)
                    break
                end
            end

            print('Removed highlight')
        end
    )
end

--#region feature request persistence
-- Get storage file path for current buffer
local function get_storage_file()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == '' then return nil end

    -- Create a safe filename from buffer path
    local safe_name = bufname:gsub('/', '_'):gsub('%.', '_')
    local storage_dir = vim.fn.expand('$HOME/.scholar_highs')

    -- Create directory if it doesn't exist
    vim.fn.mkdir(storage_dir, 'p')

    return storage_dir .. '/temp_for_file_' .. safe_name
end

-- Save highlights to file
local function npersist_highlights()
    local storage_file = get_storage_file()
    if not storage_file then
        vim.notify('No file associated with buffer', vim.log.levels.WARN)
        return
    end

    -- Get current matches to save pattern info
    local matches = vim.fn.getmatches()
    local match_map = {}
    for _, match in ipairs(matches) do
        match_map[match.id] = match
    end

    -- Build save data
    local save_data = {}
    for _, id in ipairs(temp_highlights) do
        local match = match_map[id]
        if match then
            table.insert(save_data, {
                pattern = match.pattern,
                group = match.group,
            })
        end
    end

    -- Write to file
    local file = io.open(storage_file, 'w')
    if file then
        file:write(vim.json.encode(save_data))
        file:close()
        vim.notify(string.format('Saved %d highlights', #save_data), vim.log.levels.INFO)
    else
        vim.notify('Failed to save highlights', vim.log.levels.ERROR)
    end
end

-- Resume highlights from file
local function nresume_highlights()
    local storage_file = get_storage_file()
    if not storage_file then
        vim.notify('No file associated with buffer', vim.log.levels.WARN)
        return
    end

    -- Check if file exists
    local file = io.open(storage_file, 'r')
    if not file then
        vim.notify('No saved highlights for this file', vim.log.levels.INFO)
        return
    end

    -- Read and parse
    local content = file:read('*a')
    file:close()

    local ok, save_data = pcall(vim.json.decode, content)
    if not ok or not save_data then
        vim.notify('Failed to parse highlights file', vim.log.levels.ERROR)
        return
    end

    -- Clear existing highlights first
    -- _G.Nclear_temp_highlights()

    -- Restore highlights
    for _, hl in ipairs(save_data) do
        local id = vim.fn.matchadd(hl.group, hl.pattern)
        table.insert(temp_highlights, id)
    end

    vim.notify(string.format('Resumed %d highlights', #save_data), vim.log.levels.INFO)
end
--#endregion

-- Build highlighter with user config colors
function M.build_highlighter(config)
    Helpers.nhighlight_visual = function(color)
        local hl_group = config.hl_groups[color]
        if not hl_group then return end

        -- Get visual selection
        local start_pos = vim.fn.getpos("'<")
        local end_pos = vim.fn.getpos("'>")
        local line = vim.fn.getline(start_pos[2])

        -- Extract selected text
        local pattern = line:sub(start_pos[3], end_pos[3])
        print(pattern)

        -- Escape special regex characters
        pattern = vim.fn.escape(pattern, [[\\/.*$^~[]])
        print("ESC:", pattern)

        -- Add highlight
        local id = vim.fn.matchadd(hl_group, pattern)
        table.insert(temp_highlights, id)
    end

    local extract_hl_names = function()
        local hl_labels = {}
        for key, _ in pairs(config.hl_groups) do
            table.insert(hl_labels, key)
        end
        return hl_labels
    end
    local prompt_and_highlight = function()
        vim.ui.select(
            extract_hl_names(),
            {
                prompt = 'Choose highlight:',
                format_item = function(item)
                    local labels = config.hl_groups

                    return "[" .. item .. "]"
                end,
            },
            function(choice)
                if not choice then return end
                Helpers.nhighlight_visual(choice)
            end
        )
    end

    M.prompt_and_highlight = prompt_and_highlight
    M.prompt_and_remove_highlight = prompt_and_remove_highlight
    M.npersist_highlights = npersist_highlights
    M.nresume_highlights = nresume_highlights

end

return M
