-- Line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Width, tabs and indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.textwidth = 99

-- Enable soft wrapping and disable hard wrapping.
vim.opt.wrap = true
vim.opt.formatoptions:remove("t")

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Cursor line
vim.opt.cursorline = true

-- Appearance
vim.opt.signcolumn = "yes"

-- Allow backspace on indent, end of line or insert mode start position.
vim.opt.backspace = "indent,eol,start"

-- Don't treat dashes as part of a word.
vim.opt.iskeyword:remove("-")

-- Use system clipboard as default register.
vim.opt.clipboard:append("unnamedplus")

-- Split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Enable to switch buffers even if they are dirty.
vim.opt.hidden = true

-- Automatically save before certain commands.
vim.opt.autowriteall = true

-- Automatically reload buffers.
vim.opt.autoread = true

-- Don't use a swap file.
vim.opt.swapfile = false

-- Switch to an already open buffer.
vim.opt.switchbuf = "useopen"

-- Always use \n as line ending.
vim.opt.fileformat = "unix"

-- Show at least 5 lines before and after while scrolling.
vim.opt.scrolloff = 5

-- Undo
vim.opt.undofile = true

-- Diff
vim.opt.diffopt = "vertical,filler,iwhiteall,internal,closeoff"

-- Write all buffers when focus is lost.
vim.api.nvim_create_autocmd("FocusLost", { command = ":wa" })

-- Restore the cursor position on read.
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*" },
	callback = function()
		if vim.fn.filereadable(vim.fn.expand("%:p")) == 0 then
			-- Ignore buffers not backed by a file.
			return
		end
		pcall(vim.api.nvim_exec2, "normal! g'\"zv", { output = false })
	end,
})

-- Spell checking
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }
vim.opt.spelloptions = "camel"
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function()
		-- Try to find project root (e.g., using git)
		local project_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
		if vim.v.shell_error == 0 and project_root ~= "" then
			-- Create .spell directory in project if it doesn't exist
			local spell_dir = project_root .. "/.spell"
			if vim.fn.isdirectory(spell_dir) == 0 then
				vim.fn.mkdir(spell_dir, "p")
			end
			-- Set project-specific spellfile
			local spellfile = spell_dir .. "/en.utf-8.add"
			vim.opt_local.spellfile = spellfile
		else
			-- Fallback to global spellfile
			vim.opt_local.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
		end
	end,
})

-- We just want the tab number to appear as the title of a tab.
function _G.simple_tabline()
	local s = ""
	for index = 1, vim.fn.tabpagenr("$") do
		s = s .. "%" .. index .. "T"
		if index == vim.fn.tabpagenr() then
			s = s .. "%#TabLineSel#"
		else
			s = s .. "%#TabLine#"
		end
		s = s .. " " .. index .. " "
	end
	return s
end

vim.opt.showtabline = 1
vim.opt.tabline = "%!v:lua.simple_tabline()"

-- Resize the window splits when the terminal window resizes.
vim.api.nvim_create_autocmd("VimResized", {
	pattern = "*",
	command = "wincmd =",
})
