vim.g.floaterm_width = 0.8

-- Write all buffers and open a floating terminal.
vim.keymap.set("n", "<C-Space>", function()
	vim.cmd("wa")
	vim.cmd("FloatermToggle!")
end, { silent = true })

vim.keymap.set("t", "<C-Space>", function()
	vim.cmd("FloatermToggle!")
end, { silent = true })

-- Mimicking `gF` behavior to open the file under the cursor.
function floaterm_open_in_normal_window()
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
			vim.cmd("FloatermHide")
			vim.cmd("e " .. f)
			local line = tonumber(best_match.line) or 1
			local col = (tonumber(best_match.col) or 1) - 1
			vim.api.nvim_win_set_cursor(0, { line, col })
		end
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "floaterm",
	callback = function()
		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"gf",
			":lua floaterm_open_in_normal_window()<CR>",
			{ noremap = true, silent = true }
		)
	end,
})

-- Parse the stacktrace in the floaterm buffer and populate the quickfix list.
function floaterm_parse_stacktrace_and_populate_quickfix()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local buffer_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local pattern = "([%w%._/-]+):?(%d*):?(%d*)"
	local qf_list = {}

	-- Function to read a specific line from a file
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
				-- Read the line from the file
				local file_line_content = read_line_from_file(f, lnum):gsub("\t", " ")
				table.insert(qf_list, {
					filename = f,
					lnum = lnum,
					col = tonumber(col_num) or 1,
					text = file_line_content, -- Include the content of the line from the file
				})
			end
		end
	end

	vim.cmd("FloatermHide")
	vim.fn.setqflist(qf_list)
	if #qf_list > 0 then
		vim.cmd("copen")
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "floaterm",
	callback = function()
		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"<leader>gf",
			":lua floaterm_parse_stacktrace_and_populate_quickfix()<CR>",
			{ noremap = true, silent = true }
		)
	end,
})
