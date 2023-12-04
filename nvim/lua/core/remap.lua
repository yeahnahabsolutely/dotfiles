vim.g.mapleader = " "

vim.keymap.set("n", "<leader>n", vim.cmd.Ex)

vim.keymap.set("n", "<c-l>", "<C-W><C-L>")
vim.keymap.set("n", "<c-k>", "<C-W><C-K>")
vim.keymap.set("n", "<c-j>", "<C-W><C-J>")
vim.keymap.set("n", "<c-h>", "<C-W><C-H>")

vim.keymap.set("n", "<leader>h", ":split <CR>")
vim.keymap.set("n", "<leader>v", ":vsplit <CR>")
