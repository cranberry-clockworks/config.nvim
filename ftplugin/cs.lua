local fun = require('fun')
local dotnet = require('dotnet')

fun.text.set_hard_wrap(120, true)

vim.api.nvim_create_user_command(
    'DotnetTarget',
    function(opts)
        dotnet.set_target(opts.args)
    end,
    {
        nargs = '?',
        complete = 'file',
        force = true,
    }
)

vim.api.nvim_create_user_command(
    'DotnetBuild',
    dotnet.build,
    {
        nargs = 0,
        force = true,
    }
)

vim.api.nvim_create_user_command(
    'DotnetRun',
    dotnet.run,
    {
        nargs = 0,
        force = true,
    }
)

vim.api.nvim_create_user_command(
    'DotnetTestFilter',
    function (opts)
        dotnet.set_test_filter(opts.args)
    end,
    {
        nargs = '?',
        force = true
    }
)

vim.api.nvim_create_user_command(
    'DotnetTest',
    dotnet.test,
    {
        nargs = 0,
        force = true
    }
)

vim.api.nvim_create_user_command(
    'DotnetInspect',
    function ()
        local staged = fun.git.get_staged()
        dotnet.inspect(staged)
    end,
    {
        nargs = 0,
        force = true,
    }
)

-- Check spelling for code
vim.wo.spell = true
vim.bo.spellfile = vim.fn.expand(vim.fn.stdpath('config')..'/spell/csharp.utf-8.add')
vim.bo.spelloptions = 'camel'
vim.bo.spellcapcheck = ''
