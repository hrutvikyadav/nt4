-- repeat_scanner.lua
-- Scans the current buffer for structurally repeated code chunks using Treesitter.
-- Usage: require("repeat_scanner").scan()

local M = {}


-- ─── Config defaults ──────────────────────────────────────────────────────────


M.config = {
    -- Minimum number of lines a node must span to be considered
    min_lines = 4,
    -- Minimum number of bytes in node text (guards against tiny nodes that pass line threshold)
    min_bytes = 60,
    -- When true, all identifier/variable names are replaced with _VAR_ before hashing.
    -- This means two blocks are "the same" even if they use different variable names.

    normalize_identifiers = true,
    -- Highlight group assigned to repeated chunks (cycles through the list per unique clone group)
    hl_groups = {
        "RepeatClone1",
        "RepeatClone2",
        "RepeatClone3",
        "RepeatClone4",
    },
    -- Namespace for extmarks so we can clear them cleanly
    ns_name = "repeat_scanner",
}

-- ─── Node type filter ─────────────────────────────────────────────────────────
-- Only nodes of these types are fingerprinted.
-- The goal: structural / compound nodes only. Never keywords or identifiers.
-- These cover most languages; Treesitter node names are language-specific,
-- so we keep a broad set and rely on the size threshold to filter noise.


local INTERESTING_NODE_TYPES = {
    -- generic
    ["function_definition"]   = true,
    ["function_declaration"]  = true,
    ["method_definition"]     = true,
    ["method_declaration"]    = true,
    ["arrow_function"]        = true,
    ["if_statement"]          = true,
    ["if_expression"]         = true,

    ["for_statement"]         = true,
    ["for_in_statement"]      = true,
    ["while_statement"]       = true,
    ["do_statement"]          = true,
    ["switch_statement"]      = true,
    ["match_expression"]      = true,
    ["block"]                 = true,
    ["body"]                  = true,
    ["try_statement"]         = true,

    ["catch_clause"]          = true,
    -- lua-specific
    ["function_call"]         = true,   -- multi-line calls
    ["local_function"]        = true,
    ["function"]              = true,
    -- c/cpp/rust
    ["compound_statement"]    = true,

    ["struct_item"]           = true,
    ["impl_item"]             = true,
    ["enum_item"]             = true,
    -- python
    ["with_statement"]        = true,
    ["decorated_definition"]  = true,
    -- ts/js

    ["class_declaration"]     = true,
    ["class_body"]            = true,
    ["object"]                = true,
    ["jsx_element"]           = true,
}


-- Leaf node types whose text we replace with _VAR_ during normalization
local IDENTIFIER_NODE_TYPES = {
    ["identifier"]            = true,
    ["property_identifier"]   = true,
    ["field_identifier"]      = true,
    ["variable_name"]         = true,
    ["name"]                  = true,
}

-- Leaf node types whose text we replace with _STR_ during normalization.
-- String literals vary between repeated blocks (e.g. "channel" vs "module")
-- but structurally the code is identical — so normalize them too.
local STRING_NODE_TYPES = {
    ["string"]                = true,
    ["string_content"]        = true,
    ["interpreted_string_literal"] = true,  -- go
    ["raw_string_literal"]    = true,
    ["string_fragment"]       = true,
    ["char_literal"]          = true,

}


-- Node types to skip entirely — they carry no structural meaning
-- and their text content causes spurious hash differences.
local SKIP_NODE_TYPES = {

    ["comment"]               = true,

    ["line_comment"]          = true,
    ["block_comment"]         = true,
    ["doc_comment"]           = true,
}


-- ─── Helpers ──────────────────────────────────────────────────────────────────


local ns_id = nil


local function get_ns()

    if not ns_id then
        ns_id = vim.api.nvim_create_namespace(M.config.ns_name)
    end
    return ns_id
end

--- Simple deterministic hash for a string (FNV-1a 32-bit)
--- Returns a hex string.
local function fnv1a(str)
    local hash = 0x811c9dc5
    for i = 1, #str do
        hash = bit.bxor(hash, str:byte(i))
        -- Lua's bit library works on 32-bit signed; keep it unsigned-ish
        hash = bit.band(bit.lshift(hash, 24)
            + bit.lshift(hash, 8)
            + bit.lshift(hash, 7)

            + hash, 0xffffffff)
    end
    return string.format("%08x", hash)
end

--- Collect all text from a node, normalizing for structural comparison.
--- - Comments are always stripped (they cause spurious hash differences)
--- - In normalize mode: identifiers -> _VAR_, string literals -> _STR_
--- - Whitespace is normalized per token at the leaf level

local function node_text_normalized(node, buf, normalize)

    local ntype = node:type()

    -- Always skip comments -- they carry no structural meaning and differ between clones
    if SKIP_NODE_TYPES[ntype] then
        return ""
    end

    if node:child_count() == 0 then
        -- leaf node
        if normalize then
            if IDENTIFIER_NODE_TYPES[ntype] then
                return "_VAR_"
            end
            if STRING_NODE_TYPES[ntype] then
                return "_STR_"
            end
        end
        local r1, c1, r2, c2 = node:range()
        local lines = vim.api.nvim_buf_get_text(buf, r1, c1, r2, c2, {})
        local text = table.concat(lines, "\n")
        -- Normalize whitespace at token level so indentation never matters
        return text:gsub("%s+", " "):gsub("^ ", ""):gsub(" $", "")

    end

    local parts = {}
    for child in node:iter_children() do
        local t = node_text_normalized(child, buf, normalize)
        if t ~= "" then

            parts[#parts + 1] = t

        end
    end
    return table.concat(parts, " ")
end


--- Recursively walk the tree and collect candidate nodes.
local function collect_candidates(node, buf, candidates)
    -- Check if this node is interesting
    if INTERESTING_NODE_TYPES[node:type()] then
        local r1, _, r2, _ = node:range()
        local line_span = r2 - r1

        if line_span >= M.config.min_lines then
            local r1c, c1, r2c, c2 = node:range()
            local raw_lines = vim.api.nvim_buf_get_text(buf, r1c, c1, r2c, c2, {})
            local raw_text  = table.concat(raw_lines, "\n")

            if #raw_text >= M.config.min_bytes then
                candidates[#candidates + 1] = {
                    node      = node,

                    node_type = node:type(),
                    range     = { r1c, c1, r2c, c2 },
                    line_span = line_span,
                    raw_text  = raw_text,
                }
            end
        end
    end


    -- Always recurse into children regardless of whether the parent was interesting
    for child in node:iter_children() do
        collect_candidates(child, buf, candidates)
    end
end


--- Given collected candidates, fingerprint and group them.
local function group_by_fingerprint(candidates, buf, normalize)
    local groups = {}  -- fingerprint -> list of candidate records

    for _, c in ipairs(candidates) do
        local normalized = node_text_normalized(c.node, buf, normalize)
        -- Collapse runs of whitespace so formatting differences don't matter
        normalized = normalized:gsub("%s+", " "):gsub("^ ", ""):gsub(" $", "")
        local fp = fnv1a(normalized)

        if not groups[fp] then
            groups[fp] = { fingerprint = fp, members = {} }
        end
        c.normalized_text = normalized
        c.fingerprint     = fp
        table.insert(groups[fp].members, c)
    end

    print("groups")
    HP(groups)

    -- Keep only groups with 2+ members (actual repetitions)
    local repeated = {}
    for _, g in pairs(groups) do

        if #g.members >= 2 then

            repeated[#repeated + 1] = g
        end
    end

    -- Sort groups: largest (by line_span) first so important ones get distinct colors
    table.sort(repeated, function(a, b)
        return a.members[1].line_span > b.members[1].line_span
    end)

    return repeated
end

--- Apply extmark highlights to all members of each group.
local function apply_highlights(repeated_groups, buf)
    local ns = get_ns()
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

    local hl_groups = M.config.hl_groups

    for i, group in ipairs(repeated_groups) do
        local hl = hl_groups[((i - 1) % #hl_groups) + 1]
        for _, member in ipairs(group.members) do
            local r1, c1, r2, c2 = unpack(member.range)
            vim.highlight.range(
                buf,
                ns,
                hl,
                { r1, c1 },
                { r2, c2 },
                { inclusive = true }
            )
        end
    end
end


--- Print a summary to the messages area.
local function report(repeated_groups)
    if #repeated_groups == 0 then
        vim.notify("[repeat_scanner] No significant repeated blocks found.", vim.log.levels.INFO)
        return
    end

    local lines = { string.format("[repeat_scanner] Found %d clone group(s):", #repeated_groups) }
    for i, group in ipairs(repeated_groups) do
        local m      = group.members[1]

        local locs   = {}
        for _, mem in ipairs(group.members) do
            table.insert(locs, string.format("L%d", mem.range[1] + 1))
        end

        lines[#lines + 1] = string.format(
            "  [%d] %s  ×%d  (~%d lines each)  @ %s",
            i,
            m.node_type,
            #group.members,
            m.line_span,
            table.concat(locs, ", ")
        )
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)

end

-- ─── Public API ───────────────────────────────────────────────────────────────

--- Main entry point. Call this from your keybind or UserCommand.
function M.scan(opts)
    opts = opts or {}
    local buf  = vim.api.nvim_get_current_buf()
    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)

    if not lang then
        vim.notify("[repeat_scanner] No Treesitter parser for filetype: " .. vim.bo[buf].filetype, vim.log.levels.WARN)
        return
    end

    local ok, parser = pcall(vim.treesitter.get_parser, buf, lang)
    if not ok or not parser then
        vim.notify("[repeat_scanner] Could not get Treesitter parser.", vim.log.levels.ERROR)

        return
    end

    local tree = parser:parse()[1]
    if not tree then
        vim.notify("[repeat_scanner] Could not parse buffer.", vim.log.levels.ERROR)
        return
    end

    local root       = tree:root()
    local candidates = {}
    collect_candidates(root, buf, candidates)
    print("candidates")
    HP(candidates)

    local normalize  = opts.normalize_identifiers
    if normalize == nil then normalize = M.config.normalize_identifiers end

    local repeated = group_by_fingerprint(candidates, buf, normalize)

    print("repeated")
    HP(repeated)

    apply_highlights(repeated, buf)
    report(repeated)

    return repeated  -- return so callers can inspect programmatically
end

--- Clear all highlights added by this plugin.
function M.clear()
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(buf, get_ns(), 0, -1)
    vim.notify("[repeat_scanner] Highlights cleared.", vim.log.levels.INFO)

end

--- Setup: define highlight groups and user commands.
function M.setup(user_config)
    M.config = vim.tbl_deep_extend("force", M.config, user_config or {})

    -- Define default highlight groups (link to diff/diagnostic colors as sensible defaults)
    -- Users can override these in their colorscheme / after/plugin
    local default_hls = {
        RepeatClone1 = { bg = "#3b2a1a", fg = "#ffaa44" },  -- amber
        RepeatClone2 = { bg = "#1a2e3b", fg = "#44aaff" },  -- blue

        RepeatClone3 = { bg = "#1e3b1a", fg = "#44ff88" },  -- green
        RepeatClone4 = { bg = "#2e1a3b", fg = "#cc88ff" },  -- purple
    }
    for name, attrs in pairs(default_hls) do
        -- only set if the group doesn't already exist / has no settings
        local existing = vim.api.nvim_get_hl(0, { name = name })
        if vim.tbl_isempty(existing) then
            vim.api.nvim_set_hl(0, name, attrs)
        end
    end

    -- User commands
    vim.api.nvim_create_user_command("RepeatScan", function()
        M.scan()
    end, { desc = "Scan buffer for repeated code chunks" })

    vim.api.nvim_create_user_command("RepeatScanStrict", function()
        -- Strict mode: variable names must also match (normalize_identifiers = false)
        M.scan({ normalize_identifiers = false })
    end, { desc = "Scan buffer for repeated code chunks (exact match, no identifier normalization)" })

    vim.api.nvim_create_user_command("RepeatClear", function()
        M.clear()
    end, { desc = "Clear repeat_scanner highlights" })
end

return M
