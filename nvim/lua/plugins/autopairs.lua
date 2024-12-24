return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = true,
	opts = {
		check_ts = true,
		disable_in_macro = true,
		ts_config = {
			lua = { "string" },
			javascript = { "template_string" },
			java = false,
		},
	},
}
