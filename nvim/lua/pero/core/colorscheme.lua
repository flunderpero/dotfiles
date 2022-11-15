vim.opt.background = "dark"
vim.opt.termguicolors = true

local status, nightfox = pcall(require, "nightfox")
if not status then
	return
end

nightfox.setup({
	options = {
		terminal_colors = true,
		dim_inactive = true,
	},
})

pcall(vim.cmd, "colorscheme nightfox")
