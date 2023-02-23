local status, diffview = pcall(require, "diffview")
if not status then
	return
end

diffview.setup({
	use_icons = false,
})

-- Keymaps
vim.keymap.set("n", "<leader>hf", ":DiffviewFileHistory %<CR>")
vim.keymap.set("n", "<leader>hh", ":DiffviewOpen<CR>")

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "DiffviewFiles", " DiffviewFileHistory" },
	callback = function()
		vim.keymap.set("n", "q", ":DiffviewClose<CR>", { silent = true })
	end,
})
