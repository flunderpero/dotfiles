local status, snippy = pcall(require, "snippy")
if not status then
	return
end

snippy.setup({
    enable_auto = false,
	snippet_dirs = "~/.config/nvim/snippets",
})
