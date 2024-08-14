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

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

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
vim.opt.list = true
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
vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard

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

