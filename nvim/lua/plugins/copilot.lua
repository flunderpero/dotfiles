-- AI will make me a good coder, eventually.
local function config()
    require("copilot").setup({
        panel = {
            keymap = {
                jump_prev = "<C-k>",
                jump_next = "<C-j>",
                accept = "<CR>",
                refresh = "gr",
                open = "<C-CR>",
            },
        },
        suggestion = {
            enabled = true,
            auto_trigger = false,
            keymap = {
                accept = "<C-y>",
                accept_word = "<C-p>",
                accept_line = false,
                next = "<C-j>",
                prev = "<C-k>",
                dismiss = "<C-x>",
            },
        },
    })
    -- Toggle Copilot.
    vim.keymap.set("n", "<leader>cp", ":Copilot! toggle<CR>", { noremap = true, silent = true })
end

return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = config,
}
