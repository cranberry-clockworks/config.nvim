local M = {
    options = { noremap = true },
}

M.setup = function()
    vim.g.mapleader = ' '

    -- Diagnostics
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, M.options)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, M.options)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, M.options)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, M.options)

    -- Quick lists
    vim.keymap.set('n', '<leader>c<down>', '<cmd>cnext<cr>', M.options)
    vim.keymap.set('n', '<leader>cj', '<cmd>cnext<cr>', M.options)
    vim.keymap.set('n', '<leader>c<up>', '<cmd>cprev<cr>', M.options)
    vim.keymap.set('n', '<leader>ck', '<cmd>cprev<cr>', M.options)
    vim.keymap.set('n', '<leader>co', '<cmd>copen<cr>', M.options)
    vim.keymap.set('n', '<leader>cc', '<cmd>cclose<cr>', M.options)

    -- Local lists
    vim.keymap.set('n', '<leader>l<down>', '<cmd>lnext<cr>', M.options)
    vim.keymap.set('n', '<leader>lj', '<cmd>lnext<cr>', M.options)
    vim.keymap.set('n', '<leader>l<up>', '<cmd>lprev<cr>', M.options)
    vim.keymap.set('n', '<leader>lk', '<cmd>lprev<cr>', M.options)
    vim.keymap.set('n', '<leader>lo', '<cmd>lopen<cr>', M.options)
    vim.keymap.set('n', '<leader>lc', '<cmd>lclose<cr>', M.options)

    -- Diff
    vim.keymap.set('n', '<leader>cw', '<cmd>Gwrite<cr>', M.options)
    vim.keymap.set(
        'n',
        '<leader>cl',
        '<cmd>diffget //2 | diffupdate<cr>',
        M.options
    )
    vim.keymap.set(
        'n',
        '<leader>cr',
        '<cmd>diffget //3 | diffupdate<cr>',
        M.options
    )

    -- Other
    vim.keymap.set('n', '<leader>ss', '<cmd>nohlsearch<cr>', M.options)
    vim.keymap.set('n', '<leader>se', function()
        require('fun.spelling').toggle_spellcheck()
    end, M.options)
end

return M
