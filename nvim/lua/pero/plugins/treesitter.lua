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
    -- See https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
			},
			selection_modes = {
				["@parameter.outer"] = "v", -- character-wise
				["@block.inner"] = "v", -- character-wise
				["@function.outer"] = "V", -- line-wise so we select a prefix like `export` with it.
				["@class.outer"] = "V", -- line-wise so we select a prefix like `export` with it.
			},
		},
	},
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
