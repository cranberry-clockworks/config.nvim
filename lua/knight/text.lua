local M = {}

local function set_text_width(width)
    vim.opt.textwidth = tonumber(width)
    vim.opt.colorcolumn = tostring(width)
end

function M.set_hard_wrap(width)
    local w = width or vim.call('input', 'Enter new text width: ')
    vim.cmd("set nowrap!")
    set_text_width(w)

    vim.notify("Hard wrap is enabled at " .. w)
end

function M.set_soft_wrap()
    vim.cmd("set wrap!")
    set_text_width(0)

    vim.notify("Soft wrap is enabled")
end

local options = { noremap = true }
vim.keymap.set('n', '<leader>th', function() M.set_hard_wrap(120) end, options)
vim.keymap.set('n', '<leader>ts', M.set_soft_wrap, options)

return M
