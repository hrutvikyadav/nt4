function GrepInRangeVimRegex(pattern, start_line, end_line)
    start_line = start_line or vim.fn.line("'<")
    end_line = end_line or vim.fn.line("'>")

    -- pattern = pattern or vim.fn.input("Pattern: ")
    if not pattern then
        print("No pattern provided")
        return
    end

    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local qf_list = {}
    local re = vim.regex(pattern)

    vim.cmd('call clearmatches()')

    for i, line in ipairs(lines) do
        local s, e = re:match_str(line)
        if s then
            local lnum = start_line + i - 1

            table.insert(qf_list, {
                bufnr = 0,
                filename = vim.api.nvim_buf_get_name(0),
                lnum = lnum,
                col = s + 1,
                text = line,
            })

      -- Add highlight for match
      -- local match_pattern = string.format('\\%%%dl\\%%%dc.', lnum, s + 1)
      local match_pattern = string.format("\\%%%dl\\%%%dc.\\{%d}", lnum, s + 1, e - s)
      vim.fn.matchadd('Search', match_pattern)  -- or use a custom group like 'CustomMatch'
        end
    end

    vim.fn.setqflist(qf_list, 'r')
    vim.cmd("copen")
end
