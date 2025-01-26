-- Ensure all the external language servers and tools we need
-- for LSP to do its magic are installed.

local function config()
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = {
            "rust_analyzer",
            "html",
            "cssls",
            "yamlls",
            "tailwindcss",
            "openscad_lsp",
            "lua_ls",
            "gopls",
            "golangci_lint_ls",
            "terraformls",
            "asm_lsp",
            "ruff",
            "pyright",
            "marksman",
        },
    })
    require("mason-null-ls").setup({
        ensure_installed = {
            "prettier",
            "stylua",
            "eslint_d",
            "stylelint",
        },
    })
end

return {
    {
        "williamboman/mason.nvim",
        config = config,
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "jayp0521/mason-null-ls.nvim",
        },
    },
}
