local M = {
    "luckasRanarison/nvim-devdocs",
    -- cmd = "DevdocsOpen",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
}

function M.config()
    require("nvim-devdocs").setup({
        dir_path = vim.fn.stdpath("data") .. "/devdocs", -- installation directory
        telescope = {}, -- passed to the telescope picker
        filetypes = {
            -- extends the filetype to docs mappings used by the `DevdocsOpenCurrent` command, the version doesn't have to be specified
            -- scss = "sass",
            -- javascript = { "node", "javascript" }
        },
        float_win = { -- passed to nvim_open_win(), see :h api-floatwin
            relative = "editor",
            height = 25,
            width = 100,
            border = "rounded",
        },
        wrap = false, -- text wrap, only applies to floating window
        previewer_cmd = "glow", -- for example: "glow"
        cmd_args = { "-s", "dark", "-w", "80" }, -- example using glow: { "-s", "dark", "-w", "80" }
        cmd_ignore = {}, -- ignore cmd rendering for the listed docs
        picker_cmd = false, -- use cmd previewer in picker preview
        picker_cmd_args = { "-s", "dark", "-w", "80" }, -- example using glow: { "-s", "dark", "-w", "50" }
        mappings = { -- keymaps for the doc buffer
            open_in_browser = "<leader>B",
        },
        ensure_installed = {
            "tailwindcss",
            "typescript ",
            "react      ",
            "sqlite     ",
            "node       ",
        }, -- get automatically installed
        after_open = function(bufnr) end, -- callback that runs after the Devdocs window is opened. Devdocs buffer ID will be passed in
    })
end

local N =   {
    "maskudo/devdocs.nvim",
    lazy = false,
    dependencies = {
        -- "folke/snacks.nvim",
    },
    cmd = { "DevDocs" },
    -- keys = {
    --     {
    --         "<leader>ho",
    --         mode = "n",
    --         "<cmd>DevDocs get<cr>",
    --         desc = "Get Devdocs",
    --     },
    --     {
    --         "<leader>hi",
    --         mode = "n",
    --         "<cmd>DevDocs install<cr>",
    --         desc = "Install Devdocs",
    --     },
    --     {
    --         "<leader>hv",
    --         mode = "n",
    --         function()
    --             local devdocs = require("devdocs")
    --             local installedDocs = devdocs.GetInstalledDocs()
    --             vim.ui.select(installedDocs, {}, function(selected)
    --                 if not selected then
    --                     return
    --                 end
    --                 local docDir = devdocs.GetDocDir(selected)
    --                 -- prettify the filename as you wish
    --                 Snacks.picker.files({ cwd = docDir })
    --             end)
    --         end,
    --         desc = "Get Devdocs",
    --     },
    --     {
    --         "<leader>hd",
    --         mode = "n",
    --         "<cmd>DevDocs delete<cr>",
    --         desc = "Delete Devdoc",
    --     }
    -- },
    opts = {
        ensure_installed = {
            "go",
            "html",
            -- "dom",
            "http",
            -- "css",
            -- "javascript",
            -- "rust",
            -- some docs such as lua require version number along with the language name
            -- check `DevDocs install` to view the actual names of the docs
            "lua~5.1",
            -- "openjdk~21"
        },
    },
}

return N
