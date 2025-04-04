-- Run `go vet` and populate the quickfix list.
function _G.pr_lint_go()
	vim.cmd("wa")
	vim.cmd("compiler go")
	vim.cmd("set errorformat=vet:\\ %f:%l:%c:\\ %m,%-G%.%#")
	vim.cmd("set makeprg=go\\ vet\\ -all\\ ./...")
	vim.cmd("make")
	if not vim.tbl_isempty(vim.fn.getqflist()) then
		local status, fzf_lua = pcall(require, "fzf-lua")
		if not status then
			vim.cmd("copen")
		else
			fzf_lua.quickfix()
		end
	end
end
