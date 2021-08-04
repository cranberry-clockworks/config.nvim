local set_hl = function(group, options)
  local bg = options.bg == nil and '' or 'guibg=' .. options.bg
  local fg = options.fg == nil and '' or 'guifg=' .. options.fg
  local gui = options.gui == nil and '' or 'gui=' .. options.gui

  vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
end

set_hl('StatusLineLspInfo', { fg = "#010101", bg = "#010101"})

local function get_git_branch()
    local branch = vim.fn['FugitiveHead']()
    if not branch or branch == "" then
        branch = "--"
    end
    return string.format('[%s]', branch)
end

local function get_lsp_info()
    if vim.lsp.buf.server_ready() then
        local hints = vim.lsp.diagnostic.get_count(0, 'Hint')
        local warnings = vim.lsp.diagnostic.get_count(0, 'Warning')
        local errors = vim.lsp.diagnostic.get_count(0, 'Error')
        return string.format('H:%d W:%d E:%d ', hints, warnings, errors)
    else
        return '[No LSP]'
    end
end

local function is_modified()
    if vim.bo.modified then
        return ' [+]'
    end

    return ''
end

local function get_file_info()
    local filetype = vim.bo.filetype
    if #filetype > 0 then
        filetype = '[' .. filetype .. ']'
    end

    local encoding = vim.bo.fileencoding
    if vim.bo.bomb then
        encoding = encoding .. " bom"
    end
   
    return string.format('%s[%s][%s]',
        filetype,
        encoding,
        vim.bo.fileformat
    )
end

function get_flags()
    return '%h%w%m%r'
end

function get_file_name()
    return '%<%f'
end

function color_as(value, group)
    return string.format('%%#%s#%s', group, value)
end

local status_line_template = '%s%s%%=%s%%=%s%s'

function RenderStatusLine()
    return string.format(
        status_line_template,
        color_as(get_lsp_info(), 'StatusLineNC'),
        color_as(get_flags(), 'StatusLine'),
        color_as(get_file_name(), 'StatusLine'),
        color_as(get_git_branch(), 'StatusLineNC'),
        color_as(get_file_info(), 'StatusLineNC')
    )  

end

vim.o.statusline = '%!v:lua.RenderStatusLine()'

