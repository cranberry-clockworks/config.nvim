local fun = require('fun')
fun.text.set_hard_wrap(120, true)

local function analyze(opts)
    local fargs = opts.args
    local staged = fun.git.get_staged()
    local args = string.format('--include="%s" %s', table.concat(staged, ';'), fargs)

    vim.cmd('compiler resharper_inspect')
    local efm = vim.o.efm
    local output = vim.g.resharper_inspect_output

    vim.cmd('make ' .. args)
    vim.o.efm = ' %#%f:%l %m,%-G%.%#'
    vim.cmd('cfile '..output)
    vim.cmd('copen')
    vim.o.efm = efm
end

vim.api.nvim_create_user_command(
    'ReSharperInspectStaged',
    analyze,
    {
        desc = 'Analyze staged git files with ReSharper CLI InspectCode',
        nargs = "*",
        force = true,
        complete = 'file'
    }
)

vim.wo.spell = true
vim.bo.spellfile = vim.fn.expand(vim.fn.stdpath('config')..'/spell/csharp.utf-8.add')
vim.bo.spelloptions = 'camel'
vim.bo.spellcapcheck = ''

