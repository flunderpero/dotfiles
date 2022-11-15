vim.opt.diffopt = "vertical,filler,iwhiteall,internal,closeoff"

-- A simple "plugin" that let's you go through all the current
-- changes one file at a time.
vim.keymap.set("n", "<F7>", ":lua pr_diff_with_rev_vdiff('cnext')<CR>", { silent = true })
vim.keymap.set("n", "<F6>", ":lua pr_diff_with_rev_vdiff('cprev')<CR>", { silent = true })

function _G.pr_diff_with_rev_vdiff(dir)
	vim.cmd("only")
	vim.cmd(dir)
	vim.cmd("Gvdiffsplit! " .. _G.qf_rev)
end

function _G.pr_diff_with_rev(rev)
	_G.qf_rev = rev
	vim.api.nvim_command(
		"G difftool --name-only "
			.. _G.qf_rev
			.. " -- ':!:*.woff*' ':!:*.png' ':!:*.jpg' ':!:*.zip' ':!:*.avi' "
			.. "':!:*.mpg' ':!:*.mp4' ':!:*.mov' ':!:*.webp' ':!:*.bin' "
			.. "':!:*.pdf'"
	)
	_G.pr_diff_with_rev_vdiff("cfirst")
end
