local set_hl = function(group, options)
    local bg = options.bg == nil and '' or 'guibg=' .. options.bg
    local fg = options.fg == nil and '' or 'guifg=' .. options.fg
    local gui = options.gui == nil and '' or 'gui=' .. options.gui

    vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
end
set_hl('StatusLineLspInfo', { fg = "#010101", bg = "#010101" })
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
        encoding = encoding .. "-bom"
    end
    if #encoding > 0 then
        encoding = encoding .. ' '
    end

    return string.format(
        '%s%s%s',
        filetype,
        encoding,
        vim.bo.fileformat
    )
end

local function get_flags()
    return '%h%w%m%r'
end

local function get_file_name()
    return '%<%f'
end

local function color_as(value, group)
    return string.format('%%#%s#%s', group, value)
end

local status_line_template = '%s%s%%=%s%%=%s'

function RenderStatusLine()
    return string.format(
        status_line_template,
        color_as(get_lsp_info(), 'StatusLineNC'),
        color_as(get_flags(), 'StatusLine'),
        color_as(get_file_name(), 'StatusLine'),
        color_as(get_file_info(), 'StatusLineNC')
    )
end

return {
    setup = function()
        vim.o.statusline = '%!v:lua.RenderStatusLine()'
    end
}
