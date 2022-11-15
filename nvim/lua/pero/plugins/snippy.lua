local status, snippy = pcall(require, "snippy")
if not status then
	return
end

snippy.setup({
	snippet_dirs = "~/.config/nvim/snippets",
	mappings = {
		is = {
			["<Tab>"] = "expand_or_advance",
			["<S-Tab>"] = "previous",
		},
	},
})
