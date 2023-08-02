local status, telescope = pcall(require, "telescope")
if not status then
	return
end

local action_state = require("telescope.actions.state")

telescope.setup({
	defaults = {
		sorting_strategy = "ascending",
		layout_strategy = "center",
		file_ignore_patterns = { ".yarn" },
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
		git_commits = {
			mappings = {
				i = {
					["<CR>"] = function()
						-- Open in Diffview.
						-- See https://github.com/sindrets/diffview.nvim/issues/279
						local selected_entry = action_state.get_selected_entry()
						local value = selected_entry.value
						-- Close Telescope window properly prior to switching windows.
						vim.api.nvim_win_close(0, true)
						vim.cmd("stopinsert")
						vim.schedule(function()
							vim.cmd(("DiffviewOpen %s^!"):format(value))
						end)
					end,
				},
			},
		},
	},
})

telescope.load_extension("fzf")

-- Search in certain directories only.
local dir_status, dir_telescope = pcall(require, "dir-telescope")
if not dir_status then
	return
end
dir_telescope.setup()
telescope.load_extension("dir")

-- Keymaps
vim.keymap.set("n", "<leader>s", ":Telescope lsp_document_symbols ignore_symbols=variable<CR>")
vim.keymap.set("n", "<leader>cr", ":Telescope lsp_references<CR>")
vim.keymap.set("n", "<leader>n", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>f", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>F", ":Telescope dir live_grep<CR>")
vim.keymap.set("n", "<leader>N", ":Telescope dir find_files<CR>")
vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>")
vim.keymap.set("n", "<leader>hl", ":Telescope git_commits<CR>")
vim.keymap.set("n", "<leader>b", ":Telescope oldfiles<CR>")
