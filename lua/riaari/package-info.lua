local M = {
    "vuki656/package-info.nvim",
    ft = 'json',
    dependencies = "MunifTanjim/nui.nvim",
}

function M.config()
    local default_opts = {
        colors = {
            up_to_date = "#3C4048", -- Text color for up to date dependency virtual text
            outdated = "#d19a66",   -- Text color for outdated dependency virtual text
        },
        icons = {
            enable = true, -- Whether to display icons
            style = {
                up_to_date = "|  ", -- Icon for up to date dependencies
                outdated = "|  ", -- Icon for outdated dependencies
            },
        },
        autostart = true, -- Whether to autostart when `package.json` is opened
        hide_up_to_date = false, -- It hides up to date versions when displaying virtual text
        hide_unstable_versions = false, -- It hides unstable versions from version list e.g next-11.1.3-canary3
        -- Can be `npm`, `yarn`, or `pnpm`. Used for `delete`, `install` etc...
        -- The plugin will try to auto-detect the package manager based on
        -- `yarn.lock` or `package-lock.json`. If none are found it will use the
        -- provided one, if nothing is provided it will use `yarn`
        package_manager = 'npm'
    }

    require('package-info').setup(default_opts)

    -- Toggle dependency versions
    vim.keymap.set({ "n" }, "<leader>nt", require("package-info").toggle,
        { silent = true, noremap = true, desc = 'Toggle dependency versions' })
    -- Update dependency on the line
    vim.keymap.set({ "n" }, "<leader>nu", require("package-info").update,
        { silent = true, noremap = true, desc = 'Update dependency on the line' })
    -- Delete dependency on the line
    vim.keymap.set({ "n" }, "<leader>nd", require("package-info").delete,
        { silent = true, noremap = true, desc = 'Delete dependency on the line' })
    -- Install a new dependency
    vim.keymap.set({ "n" }, "<leader>ni", require("package-info").install,
        { silent = true, noremap = true, desc = 'Install a new dependency' })
    -- Install a different dependency version
    vim.keymap.set({ "n" }, "<leader>np", require("package-info").change_version,
        { silent = true, noremap = true, desc = 'Install a different dependency version' })
end

return M
