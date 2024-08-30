vim.keymap.set("t", "<C-n>", function()
	vim.cmd("stopinsert")
end, { silent = true })
