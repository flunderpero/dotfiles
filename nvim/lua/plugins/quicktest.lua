local function config()
	local qt = require("quicktest")
	local fs = require("quicktest.fs_utils")
	local playwright = require("quicktest.adapters.playwright")
	local vitest = require("quicktest.adapters.vitest")

	qt.setup({
		adapters = {
			vitest({
				cwd = function(bufnr)
					local buffer_name = vim.api.nvim_buf_get_name(bufnr)
					local path = vim.fn.fnamemodify(buffer_name, ":p:h")
					return fs.find_ancestor_of_file(path, "vite.config.ts")
				end,
				is_enabled = function(bufnr)
					local ft = vim.bo[bufnr]["filetype"]
					if ft == "typescript" or ft == "typescriptreact" then
						return vitest.imports_from_vitest(bufnr)
					end
					return false
				end,
			}),
			playwright({
				cwd = function(bufnr)
					local buffer_name = vim.api.nvim_buf_get_name(bufnr)
					local path = vim.fn.fnamemodify(buffer_name, ":p:h")
					return fs.find_ancestor_of_file(path, "playwright.config.ts")
				end,
				is_enabled = function(bufnr)
					local ft = vim.bo[bufnr]["filetype"]
					if ft == "typescript" or ft == "typescriptreact" then
						return playwright.imports_from_playwright(bufnr, "playwright")
					end
					return false
				end,
			}),
			require("quicktest.adapters.pytest")({
                additional_args = function()
                    return { "-vv", "-s" }
                end,
            }),
			require("quicktest.adapters.golang")({
				additional_args = function()
					-- Don't cache tests.
					return { "-count=1" }
				end,
			}),
		},
		default_win_mode = "popup",
		use_builtin_colorizer = true,
		popup_options = {
			size = {
				width = "90%",
				height = "90%",
			},
			relative = "editor",
		},
	})

	vim.keymap.set("n", "<leader>tn", function()
		vim.cmd(":wa")
		qt.run_line()
	end, {
		desc = "[T]est Run [N]earest",
	})
	vim.keymap.set("n", "<leader>tf", function()
		vim.cmd(":wa")
		qt.run_file()
	end, {
		desc = "[T]est Run [F]ile",
	})
	vim.keymap.set("n", "<leader>td", function()
		vim.cmd(":wa")
		qt.run_dir()
	end, {
		desc = "[T]est Run [D]ir",
	})
	vim.keymap.set("n", "<leader>ta", function()
		vim.cmd(":wa")
		qt.run_all()
	end, {
		desc = "[T]est Run [A]ll",
	})
	vim.keymap.set("n", "<leader>tl", function()
		vim.cmd(":wa")
		qt.run_previous()
	end, {
		desc = "[T]est Run [L]ast",
	})
	vim.keymap.set("n", "<leader>tt", function()
		qt.toggle_win("popup")
	end, {
		desc = "[T]est [T]oggle Window",
	})
	vim.keymap.set("n", "<leader>tc", function()
		qt.cancel_current_run()
	end, {
		desc = "[T]est [C]ancel Current Run",
	})

	-- Close the quicktest-popup with `q`.
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "quicktest-output",
		callback = function(ev)
			vim.keymap.set("n", "q", function()
				qt.close_win("popup")
			end, { buffer = ev.buf })
		end,
	})
end

return {
	"quolpr/quicktest.nvim",
	config = config,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
}
