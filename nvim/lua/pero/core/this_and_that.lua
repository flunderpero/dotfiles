-- Resize the window splits when the terminal window resizes.
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd ="
})
