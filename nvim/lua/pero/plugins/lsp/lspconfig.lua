local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local on_attach = function(client, bufnr)
	-- Mappings.
	local opts = { silent = true, buffer = bufnr }
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
	vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
end

local capabilities = cmp_nvim_lsp.default_capabilities()

-- Servers that don't need any special configuration.
for _, server in ipairs({ "html", "cssls", "yamlls", "pyright" }) do
	lspconfig[server].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

lspconfig.tailwindcss.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	root_dir = lspconfig.util.root_pattern("tailwind.config.js", "postcss.config.js"),
})

local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	return
end

typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
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
