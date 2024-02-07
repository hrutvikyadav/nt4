vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.keymap.set("n", "<C-F>", vim.cmd.Ex, { desc = "NetRW: [d]irectory [l]isting" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move visual selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move visual selection up" })
-- keep cursor in place when navigating with below motions
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "EX: multicursor find and replace" }
)

vim.keymap.set("n", "<Left>", "<<")
vim.keymap.set("n", "<Right>", ">>")
vim.keymap.set("v", "<Right>", ">gv")
vim.keymap.set("v", "<Left>", "<gv")

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

vim.keymap.set("n", "<leader>Gp", "<cmd>G push<cr>", { desc = "[G]it [p]ush to upstream" })
vim.keymap.set("n", "<leader>Gf", "<cmd>diffget //2<cr>", { desc = "diffget left" })
vim.keymap.set("n", "<leader>Gj", "<cmd>diffget //3<cr>", { desc = "diffget right" })

vim.keymap.set({ "n", "i" }, "<C-s>", vim.cmd.write, { desc = "save file" }) -- add :e % (reloading for entr fmt to work correctly)

-- Unimpaired keymaps
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next QF item" })
vim.keymap.set("n", "[q", vim.cmd.cprevious, { desc = "Prev QF item" })
vim.keymap.set("n", "[Q", vim.cmd.cfirst, { desc = "First QF item" })
vim.keymap.set("n", "]Q", vim.cmd.clast, { desc = "Last QF item" })

-- oveseer
vim.keymap.set("n", "<leader><leader>", "<cmd>OverseerRun<cr>", {})

-- experimental
--vim.keymap.set('n', '<LocalLeader><Left>', function() vim.cmd("Neorg return") end, {})
vim.keymap.set("n", "\\<Left>", function()
    vim.cmd("Neorg return")
end, {})
vim.keymap.set("n", "\\<Right>", function()
    vim.cmd("Neorg index")
end, {})

-- navigate to first and last non space char in line
vim.keymap.set({ "n", "o", "x" }, "<S-h>", "^", {})
vim.keymap.set({ "n", "o", "x" }, "<S-l>", "g_", {})

-- normal mode in terminal
vim.keymap.set("t", "<C-;>", "<C-\\C-n>", {})
