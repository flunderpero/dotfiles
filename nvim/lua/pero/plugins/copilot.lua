local status, copilot = pcall(require, "copilot")
if not status then
	return
end

copilot.setup({
	panel = {
		keymap = {
			jump_prev = "<C-k>",
			jump_next = "<C-j>",
			accept = "<CR>",
			refresh = "gr",
			open = "<C-CR>",
		},
	},
	suggestion = {
		enabled = true,
		auto_trigger = true,
		keymap = {
			accept = "<C-y>",
			accept_word = false,
			accept_line = false,
			next = "<C-j>",
			prev = "<C-k>",
			dismiss = "<C-x>",
		},
	},
})
