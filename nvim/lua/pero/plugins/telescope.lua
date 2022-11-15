local status, telescope = pcall(require, "telescope")
if not status then
	return
end

telescope.setup({
	defaults = {
		sorting_strategy = "ascending",
		layout_strategy = "center",
	},
	pickers = {
		live_grep = {
			-- Use `rg`, search in dotfiles, and ignore .git.
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--glob",
				"!.git",
			},
		},
		find_files = {
			-- Use `rg`, search in dotfiles, and ignore .git.
			find_command = { "rg", "--hidden", "--files", "--glob", "!.git" },
		},
	},
})

telescope.load_extension("fzf")

-- Keymaps
vim.keymap.set("n", "<leader>s", ":Telescope lsp_document_symbols ignore_symbols=variable<CR>")
vim.keymap.set("n", "<leader>cr", ":Telescope lsp_references<CR>")
vim.keymap.set("n", "<leader>n", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>f", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>F", ":lua grep_prompt()<CR>")
vim.keymap.set("n", "<leader>vs", ":Telescope git_status<CR>")
vim.keymap.set("n", "<leader>vb", ":Telescope git_branches<CR>")
vim.keymap.set("n", "<leader>vc", ":Telescope git_bcommits<CR>")
vim.keymap.set("n", "<leader>b", ":Telescope oldfiles<CR>")
