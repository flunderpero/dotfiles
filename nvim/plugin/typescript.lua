-- Run `tsc` and populate the quickfix list.
function _G.pr_lint_tsc()
	local has_bun_lock = vim.fn.filereadable("bun.lock")
	local prg = has_bun_lock and "bun" or "yarn"
	vim.api.nvim_command("wa")
	vim.api.nvim_command("compiler tsc")
	vim.api.nvim_command("set makeprg=" .. prg .. "\\ run\\ tsc\\ -b")
	vim.api.nvim_command("make")
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        local status, fzf_lua = pcall(require, "fzf-lua")
        if not status then
            vim.cmd("copen")
        else
            fzf_lua.quickfix()
        end
    end
end

-- Run `eslint` and populate the quickfix list.
function _G.pr_lint_eslint()
	vim.api.nvim_command("wa")
	vim.api.nvim_command("compiler eslint")
	local has_bun_lock = vim.fn.filereadable("bun.lock")
	local prg = has_bun_lock and "bun" or "yarn"
	vim.api.nvim_command(
		"set makeprg="
			.. prg
			.. "\\ run\\ eslint\\ --report-unused-disable-directives\\ "
			.. "--cache\\ --cache-location\\ .cache/eslint\\ --f\\ compact\\ ."
	)
	vim.api.nvim_command("make")
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        local status, fzf_lua = pcall(require, "fzf-lua")
        if not status then
            vim.cmd("copen")
        else
            fzf_lua.quickfix()
        end
    end
end
