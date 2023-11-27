local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

-- Global diagnostics settings - only highlight really important errors.
vim.diagnostic.config({
	underline = {
		severity = { min = vim.diagnostic.severity.HINT },
	},
	virtual_text = {
		severity = { min = vim.diagnostic.severity.WARN },
	},
	signs = {
		severity = { min = vim.diagnostic.severity.WARN },
	},
})

-- Populate the quickfix list with all LSP errors.
vim.keymap.set("n", "<leader>ga", vim.diagnostic.setqflist)

-- Diagnostic keymaps.
vim.keymap.set("n", "[d", function()
	vim.diagnostic.goto_prev({
		severity = { min = vim.diagnostic.severity.WARN },
	})
end)
vim.keymap.set("n", "]d", function()
	vim.diagnostic.goto_next({
		severity = { min = vim.diagnostic.severity.WARN },
	})
end)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>d", function()
	vim.diagnostic.open_float({ source = true })
end)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "<leader>G", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "<leader>g", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", function()
			vim.lsp.buf.references({ includeDeclaration = false })
		end, opts)
		vim.keymap.set("n", "<leader>pr", vim.lsp.buf.format, opts)
	end,
})

local capabilities = cmp_nvim_lsp.default_capabilities()

-- Servers that don't need any special configuration.
for _, server in ipairs({ "html", "yamlls", "pyright" }) do
	lspconfig[server].setup({
		capabilities = capabilities,
	})
end

lspconfig.cssls.setup({
	capabilities = capabilities,
	settings = {
		css = {
			-- We have to disable validation because `cssls` complains about
			-- nested CSS rules (which are valid) and custom TailwindCSS rules.
			validate = false,
		},
	},
})

lspconfig.tailwindcss.setup({
	capabilities = capabilities,
	root_dir = lspconfig.util.root_pattern(
		"tailwind.config.js",
		"tailwind.config.cjs",
		"postcss.config.js",
		"postcss.config.cjs"
	),
})

local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	return
end

typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			local opts = { silent = true, buffer = bufnr }
			vim.keymap.set("n", "<leader>g", vim.lsp.buf.implementation, bufopts)
			vim.keymap.set("n", "<leader>G", ":TypescriptGoToSourceDefinition<CR>", opts)
			vim.keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>", opts)
			vim.keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>", opts)
			vim.keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>", opts)
		end,
		-- We would love to do the following, but tsserver dies on
		-- our main (very large) project no matter the amount of RAM
		-- we give it:
		-- Make monorepos work, i.e. search up the project root
		-- and don't stop at the first `tsconfig.json`.
		-- root_dir = lspconfig.util.root_pattern(".git"),
		init_options = {
			-- Node is the new Java - just dump RAM on it.
			maxTsServerMemory = 8000,
		},
	},
})
local rust_tools_status, rust_tools = pcall(require, "rust-tools")
if not rust_tools_status then
	return
end
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
			vim.keymap.set("n", "<leader>e", rust_tools.expand_macro.expand_macro, bufopts)
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
