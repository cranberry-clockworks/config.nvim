local quickfix = require('fun.quickfix')

local function make_qf(cmd, args, efm)
    local title = string.format('%s %s', cmd, table.concat(args, ' '))

    local job = require('plenary').job:new({
        command = cmd,
        args = args,
        cwd = vim.loop.cwd(),
        on_stdout = function(_, data)
            vim.schedule(function()
                vim.fn.setqflist({}, 'a', {
                    title = title,
                    lines = { data },
                    efm = efm,
                })
            end)
        end,
        on_exit = function(_, exit_code)
            vim.schedule(function()
                vim.notify(string.format('"%s" finished with code: %d', title, exit_code))
            end)
        end,
    })

    vim.fn.setqflist({}, 'f')
    vim.cmd('copen')
    job:start()
end

local M = {
    build_efm = '%-ABuild%.%#,%-ZTime%.%#,%-C%.%#,%f(%l\\,%c): %trror %m [%.%#],%f(%l\\,%c): %tarning %m [%.%#],%-G%.%#',
    resharper_inspect_cmd = 'jb InspectCode --absolute-paths --severity=HINT --no-build --format=Text',
    resharper_inspect_efm = ' %#%f:%l %m,%-G%.%#',
}

function M.set_target(path, global)
    global = global or false
    if global then
        vim.g.dotnet_target = path
        print(string.format('Set global dotnet target to: %s', path))
    else
        vim.b.dotnet_target = path
        print(string.format('Set local dotnet target to: %s', path))
    end
end

function M.get_target()
    return vim.b.dotnet_target or vim.g.dotnet_target or nil
end

function M.set_configuration(value, global)
    global = global or false
    if global then
        vim.g.dotnet_configuration = value
        print(string.format('Set global dotnet configuration to: %s', value))
    else
        vim.b.dotnet_configuration = value
        print(string.format('Set dotnet configuration to: %s', value))
    end
end

function M.get_configuration()
    return vim.b.dotnet_configuration or vim.g.dotnet_configuration or 'Debug'
end

function M.build()
    local target = M.get_target()
    if target == nil then
        print('No target is specified!')
        return
    end

    make_qf(
        'dotnet',
        {
            'build',
            '-c',
            M.get_configuration(),
            target,
        },
        M.build_efm
    )
end

function M.run()
    local target = M.get_target()
    if target == nil then
        print('No target is specified!')
        return
    end

    vim.cmd(string.format('!dotnet run -c %s --project %s', M.get_configuration(), target))
end

function M.test()
end

function M.inspect(files)
    local target = M.get_target()
    if target == nil then
        print('No target is specified!')
        return
    end

    local output = vim.fn.tempname()

    vim.cmd(
        string.format(
            '!%s --output="%s" --include="%s" %s',
            M.resharper_inspect_cmd,
            output,
            table.concat(files, ';'),
            target
        )
    )

    quickfix.cfile(output, M.resharper_inspect_efm, 'ReSharper InspectCode result')
    vim.cmd('copen')
end

return M
