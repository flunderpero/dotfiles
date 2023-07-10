local status, copilot = pcall(require, "copilot")
if not status then
	return
end

copilot.setup({
	panel = {
		enabled = true,
		auto_refresh = true,
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
		keymap = {
			accept = "<C-i>",
			accept_word = false,
			accept_line = false,
			next = "<C-j>",
			prev = "<C-k>",
			dismiss = "<C-x>",
		},
	},
})

copilot.setup({
	panel = {
		enabled = true,
		auto_refresh = false,
		keymap = {
			jump_prev = "<C-k>",
			jump_next = "<C-j>",
			accept = "<CR>",
			refresh = "gr",
			open = "<C-CR>",
		},
		layout = {
			position = "bottom", -- | top | left | right
			ratio = 0.4,
		},
	},
	suggestion = {
		enabled = true,
		auto_trigger = true,
		debounce = 75,
		keymap = {
			accept = "<C-i>",
			accept_word = false,
			accept_line = false,
			next = "<C-j>",
			prev = "<C-k>",
			dismiss = "<C-x>",
		},
	},
	filetypes = {
		yaml = false,
		markdown = false,
		help = false,
		gitcommit = false,
		gitrebase = false,
		hgcommit = false,
		svn = false,
		cvs = false,
		["."] = false,
	},
	copilot_node_command = "node", -- Node.js version must be > 16.x
	server_opts_overrides = {},
})

-- local status_cmp, copilot_cmp = pcall(require, "copilot_cmp")
-- if not status_cmp then
-- 	return
-- end

-- copilot_cmp.setup()

-- Config for the official Copilot plugin.
-- vim.g.copilot_no_tab_map = true
-- vim.keymap.set("i", "<C-e>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
-- vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)", { silent = true })
-- vim.keymap.set("i", "<C-k>", "<Plug>(copilot-next)", { silent = true })
