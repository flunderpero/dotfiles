vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "getline(v:lnum)=~'^#'?'>'.len(matchstr(getline(v:lnum),'^#*')):'='"
