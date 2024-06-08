-- lazy.nvim
-- The configuration is copied straight from
-- https://github.com/folke/lazy.nvim without any modification.

-- Install lazy.nvim itself if needed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Essentials.
	"tpope/vim-surround",
	"tpope/vim-unimpaired",
	"tpope/vim-repeat",
	-- Lua functions used by many other plugins.
	"nvim-lua/plenary.nvim",
	{
		"numToStr/Comment.nvim",
		init = function()
            require("Comment").setup()
        end,
	},
    -- Style UI elements like inputs.
	"stevearc/dressing.nvim",

	-- LSP
	"neovim/nvim-lspconfig",
	"jose-elias-alvarez/null-ls.nvim",
	{
		"j-hui/fidget.nvim",
		init = function()
			require("fidget").setup()
		end,
	},

	-- mason - manage LSP servers, linters, and formatters
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"jayp0521/mason-null-ls.nvim",

	-- nvim-cmp and snippy - autocompletion and snippets
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lua",
	"dcampos/nvim-snippy",
	"dcampos/cmp-snippy",

	-- Rust
	"simrat39/rust-tools.nvim",

	-- Git
	"lewis6991/gitsigns.nvim",
	"tpope/vim-fugitive",
	"sindrets/diffview.nvim",

	-- dirvish.vim - file manager
	"justinmk/vim-dirvish",
	-- Add commands like delete to dirvish buffers.
	"roginfarrer/vim-dirvish-dovish",

	-- Telescope - file searching and more.
	{
		"nvim-telescope/telescope.nvim",
        -- Using master for now because of a bug in 0.1.6: 
        -- https://github.com/nvim-telescope/telescope.nvim/issues/3070
		-- tag = "0.1.6",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
		},
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	"princejoogie/dir-telescope.nvim",

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	"nvim-treesitter/playground",
	"nvim-treesitter/nvim-treesitter-textobjects",

	-- Undo
	"mbbill/undotree",

	-- Auto-close parens, quotes, and tags
	"windwp/nvim-autopairs",
	{ "windwp/nvim-ts-autotag", dependencies = { "nvim-treesitter" } },

	-- Color scheme
	"EdenEast/nightfox.nvim",

	-- Testing
	"vim-test/vim-test",

	-- A floating terminal is way too handy.
	"voldikss/vim-floaterm",

	-- Jump to where your eye sits.
	"ggandor/leap.nvim",

	-- AI will make me a good coder, eventually.
	-- ("github/copilot.vim")
	"zbirenbaum/copilot.lua",
})
