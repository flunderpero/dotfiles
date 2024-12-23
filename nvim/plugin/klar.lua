-- Configuration for the Klar language while we develop it.

-- Add our own filetype.
vim.api.nvim_command("autocmd BufRead,BufNewFile *.kl set filetype=klar")

vim.api.nvim_command("autocmd FileType klar setlocal commentstring=--\\ %s")

-- Tree-sitter configuration.
-- See https://github.com/flunderpero/tree-sitter-klar
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.klar = {
	install_info = {
		url = "~/src/pero/tree-sitter-klar",
		files = { "src/parser.c" },
	},
	filetype = "kl",
}
-- Make sure `nvim-treesitter` finds the queries.
vim.o.runtimepath = vim.o.runtimepath .. ",~/src/pero/tree-sitter-klar"

