local M = {
    "lewis6991/gitsigns.nvim",
}

function M.config()
    require("gitsigns").setup({
        -- See `:help gitsigns.txt`
        signs = {
            add = { text = "┃" },
            change = { text = "┃" },
            delete = { text = "" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = "┆" },
        },
        -- WARN: deprecated; see https://github.com/lewis6991/gitsigns.nvim/pull/1056
        -- current_line_blame_formatter_opts = {
        --     relative_time = true,
        -- },
        on_attach = function(bufnr)
            --                vim.keymap.set('n', '<leader>[h', require('gitsigns').prev_hunk,
            --                    { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
            --                vim.keymap.set('n', '<leader>]h', require('gitsigns').next_hunk,
            --                    { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
            --                vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
            --                    { buffer = bufnr, desc = '[P]review [H]unk' })
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]c", function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return "<Ignore>"
            end, { expr = true })

            map("n", "[c", function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return "<Ignore>"
            end, { expr = true })

            -- Actions
            --map('n', '<leader>hs', gs.stage_hunk)
            --map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
            --map('n', '<leader>hS', gs.stage_buffer)
            --map('n', '<leader>hu', gs.undo_stage_hunk)
            -- reset to current commit
            map("n", "<leader>hr", gs.reset_hunk)
            map("v", "<leader>hr", function()
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end)
            map("n", "<leader>hR", gs.reset_buffer)
            -- preview
            map("n", "<leader>hp", gs.preview_hunk)
            -- blame
            map("n", "<leader>hb", function()
                gs.blame_line({ full = true })
            end)
            map("n", "<leader>tb", gs.toggle_current_line_blame)
            --diff
            map("n", "<leader>hd", gs.diffthis)
            map("n", "<leader>hD", function()
                gs.diffthis("~")
            end)
            map('n', '<leader>tgd', gs.toggle_deleted)

            -- Text object
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
    })
end

return M
