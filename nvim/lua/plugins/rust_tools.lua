local function config()
	local rust_tools = require("rust-tools")
	rust_tools.setup({
		tools = {
			runnables = {
				use_telescope = true,
			},
			inlay_hints = {
				auto = true,
				show_parameter_hints = false,
				parameter_hints_prefix = "",
				other_hints_prefix = "",
			},
		},

		server = {
			on_attach = function(client, bufnr)
				local opts = { silent = true, buffer = bufnr }
				vim.keymap.set("n", "<leader>e", rust_tools.expand_macro.expand_macro, opts)
				vim.keymap.set("n", "<leader>tt", rust_tools.runnables.runnables, opts)
				vim.keymap.set("n", "<leader>tf", rust_tools.runnables.runnables, opts)
			end,
			settings = {
				["rust-analyzer"] = {
					checkOnSave = {
						command = "clippy",
					},
					runnables = {
						cargoExtraArgs = { "--", "--show-output" },
					},
				},
			},
		},
	})
end
return {
	"simrat39/rust-tools.nvim",
	config = config,
}
