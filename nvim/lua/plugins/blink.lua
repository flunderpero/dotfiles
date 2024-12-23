return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	version = "*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "none",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-x>"] = { "hide" },
			["<C-u>"] = { "select_and_accept" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },

			["<S-Up>"] = { "scroll_documentation_up", "fallback" },
			["<S-Down>"] = { "scroll_documentation_down", "fallback" },

			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			kind_icons = {
				Text = "[TXT]",
				Method = "[MET]",
				Function = "[FUN]",
				Constructor = "[CTR]",

				Field = "[FLD]",
				Variable = "[VAR]",
				Property = "[PRP]",

				Class = "[CLS]",
				Interface = "[INT]",
				Struct = "[STR]",
				Module = "[MOD]",

				Unit = "[UNT]",
				Value = "[VAL]",
				Enum = "[ENM]",
				EnumMember = "[ENM]",

				Keyword = "[KEY]",
				Constant = "[CON]",

				Snippet = "[SNP]",
				Color = "[COL]",
				File = "[FIL]",
				Reference = "[REF]",
				Folder = "[DIR]",
				Event = "[EVT]",
				Operator = "[OPR]",
				TypeParameter = "[TYP]",
			},
		},
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 250,
			},
			accept = { auto_brackets = { enabled = true } },
		},
		signature = {
			enabled = true,
		},
	},
	opts_extend = { "sources.default" },
}
