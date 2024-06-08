local status, diffview = pcall(require, "diffview")
if not status then
	return
end

local actions = require("diffview.actions")

diffview.setup({
	use_icons = false,
	keymaps = {
		view = {
			{ "n", "[e", actions.select_prev_entry },
			{ "n", "]e", actions.select_next_entry },
			-- The following are the default keymaps, we have them here for documentation purposes.
			{ "n", "<leader>e", actions.focus_files },
			{ "n", "[x", actions.prev_conflict },
			{ "n", "]x", actions.next_conflict },
			{ "n", "<leader>co", actions.conflict_choose("ours") },
			{ "n", "<leader>ct", actions.conflict_choose("theirs") },
			{ "n", "<leader>cb", actions.conflict_choose("base") },
			{ "n", "<leader>ca", actions.conflict_choose("all") },
			{ "n", "<leader>cO", actions.conflict_choose_all("ours") },
			{ "n", "<leader>cT", actions.conflict_choose_all("theirs") },
			{ "n", "<leader>cB", actions.conflict_choose_all("base") },
			{ "n", "<leader>cA", actions.conflict_choose_all("all") },
		},
		file_panel = {
			{ "n", "[e", actions.select_prev_entry },
			{ "n", "]e", actions.select_next_entry },
		},
	},
})

-- Keymaps
vim.keymap.set("n", "<leader>hf", ":DiffviewFileHistory %<CR>")
vim.keymap.set("n", "<leader>hh", ":DiffviewOpen<CR>")

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "DiffviewFiles", "DiffviewFileHistory" },
	callback = function()
		vim.keymap.set("n", "q", ":DiffviewClose<CR>", { silent = true })
	end,
})
