vim.g.mapleader = " "

local map = vim.keymap.set

-- Reset search highlighting.
map("n", "<leader><ESC>", ":nohl<CR>")

-- Select the last pasted text.
map("n", "gp", "`[v`]")

-- Simpler save command.
map("n", "<leader>w", ":wa<CR>")

-- Disable arrow keys.
map({ "n", "i" }, "<up>", "<nop>")
map({ "n", "i" }, "<down>", "<nop>")
map({ "n", "i" }, "<left>", "<nop>")
map({ "n", "i" }, "<right>", "<nop>")

-- Window navigation
map("n", "<leader>l", "<C-W><C-W>")
