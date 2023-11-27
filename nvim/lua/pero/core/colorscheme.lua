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
		styles = {
			comments = "italic",
		},
	},
	groups = {
		all = {
			-- All in all we want to reduce the number of colors being used as
			-- it gets confusing and just too colorful sometimes.
			-- First of all, don't treat builtins and macros any special.
			["@function.builtin"] = { link = "@function" },
			["@variable.builtin"] = { link = "@variable" },
			["@type.builtin"] = { link = "@type" },
			["@function.macro"] = { link = "@function" },
			["PreProc"] = { link = "@function" },
			-- Namespace <-> types, constructor <-> type, fugazi, they are similar.
			["@namespace"] = { link = "type" },
			["@constructor"] = { link = "@type" },
			-- The default color for these is red and red should be reserved for errors.
			["@keyword.return"] = { fg = "palette.pink.bright" },
			["@exception"] = { fg = "palette.pink.bright" },
			-- Language specific adaptations.
			["@type.qualifier.rust"] = { link = "@keyword" },
			["@keyword.return.rust"] = { link = "@keyword.return" },
			["@include.rust"] = { link = "@keyword" },
			["@string.documentation.python"] = { link = "@comment" },
		},
	},
	specs = {
		all = {
			syntax = {
				keyword = "pink",
				operator = "orange",
			},
		},
	},
})

pcall(vim.cmd, "colorscheme nightfox")
