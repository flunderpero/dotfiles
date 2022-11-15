vim.g.floaterm_width = 0.8

-- Write all buffers and open a floating terminal.
vim.keymap.set("n", "<C-Space>", function()
	vim.cmd("wa")
	vim.cmd("FloatermToggle!")
end, { silent = true })

vim.keymap.set("t", "<C-Space>", function()
	vim.cmd("FloatermToggle!")
end, { silent = true })
