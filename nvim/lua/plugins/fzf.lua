local function config()
	local actions = require("fzf-lua.actions")
	require("fzf-lua").setup({
		keymap = {
			fzf = {
				["ctrl-a"] = "toggle-all",
			},
		},
		actions = {
			files = {
				true,
				["ctrl-q"] = actions.file_sel_to_qf,
			},
		},
	})
	vim.keymap.set("n", "<leader>s", require("fzf-lua").lsp_document_symbols)
	vim.keymap.set("n", "<leader>S", require("fzf-lua").lsp_workspace_symbols)
	vim.keymap.set("n", "<leader>cr", require("fzf-lua").lsp_references)
	vim.keymap.set("n", "<leader>cd", function()
		require("fzf-lua").diagnostics_document({ severity_limit = "warning" })
	end)
	vim.keymap.set("n", "<leader>cD", function()
		require("fzf-lua").diagnostics_workspace({ severity_limit = "warning" })
	end)
	vim.keymap.set("n", "<leader>q", require("fzf-lua").quickfix)
	vim.keymap.set("n", "<leader>rs", require("fzf-lua").resume)
	vim.keymap.set("n", "<leader>th", require("fzf-lua").search_history)
	vim.keymap.set("n", "<leader>n", require("fzf-lua").files)
	vim.keymap.set("n", "<leader>f", require("fzf-lua").live_grep)
	vim.keymap.set("n", "<leader>hl", require("fzf-lua").git_bcommits)
	vim.keymap.set("n", "<leader>hL", require("fzf-lua").git_commits)
	vim.keymap.set("n", "<leader>ha", require("fzf-lua").git_stash)
	vim.keymap.set("n", "<leader>b", function()
		require("fzf-lua").oldfiles({
			cwd_only = true,
			include_current_session = true,
		})
	end)
	vim.keymap.set("n", "z=", function()
		local word = vim.fn.expand("<cword>")
		local suggestions = vim.fn.spellsuggest(word)
		require("fzf-lua").fzf_exec(suggestions, {
			prompt = "Spelling Suggestions> ",
			actions = {
				["default"] = function(selected)
					vim.cmd("normal! ciw" .. selected[1])
				end,
			},
		})
	end)
end

return {
	"ibhagwan/fzf-lua",
	config = config,
}
