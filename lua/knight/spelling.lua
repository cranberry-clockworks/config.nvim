local M = {}

local current_language = ''

function M.toggle_spellcheck(language)
    if language == current_language then
        current_language = ''
        vim.cmd('setlocal nospell')
        print('Disable spellcheck')
        return
    end

    current_language = language
    vim.cmd(string.format('setlocal spell spelllang=%s', language))
    print('Enable spellcheck for language:', language)
end

local options = { noremap = true }
vim.keymap.set('n', '<leader>ee', function() M.toggle_spellcheck('en') end, options)
vim.keymap.set('n', '<leader>er', function() M.toggle_spellcheck('ru') end, options)

return M
