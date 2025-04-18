vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.containerfile",
	command = "setlocal filetype=dockerfile",
})
