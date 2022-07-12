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
    vim.keymap.set('n', '<c-down>', "<cmd>cnext<cr>", M.options)
    vim.keymap.set('n', '<c-up>', "<cmd>cprev<cr>", M.options)

    -- Local lists
    vim.keymap.set('n', '<M-down>', "<cmd>lnext<cr>", M.options)
    vim.keymap.set('n', '<M-up>', "<cmd>lprev<cr>", M.options)

    -- Diff
    vim.keymap.set('n', '<leader>cw', "<cmd>Gwrite<cr>", M.options)
    vim.keymap.set('n', '<leader>cl', "<cmd>diffget //2 | diffupdate<cr>", M.options)
    vim.keymap.set('n', '<leader>cr', "<cmd>diffget //3 | diffupdate<cr>", M.options)

    -- Other
    vim.keymap.set('n', '<leader>ss', "<cmd>nohlsearch<cr>", M.options)
    vim.keymap.set('n', '<leader>se', function() require('fun.spelling').toggle_spellcheck() end, M.options)
end

return M
