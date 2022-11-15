-- Use `null-ls` to provide some formatters and diagnostics.

local status, null_ls = pcall(require, "null-ls")
if not status then
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	sources = {
		formatting.prettier,
		formatting.stylua,
		formatting.yapf,
		diagnostics.eslint_d.with({
			condition = function(utils)
				return utils.root_has_file(".eslintrc.cjs")
			end,
		}),
	},
	on_attach = function(current_client, bufnr)
		vim.keymap.set("n", "<leader>pr", vim.lsp.buf.format, { silent = true })
	end,
})
