vim.g.mapleader = " "

-- Execute a Lua line or the whole file.
vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

-- Reset search highlighting.
vim.keymap.set("n", "<leader><ESC>", ":nohl<CR>")

-- Select the last pasted text.
vim.keymap.set("n", "gp", "`[v`]")

-- Simpler save command.
vim.keymap.set("n", "<leader>w", ":wa<CR>")

-- Disable arrow keys.
vim.keymap.set({ "n", "i" }, "<up>", "<nop>")
vim.keymap.set({ "n", "i" }, "<down>", "<nop>")
vim.keymap.set({ "n", "i" }, "<left>", "<nop>")
vim.keymap.set({ "n", "i" }, "<right>", "<nop>")

-- Window navigation.
vim.keymap.set("n", "<leader>l", "<C-w>w")
vim.keymap.set("n", "<leader>L", "<C-w>W")

-- Terminal: Enter normal mode.
vim.keymap.set("t", "<C-n>", function()
	vim.cmd("stopinsert")
end, { silent = true })
