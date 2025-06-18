-- Ensure all the external language servers and tools we need
-- for LSP to do its magic are installed.

local function config()
    require("mason").setup()
    require("mason-tool-installer").setup({
        ensure_installed = {
            "asm-lsp",
            "css-lsp",
            "golangci-lint-langserver",
            "gopls",
            "html-lsp",
            "lua-language-server",
            "marksman",
            "openscad-lsp",
            "pyright",
            "ruff",
            "rust-analyzer",
            "tailwindcss-language-server",
            "templ",
            "terraform-ls",
            "typescript-language-server",
            "yaml-language-server",

            "eslint_d",
            "prettier",
            "stylelint",
            "stylua",
        },
    })
end

return {
    {
        "williamboman/mason.nvim",
        config = config,
        dependencies = {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
    },
}
