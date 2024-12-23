return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>ht", ":tab G<cr>")
	end,
}
