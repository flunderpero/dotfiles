-- Automatically start terminals in insert mode.
vim.api.nvim_create_autocmd("TermOpen", { pattern = "*", command = [[startinsert]] })

-- Switch to normal mode. We cannot use <C-\><C-n> because
-- we have mapped <C-n> in kitty.conf.
vim.keymap.set("t", "<C-]>", function()
	vim.cmd("stopinsert")
end, { silent = true })
