-- Use `none-ls` to provide some formatters and diagnostics.

local function config()
	local null_ls = require("null-ls")
	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics
    local diagnostics_eslint = require("none-ls.diagnostics.eslint")
    local diagnostics_eslint_d = require("none-ls.diagnostics.eslint_d")
    local code_actions_eslint = require("none-ls.code_actions.eslint")
	local command_resolver = require("null-ls.helpers.command_resolver")
	local utils = require("null-ls.utils")

	local function has_eslint_config(utils)
		return utils.root_has_file(".eslintrc.cjs")
			or utils.root_has_file(".eslintrc.js")
			or utils.root_has_file("eslint.config.mjs")
			or utils.root_has_file("eslint.config.js")
			or utils.root_has_file("eslint.config.cjs")
	end

	null_ls.setup({
		root_dir = utils.root_pattern(".git"),
		sources = {
			formatting.prettier,
			formatting.stylua,
			formatting.yapf,
			formatting.stylelint,
			formatting.terraform_fmt.with({
				command = "tofu",
			}),
			-- We can use `eslint_d` if we don't use Yarn PnP.
			diagnostics_eslint_d.with({
				env = {
					ESLINT_USE_FLAT_CONFIG = "true",
				},
				condition = function(utils)
					return has_eslint_config(utils) and not utils.root_has_file(".pnp.cjs")
				end,
			}),
			-- We have to fall back to `eslint` if we use Yarn PnP. `eslint_d` is not able to resolve
			-- plugins inside the `eslintrc.cjs` configuration file.
			diagnostics_eslint.with({
				dynamic_command = command_resolver.from_yarn_pnp(),
				condition = function(utils)
					return has_eslint_config(utils) and utils.root_has_file(".pnp.cjs")
				end,
			}),
			code_actions_eslint.with({
				dynamic_command = command_resolver.from_yarn_pnp(),
				condition = function(utils)
					return has_eslint_config(utils) and utils.root_has_file(".pnp.cjs")
				end,
			}),
			diagnostics.mypy,
			diagnostics.stylelint,
		},
		on_attach = function(_, bufnr)
			vim.keymap.set("n", "<leader>pr", function()
				vim.lsp.buf.format({
					filter = function(client)
						-- Never format with ts_ls, we use prettier.
						return client.name ~= "ts_ls"
					end,
				})
			end, {
				silent = true,
				buffer = bufnr,
			})
		end,
	})
end

return {
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvimtools/none-ls-extras.nvim" },
		config = config,
	},
}
