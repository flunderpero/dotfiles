-- Some unspecific autocommands.

-- Write all buffers when focus is lost.
vim.api.nvim_create_autocmd("FocusLost", { command = ":wa" })

-- Remove trailing whitespaces on save.
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	command = [[%s/\s\+$//e]],
})
