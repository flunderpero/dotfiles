-- We just want the tab number to appear as the title of a tab.

function _G.simple_tabline()
    local s = ''
    for index = 1, vim.fn.tabpagenr('$') do
        s = s .. '%' .. index .. 'T'
        if index == vim.fn.tabpagenr() then
            s = s .. '%#TabLineSel#'
        else
            s = s .. '%#TabLine#'
        end
        s = s .. ' ' .. index .. ' '
    end
    return s
end

vim.opt.showtabline = 1
vim.opt.tabline = '%!v:lua.simple_tabline()'
