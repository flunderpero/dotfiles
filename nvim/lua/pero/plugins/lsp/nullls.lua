-- Use `null-ls` to provide some formatters and diagnostics.

local status, null_ls = pcall(require, "null-ls")
if not status then
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
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
		formatting.taplo,
		formatting.stylua,
		formatting.yapf,
		formatting.stylelint,
		-- We can use `eslint_d` if we don't use Yarn PnP.
		diagnostics.eslint_d.with({
			env = {
				ESLINT_USE_FLAT_CONFIG = "true",
			},
			condition = function(utils)
				return has_eslint_config(utils) and not utils.root_has_file(".pnp.cjs")
			end,
		}),
		-- We have to fall back to `eslint` if we use Yarn PnP. `eslint_d` is not able to resolve
		-- plugins inside the `eslintrc.cjs` configuration file.
		diagnostics.eslint.with({
			dynamic_command = command_resolver.from_yarn_pnp(),
			condition = function(utils)
				return has_eslint_config(utils) and utils.root_has_file(".pnp.cjs")
			end,
		}),
		code_actions.eslint.with({
			dynamic_command = command_resolver.from_yarn_pnp(),
			condition = function(utils)
				return has_eslint_config(utils) and utils.root_has_file(".pnp.cjs")
			end,
		}),
		diagnostics.pylint,
		diagnostics.mypy,
		diagnostics.cspell.with({
			diagnostics_postprocess = function(diagnostic)
				diagnostic.severity = vim.diagnostic.severity.HINT
			end,
		}),
		diagnostics.stylelint,
		code_actions.cspell,
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
