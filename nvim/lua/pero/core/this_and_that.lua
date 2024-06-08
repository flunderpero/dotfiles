-- Resize the window splits when the terminal window resizes.
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd ="
})

-- Create a scratch buffer in a new tab.
function scratch_buffer()
    vim.api.nvim_command('tabnew')
    vim.api.nvim_create_buf(false, true)
    vim.opt_local.buftype = 'nofile'
    vim.opt_local.bufhidden = 'hide'
    vim.opt_local.swapfile = false
    vim.api.nvim_command('startinsert')
end

vim.keymap.set("n", "<leader>x", scratch_buffer)
