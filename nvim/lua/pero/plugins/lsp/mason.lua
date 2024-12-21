-- Ensure all the external language servers and tools we need
-- for LSP to do its magic are installed.

local mason_status, mason = pcall(require, "mason")
if not mason_status then
	return
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	return
end

mason.setup()

mason_lspconfig.setup({
	ensure_installed = {
		"rust_analyzer",
		"html",
		"cssls",
		"pyright",
		"yamlls",
		"tailwindcss",
        "openscad_lsp",
		"lua_ls",
        "gopls",
        "golangci_lint_ls",
        "terraformls",
        "asm_lsp",
	},
})

mason_null_ls.setup({
	ensure_installed = {
		"prettier",
		"stylua",
		"taplo",
		"yapf",
		"pylint",
		"mypy",
		"eslint_d",
        "cspell",
        "stylelint",
	},
})
