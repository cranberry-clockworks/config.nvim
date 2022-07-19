local function get_lsp_info()
    if vim.lsp.buf.server_ready() then
        return string.format(
            '%d:%d:%d:%d',
            #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
            #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
            #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }),
            #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        )
    else
        return ''
    end
end

local function get_file_info()
    local filetype = vim.bo.filetype
    if #filetype > 0 then
        filetype = filetype .. ' '
    end

    local encoding = vim.bo.fileencoding
    if #encoding > 0 and vim.bo.bomb then
        encoding = encoding .. '-bom'
    end
    if #encoding > 0 then
        encoding = encoding .. ' '
    end

    return string.format('%s%s%s', filetype, encoding, vim.bo.fileformat)
end

local function get_flags()
    return '%h%w%m%r'
end

local function get_file_name()
    return '%<%f'
end

local status_line_template = '%s%s%%=%s%%=%s'

function RenderStatusLine()
    return string.format(
        status_line_template,
        get_lsp_info(),
        get_flags(),
        get_file_name(),
        get_file_info()
    )
end

return {
    setup = function()
        vim.o.statusline = '%!v:lua.RenderStatusLine()'
    end,
}
