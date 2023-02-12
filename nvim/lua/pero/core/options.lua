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

-- Use system clipboard as default register.
vim.opt.clipboard:append("unnamedplus")

-- Split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Enable to switch buffers even if they are dirty.
vim.opt.hidden = true

-- Automatically save before certain commands.
vim.opt.autowriteall = true

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
