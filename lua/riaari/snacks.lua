local M = {
    "folke/snacks.nvim", -- optional
    lazy = false,
    opts = {
        picker = { enabled = true }, -- actions picker
        terminal = { enabled = true }, -- terminal for running spec actions
    },
    keys = {
        -- Top Pickers & Explorer
        -- { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        -- find
        -- { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>sn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>sf", function() Snacks.picker.files() end, desc = "Find Files" },
        { "<C-p>", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>s.", function() Snacks.picker.recent() end, desc = "Recent" },
        -- git
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },

        { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
        -- { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
        { "<leader>gz", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
        -- { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
        { "<leader>g/", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
        -- Grep
        { "<leader>/", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>s/", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
        -- search
        { '<localleader>tr"', function() Snacks.picker.registers() end, desc = "Registers" },
        { '<localleader>t/', function() Snacks.picker.search_history() end, desc = "Search History" },
        { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
        { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
        { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
        { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
        -- { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        -- { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
        -- { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
        -- { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
        -- { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
        -- LSP
        -- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        -- { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
        -- { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        -- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        -- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        -- { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
        -- { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
        -- { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
        -- { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
        -- gh WARN: not working.
        -- { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
        -- { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
        -- { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
        -- { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
    },
}

return M
