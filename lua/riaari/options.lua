vim.opt.guicursor = ""

vim.g.netrw_banner = 0

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.pumblend = 10

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

-- vim.opt.scrolloff = 8
vim.opt.scrolloff = 999
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300
-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.opt.colorcolumn = "80"
vim.opt.cursorline = false

vim.g.mapleader = " "

--     Python provider for neovim
--     - You may disable this provider (and warning) by adding `let g:loaded_python3_provider = 0` to your init.vim
vim.cmd("let g:loaded_python3_provider = 0")

-- highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    desc = "Hightlight selection on yank",
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
    end,
})

-- NOTE: without IBL
vim.opt.list = false
vim.opt.listchars = { tab = '<->', lead = '»', trail = '·', nbsp = '␣' ,multispace = '•', leadmultispace = '»···'}
-- NOTE: without IBL

-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- vim.cmd("set listchars=tab:<->,lead:»,multispace:•") -- NOTE: with IBL
-- set listchars=tab:<->,lead:.,multispace:>>> -- simple
-- set listchars=tab:<->,lead:•,multispace:» -- digraph
-- set listchars=tab:<->,lead:·,multispace:» -- digraph2
-- set listchars=tab:<->,lead:»,multispace:• -- reversed digraph
--

--[[ vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false
})
vim.g.copilot_no_tab_map = true ]]

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- wsl clipboard reference: https://github.com/memoryInject/wsl-clipboard
-- vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard NOTE: use `y` key for nvim clipboard and ` y` for system
vim.opt.laststatus = 3

-- Set wsl-clipboard for vim clipboard if running WSL
-- Check if the current linux kernal is microsoft WSL version
local function is_wsl()
    local version_file = io.open("/proc/version", "rb")
    if version_file ~= nil and string.find(version_file:read("*a"), "microsoft") then
        version_file:close()
        return true
    end
    return false
end

-- If current linux is under WSL then use wclip.exe
-- More info: https://github.com/memoryInject/wsl-clipboard
if is_wsl() then
    vim.g.clipboard = {
        name = "wsl-clipboard",
        copy = {
            ["+"] = "wcopy",
            ["*"] = "wcopy"
        },
        paste = {
            ["+"] = "wpaste",
            ["*"] = "wpaste"
        },
        cache_enabled = true
    }
end

vim.cmd([[
    hi StatusLineObsession guifg=#eb6f92
    hi StatusLineFugitiveStatus guifg=#c4a7e7
    hi StatusLineReadonly guifg=#f6c177
]])


function Obsidian_status()
  if package.loaded["obsidian"] then
    return " KB "  -- Icon and text when loaded
  else
    return "No KB "  -- No display when not loaded
  end
end

function Lint_progress()
    local linters = require("lint").get_running()
    if #linters == 0 then
        return "󰦕"
    end
    return "󱉶 " .. table.concat(linters, ", ")
end

-- Statusline vimscript
-- vim.cmd([[
--     set statusline=%<%f\ %h%#StatusLineReadonly#%m%r\ %#StatusLineFugitiveStatus#%{FugitiveStatusline()}%#Normal#%=%-24.(%{v:lua.Obsidian_status()}\ %#StatusLineObsession#%{ObsessionStatus('','')}%#Normal#\ \ %l,%c%V%)\ %P
-- ]])

vim.api.nvim_set_hl(0, "NoiceCmd", { fg = "#ff9e64", bold = true })
vim.api.nvim_set_hl(0, "NoiceMode", { fg = "#a6e3a1", bold = true })
vim.api.nvim_set_hl(0, "NoiceSearch", { fg = "#89b4fa", bold = true })

-- Statusline lua
local statusline_components = {
    -- "%<",                -- Truncates the file path if it becomes too long
    -- "%f",                -- Full file path
    -- " ",                 -- Adds a space
    "%#StatusLineFugitiveStatus#", -- Switch highlight to StatusLineFugitiveStatus
    "%{FugitiveStatusline()}", -- Fugitive Git status
    " ",                 -- Adds a space
    "%h",                -- Help flag
    "%#StatusLineReadonly#", -- Switch highlight to StatusLineReadonly
    "%m",                -- Modified flag (+ if modified)
    "%r",                -- Readonly flag (readonly if file is readonly)
    "%#Normal#",         -- Switch back to Normal highlight
    "%=",                -- Centers the following components
    "%#RandNee#",
    "󱆉  ",
    "%{v:lua.TruncFileName()}",                --  file name
    "%#Normal#",         -- Switch back to Normal highlight
    "%=",                -- Centers the following components
    -- "%-14.(",            -- Fixed width for the following BLOCK
    -- "%-54.(",            -- Fixed width for the following BLOCK

    "%#DiagnosticDefaultInfo#",         -- Switch back to Normal highlight
    "%{v:lua.require'riaari.noice_status'.status2()}", -- Noice status output
    "%#Statusline#",         -- Switch back to Normal highlight
    " ",

    "%{v:lua.Lint_progress()}", -- Lua function call to get linting status
    "   ",
    "%{v:lua.Obsidian_status()}", -- Lua function call to get Obsidian status
    " ",                 -- Adds a space
    "%#StatusLineObsession#", -- Switch highlight to StatusLineObsession
    "%{ObsessionStatus(' ',' ')}", -- Obsession plugin status
    "%#Statusline#",         -- Switch back to Normal highlight
    " │ ",                 -- Adds a space
    -- "%)",                 -- Close the BLOCK
    -- "%=",                -- Centers the following components
    "%l",                -- Current line number
    ",",                 -- Comma
    "%c",                -- Current column number
    "%V",                -- Virtual column number
    " │ ",                 -- Adds a space
    "%{getfsize(expand(@%))}", -- file size in bytes
    " B  ",                 -- Adds a space
    "%P",                -- Percentage through the file
}

vim.api.nvim_set_hl(0, "WinBar", { fg = "#908caa", bg = "none" })
vim.api.nvim_set_hl(0, "WinbarFilename", { bold = true })

function Only_filename(wo_extension)
    if wo_extension then
        return vim.fn.expand("%:t:r")
    else
        return vim.fn.expand("%:t")
    end
end

function TruncFileName()
    local name = vim.fn.expand('%:P')

    local function truncate_all(path)
        local parts = {}
        for part in string.gmatch(path, "[^/]+") do
            table.insert(parts, part)
        end

        if #parts <= 1 then
            return path -- only filename, nothing to truncate
        end

        local initials = {}
        for i = 1, #parts - 1 do
            table.insert(initials, parts[i]:sub(1,1))
        end

        local filename = parts[#parts]
        table.insert(initials, filename)

        return table.concat(initials, "/")
    end

    return truncate_all(name)
end

local winbar_components = {
    -- "%#WinbarFilename#", -- Switch highlight to WinbarFilename
    "%<",                -- Truncates the file path if it becomes too long
    -- "%f",                -- Full file path
    "%{v:lua.Only_filename()}",                --  file name
    -- "%#Normal#",         -- Switch back to Normal highlight
    " ",                 -- Adds a space
}

-- Set the statusline using table.concat
-- vim.o.statusline = table.concat(statusline_components)
vim.cmd("colorscheme Batman")
-- vim.o.winbar = table.concat(winbar_components)

vim.o.winborder = "none" -- use solid with no transparency colorscheme
-- vim.o.winborder = "rounded" -- use with transparent colorscheme and no telescope border
vim.opt.winblend = 0
