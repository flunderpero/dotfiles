return {
    "justinmk/vim-dirvish",
    config = function()
        -- Sort directories first.
        vim.g.dirvish_mode = ":sort ,^.*[\\/],"
    end,
    dependencies = {
        "roginfarrer/vim-dirvish-dovish",
    },
}
