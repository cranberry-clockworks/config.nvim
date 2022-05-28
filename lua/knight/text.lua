function set_text_width(width)
    local w = width or vim.call('input', 'Enter new text width: ')
    vim.opt.textwidth = tonumber(w)
    vim.opt.colorcolumn = tostring(w)
end
