local M = {}

local function set_text_width(width)
    vim.opt.textwidth = tonumber(width)
    vim.opt.colorcolumn = tostring(width)
end

function M.set_hard_wrap(width, quiet)
    quiet = quiet or false

    local w = width or vim.call('input', 'Enter new text width: ')
    vim.cmd("set nowrap!")
    set_text_width(w)

    if quiet == false then
        vim.notify("Hard wrap is enabled at " .. w)
    end
end

function M.set_soft_wrap(quiet)
    quiet = quiet or false
    vim.cmd("set wrap!")
    set_text_width(0)

    if quiet == false then
        vim.notify("Soft wrap is enabled")
    end
end

local options = { noremap = true }
vim.keymap.set('n', '<leader>th', M.set_hard_wrap, options)
vim.keymap.set('n', '<leader>ts', M.set_soft_wrap, options)

vim.api.nvim_create_augroup('TextWrap', { clear = true })
vim.api.nvim_create_autocmd(
    {
        'BufNew',
        'BufRead',
    },
    {
        pattern = {
            '*.cs',
        },
        callback = function() M.set_hard_wrap(120, true) end,
    }
)

return M
