local M = {}

function M.status()
    local noice = require("noice").api.status
    local parts = {}

    local function safe(get_fn, has_fn)
        local ok_has, has = pcall(has_fn)
        if ok_has and has then
            local ok_get, result = pcall(get_fn)
            if ok_get and result then
                table.insert(parts, result)
            end
        end
    end

    safe(noice.message.get_hl, noice.message.has)
    safe(noice.command.get, noice.command.has)
    safe(noice.mode.get, noice.mode.has)
    safe(noice.search.get, noice.search.has)

    print(table.concat(parts, " "))
    return table.concat(parts, " ")
end

function M.status2()
    local noice = require("noice").api.status
    local parts = {}

    local function safe(label, get_fn, has_fn, hl)
        if has_fn() then
            local result = get_fn()
            local separator = "" -- ""
            if result and result ~= "" then
                table.insert(parts, string.format("%s " .. separator .. " %s", label, result))
            end
        end
    end

    -- Each part gets a label, get_fn, has_fn, and highlight group
    -- safe("󰍡", noice.message.get, noice.message.has, "")
    safe("󰁨", noice.qfz.get, noice.qfz.has, "")

    -- "" "CMD"
    safe("", noice.command.get, noice.command.has, "")
    -- "⏾" "MODE" ""
    safe("", noice.mode.get, noice.mode.has, "")
    -- ""  "SEARCH"
    safe("", noice.search.get, noice.search.has, "")

    return table.concat(parts, " │ ")
end

return M
