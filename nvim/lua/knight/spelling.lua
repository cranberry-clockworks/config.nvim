local current_language = ''

function toggle_spellcheck(language)
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
