vim.g.mapleader = " "

local map = vim.keymap.set

-- Reset search highlighting.
map("n", "<leader><ESC>", ":nohl<CR>")

-- Simpler save command.
map("n", "<leader>w", ":wa<CR>")

-- Disable arrow keys.
map({ "n", "i" }, "<up>", "<nop>")
map({ "n", "i" }, "<down>", "<nop>")
map({ "n", "i" }, "<left>", "<nop>")
map({ "n", "i" }, "<right>", "<nop>")

-- Window navigation
map("n", "gj", "<C-W><C-J>")
map("n", "gk", "<C-W><C-K>")
map("n", "gl", "<C-W><C-L>")
map("n", "gh", "<C-W><C-H>")
map("n", "g1", ":1wincmd w<CR>", { silent = true })
map("n", "g2", ":2wincmd w<CR>", { silent = true })
map("n", "g3", ":3wincmd w<CR>", { silent = true })
map("n", "g4", ":4wincmd w<CR>", { silent = true })
map("n", "g5", ":5wincmd w<CR>", { silent = true })
map("n", "g6", ":6wincmd w<CR>", { silent = true })
map("n", "g7", ":7wincmd w<CR>", { silent = true })
map("n", "g8", ":8wincmd w<CR>", { silent = true })
map("n", "g9", ":9wincmd w<CR>", { silent = true })
map("n", "<leader>1", ":tabn 1<CR>", { silent = true })
map("n", "<leader>2", ":tabn 2<CR>", { silent = true })
map("n", "<leader>3", ":tabn 3<CR>", { silent = true })
map("n", "<leader>4", ":tabn 4<CR>", { silent = true })
map("n", "<leader>5", ":tabn 5<CR>", { silent = true })
map("n", "<leader>6", ":tabn 6<CR>", { silent = true })
map("n", "<leader>7", ":tabn 7<CR>", { silent = true })
map("n", "<leader>8", ":tabn 8<CR>", { silent = true })
map("n", "<leader>9", ":tabn 9<CR>", { silent = true })
