-- packer.nvim
-- The configuration is copied straight from
-- https://github.com/wbthomason/packer.nvim
-- without any modification.

-- Install packer.nvim itself if needed.
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer()

local status, packer = pcall(require, "packer")
if not status then
	print("Packer not found - skipping all plugins")
	return
end

-- Automatically sync plugins on save.
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost init.lua source <afile> | PackerCompile
    augroup end
]])

return packer.startup(function(use)
	-- Packer can manage itself.
	use("wbthomason/packer.nvim")

	-- Essentials.
	use("tpope/vim-surround")
	use("tpope/vim-unimpaired")
	use("tpope/vim-repeat")
	use("nvim-lua/plenary.nvim") -- Lua functions used by many other plugins.
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use("stevearc/dressing.nvim")

	-- LSP
	use("neovim/nvim-lspconfig")
	use("jose-elias-alvarez/typescript.nvim")
	use("jose-elias-alvarez/null-ls.nvim")

	-- mason - manage LSP servers, linters, and formatters
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("jayp0521/mason-null-ls.nvim")

	-- nvim-cmp and snippy - autocompletion and snippets
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-nvim-lua")
	use("dcampos/nvim-snippy")
	use("dcampos/cmp-snippy")

	-- Rust
	use("simrat39/rust-tools.nvim")

	-- Git
	use("lewis6991/gitsigns.nvim")
	use("tpope/vim-fugitive")

	-- dirvish.vim - file manager
	use("justinmk/vim-dirvish")
	use("roginfarrer/vim-dirvish-dovish") -- Add commands like delete to dirvish buffers.

	-- Telescope - file searching and more.
	use({
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = {
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
	})

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	-- Undo
	use("mbbill/undotree")

	-- Auto-close parens, quotes, and tags
	use("windwp/nvim-autopairs")
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" })

	-- Color scheme
	use("EdenEast/nightfox.nvim")

	-- Testing
	use("vim-test/vim-test")

	-- A floating terminal is way too handy.
	use("voldikss/vim-floaterm")

	-- Jump to where your eye sits.
	use("ggandor/leap.nvim")

	-- Bootstrap if packer.nvim had to be installed.
	if packer_bootstrap then
		require("packer").sync()
	end
end)
