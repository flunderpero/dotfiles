-- Some unspecific autocommands.

-- Write all buffers when focus is lost.
vim.api.nvim_create_autocmd("FocusLost", { command = ":wa" })
