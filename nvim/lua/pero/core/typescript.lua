-- Run `tsc` and populate the quickfix list.
function _G.pr_lint_tsc()
	vim.api.nvim_command("wa")
	vim.api.nvim_command("compiler tsc")
	vim.api.nvim_command("set makeprg=yarn\\ run\\ tsc\\ -b")
	vim.api.nvim_command("make")
	vim.api.nvim_command("copen")
end

-- Run `eslint` and populate the quickfix list.
function _G.pr_lint_eslint()
	vim.api.nvim_command("wa")
	vim.api.nvim_command("compiler eslint")
	vim.api.nvim_command(
		"set makeprg=yarn\\ run\\ eslint\\ --report-unused-disable-directives\\ -c\\ .eslintrc.cjs\\ "
			.. "--cache\\ --cache-location\\ .cache/eslint\\ --f\\ compact\\ ."
	)
	vim.api.nvim_command("make")
	vim.api.nvim_command("copen")
end
