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
				Text = "T",
				Method = "M",
				Function = "F",
				Constructor = "C",

				Field = "F",
				Variable = "V",
				Property = "P",

				Class = "C",
				Interface = "I",
				Struct = "S",
				Module = "M",

				Unit = "U",
				Value = "V",
				Enum = "E",
				EnumMember = "E",

				Keyword = "K",
				Constant = "C",

				Snippet = "S",
				Color = "C",
				File = "F",
				Reference = "R",
				Folder = "D",
				Event = "E",
				Operator = "O",
				TypeParameter = "T",
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
