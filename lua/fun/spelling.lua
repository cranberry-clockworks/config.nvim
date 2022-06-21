local M = {}

function M.toggle_spellcheck()
    if vim.wo.spell then
        vim.wo.spell = false
        print('Disable spellcheck')
        return
    end

    vim.wo.spell = true
    vim.bo.spelllang = 'en,ru'
    print('Enable spellcheck')
end

local options = { noremap = true }
vim.keymap.set('n', '<leader>ee', function() M.toggle_spellcheck() end, options)

return M
