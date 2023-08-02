local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

treesitter.setup({
	highlight = {
		enable = true,
	},
	indent = { enable = true },
	autotag = { enable = true },
	ensure_installed = {
		"json",
		"javascript",
		"typescript",
		"tsx",
		"yaml",
		"html",
		"css",
		"markdown",
		"graphql",
		"bash",
		"lua",
		"vim",
		"rust",
		"dockerfile",
		"gitignore",
	},
	auto_install = true,
})

vim.keymap.set("n", "ti", vim.treesitter.inspect_tree)
vim.keymap.set("n", "th", ":TSHighlightCapturesUnderCursor<CR>")

vim.api.nvim_create_autocmd("BufWrite", {
	pattern = { "*.scm" },
	callback = function()
		require("nvim-treesitter.query").invalidate_query_cache()
		vim.cmd("TSUpdate")
	end,
})
