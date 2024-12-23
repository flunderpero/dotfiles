local M = {}

local state = {
	popup = {
		buf = -1,
		win = -1,
	},
}

local function create_popup_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	end

	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}
	local win = vim.api.nvim_open_win(buf, true, win_config)
	vim.keymap.set("n", "gf", M.open_file_under_cursor, { buffer = buf })
	vim.keymap.set("n", "<leader>gf", M.parse_stacktrace_and_populate_quickfix, { buffer = buf })
	return { buf = buf, win = win }
end

local function toggle_terminal()
	if not vim.api.nvim_win_is_valid(state.popup.win) then
		state.popup = create_popup_window({ buf = state.popup.buf })
		if vim.bo[state.popup.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
		end
        vim.cmd.startinsert()
	else
		vim.api.nvim_win_hide(state.popup.win)
	end
end

-- Mimicking `gF` behavior to open the file under the cursor.
M.open_file_under_cursor = function()
	-- Get the current line and cursor position
	local current_line = vim.api.nvim_get_current_line()
	local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-indexed
	local pattern = "([%w%._/-]+):?(%d*):?(%d*)"
	local best_match, best_dist = nil, math.huge

	for file, line, col in current_line:gmatch(pattern) do
		local match_start, match_end = current_line:find(file, 1, true) -- plain search
		if match_start then -- Ensure that the pattern was found
			local dist = math.min(math.abs(cursor_col - match_start), math.abs(cursor_col - match_end))
			if dist < best_dist then
				best_match = { file = file, line = line, col = col }
				best_dist = dist
			end
		end
	end

	if best_match then
		local f = vim.fn.findfile(best_match.file)
		if f ~= "" and vim.api.nvim_win_get_config(vim.api.nvim_get_current_win()).anchor then
			toggle_terminal()
			vim.cmd("e " .. f)
			local line = tonumber(best_match.line) or 1
			local col = (tonumber(best_match.col) or 1) - 1
			vim.api.nvim_win_set_cursor(0, { line, col })
		end
	end
end

-- Parse the stacktrace under the cursor and populate the quickfix list.
M.parse_stacktrace_and_populate_quickfix = function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local buffer_lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1], -1, false)
	local pattern = "([%w%._/-]+):?(%d*):?(%d*)"
	local qf_list = {}

	local function read_line_from_file(filepath, lnum)
		local line_content = ""
		local file = io.open(filepath, "r")
		if file then
			for i = 1, lnum do
				line_content = file:read("*line") or ""
			end
			file:close()
		end
		return line_content
	end

	-- Check each line in the buffer for matches
	for _, line in ipairs(buffer_lines) do
		for file, line_num, col_num in line:gmatch(pattern) do
			local f = vim.fn.findfile(file)
			if f ~= "" then
				local lnum = tonumber(line_num) or 1
				local file_line_content = read_line_from_file(f, lnum):gsub("\t", " ")
				table.insert(qf_list, {
					filename = f,
					lnum = lnum,
					col = tonumber(col_num) or 1,
					text = file_line_content,
				})
			end
		end
	end

	toggle_terminal()
	vim.fn.setqflist(qf_list)
	if #qf_list > 0 then
		local status, fzf_lua = pcall(require, "fzf-lua")
		if not status then
			vim.cmd("copen")
		else
			fzf_lua.quickfix()
		end
	end
end

-- Write all buffers and open the terminal popup.
vim.keymap.set("n", "<C-Space>", function()
	vim.cmd("wa")
	toggle_terminal()
end, { silent = true })

vim.keymap.set("t", "<C-Space>", function()
	toggle_terminal()
end, { silent = true })
