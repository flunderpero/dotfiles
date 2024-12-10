local status, cmp = pcall(require, "cmp")
if not status then
	return
end
local has_snippy, snippy = pcall(require, "snippy")

cmp.setup({
	preselect = cmp.PreselectMode.None,
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	snippet = {
		expand = function(args)
			local snippy_status, snippy = pcall(require, "snippy")
			if not snippy_status then
				return
			end
			snippy.expand_snippet(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-x>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<C-u>"] = cmp.mapping.confirm({
			select = true,
		}),
		["<C-i>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<CR>"] = cmp.mapping({
			i = function(fallback)
				if has_snippy and snippy.can_expand_or_advance() then
					snippy.next()
				else
					fallback()
				end
			end,
		}),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "snippy" },
		{ name = "path" },
		{ name = "nvim_lua" },
	}, {
		{ name = "buffer", option = { keyword_length = 5 } },
	}),
})
