local function config()
    local lspconfig = require("lspconfig")

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
            vim.keymap.set("n", "<leader>ca", function()
                vim.lsp.buf.code_action({
                    filter = function(action)
                        -- Remove those pesky "Move to new file" (TS) and
                        -- "Browse gopls feature documentation" (Go) actions.
                        return action.kind ~= "refactor.move" and action.kind ~= "gopls.doc.features"
                    end,
                })
            end, opts)
            vim.keymap.set("n", "gr", function()
                vim.lsp.buf.references({ includeDeclaration = false })
            end, opts)
        end,
    })

    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Servers that don't need any special configuration.
    for _, server in ipairs({
        "asm_lsp",
        "html",
        "lua_ls",
        "marksman",
        "ocamllsp",
        "pyright",
        "ruff",
        "templ",
        "terraformls",
    }) do
        lspconfig[server].setup({
            capabilities = capabilities,
        })
    end

    require("lspconfig").yamlls.setup({
        settings = {
            yaml = {
                schemas = {
                    kubernetes = "*_pod.yaml",
                    ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                    ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                    ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
                    ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                    ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                    ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                    ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
                },
            },
        },
    })

    lspconfig.gopls.setup({
        capabilities = capabilities,
        settings = {
            gopls = {
                analyses = {
                    composites = false,
                },
            },
        },
    })

    -- Determine the path to the golangci-lint binary.
    local _golangci_command = nil
    local function golangci_command()
        if _golangci_command ~= nil then
            return _golangci_command
        end

        local function find_command()
            -- Try to use `go tool golangci-lint` if it's available.
            if vim.fn.system("go tool golangci-lint 2>/dev/null"):match("golangci%-lint") then
                return { "go", "tool", "golangci-lint" }
            end

            -- Check for the binary in various locations.
            local paths = { "./tools/golangci-lint", "./golangci-lint" }
            for _, path in ipairs(paths) do
                if vim.fn.executable(path) == 1 then
                    return { path }
                end
            end

            -- Fallback to $PATH.
            return { "golangci-lint" }
        end
        _golangci_command = vim.list_extend(
            find_command(),
            { "run", "--output.json.path=stdout", "--show-stats=false", "--issues-exit-code=1" }
        )
        return _golangci_command
    end

    lspconfig.golangci_lint_ls.setup({
        capabilities = capabilities,
        filetypes = { "go", "gomod" },
        on_new_config = function(new_config)
            new_config.init_options.command = golangci_command()
        end,
    })

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

    -- OpenSCAD
    vim.api.nvim_command("autocmd BufRead,BufNewFile *.scad set filetype=openscad")
    vim.api.nvim_command("autocmd FileType openscad setlocal commentstring=//\\ %s")
    lspconfig.openscad_lsp.setup({})

    -- TypeScript
    lspconfig.ts_ls.setup({
        root_patterns = { ".git" },
        init_options = {
            maxTsServerMemory = 10000,
        },
    })
end

return {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = config,
}
