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

-- Window navigation.
function next_window_skip_special()
	local current_win = vim.api.nvim_get_current_win()
	-- Try to move to the next window.
	vim.cmd("wincmd w")
	-- If we've landed on a special window, keep moving.
	while
		vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win()), "buftype")
			== "quickfix"
		or vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win()), "buftype")
			== "locationlist"
	do
		vim.cmd("wincmd w")
		-- If we've looped around to the original window, stop.
		if vim.api.nvim_get_current_win() == current_win then
			break
		end
	end
end
map("n", "<leader>l", next_window_skip_special)
