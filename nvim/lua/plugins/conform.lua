return {
	"stevearc/conform.nvim",
	keys = {
		{
			"<leader>pr",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			ocaml = { "ocamlformat" },
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		formatters = {
			ocamlformat = {},
		},
	},
}
