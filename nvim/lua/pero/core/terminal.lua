-- Automatically start terminals in insert mode.
vim.api.nvim_create_autocmd("TermOpen", { pattern = "*", command = [[startinsert]] })

vim.keymap.set("t", "<C-n>", function()
	vim.cmd("stopinsert")
end, { silent = true })
