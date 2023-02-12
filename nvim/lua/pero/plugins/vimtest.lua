vim.g["test#strategy"] = "floaterm"
vim.g["test#echo_command"] = 1

vim.keymap.set("n", "<leader>tt", ":TestNearest<CR>", { silent = true })
vim.keymap.set("n", "<leader>tT", ":TestNearest", { silent = true })
vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { silent = true })
vim.keymap.set("n", "<leader>tF", ":TestFile", { silent = true })
vim.keymap.set("n", "<leader>tL", ":TestLast", { silent = true })
vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { silent = true })

-- Add "quiet" opitons to <leader>tf and <leader>tt.
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.ts", "*.tsx" },
	callback = function()
		vim.keymap.set("n", "<leader>tt", ":TestNearest --silent<CR>", { silent = true })
		vim.keymap.set("n", "<leader>tf", ":TestFile --silent<CR>", { silent = true })
	end,
	group = group,
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.py" },
	callback = function()
		vim.keymap.set("n", "<leader>tt", ":TestNearest -qq<CR>", { silent = true })
		vim.keymap.set("n", "<leader>tf", ":TestFile -qq<CR>", { silent = true })
	end,
	group = group,
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.rs" },
	callback = function()
		vim.keymap.set("n", "<leader>tT", ":TestNearest -- --nocapture", { silent = true })
		vim.keymap.set("n", "<leader>tF", ":TestFile -- --nocapture", { silent = true })
	end,
	group = group,
})

-- Custom Playwright runner for our personal project.
vim.g["test#custom_runners"] = { javascript = { "clingplaywright" } }
