local spiner = {
    create = function()
        return {
            _index = 0,
            _frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
            render_next = function(self)
                self._index = self._index + 1
                return self._frames[self._index % #self._frames + 1]
            end
        }
    end
}

local function make(cmd, args, efm)
    local title = string.format('%s %s', cmd, table.concat(args, ' '))

    local progress = spiner.create()
    local job = require('plenary').job:new({
        command = cmd,
        args = args,
        cwd = vim.loop.cwd(),
        on_stdout = function(_, data)
            vim.schedule(function()
                vim.fn.setqflist({}, 'a', {
                    title = string.format('%s %s', progress:render_next(), title),
                    lines = { data },
                    efm = efm,
                })
            end)
        end,
        on_exit = function(_, exit_code)
            vim.schedule(function()
                vim.notify(string.format('"%s" finished with code: %d', title, exit_code))
                vim.fn.setqflist({}, 'a', {
                    title = title,
                    lines = {}
                })
            end)
        end,
    })

    vim.fn.setqflist({}, 'f')
    vim.cmd('copen')
    job:start()
end

local M = {
    build_efm = '%-ABuild%.%#,%-ZTime%.%#,%-C%.%#,%f(%l\\,%c): %trror %m [%.%#],%f(%l\\,%c): %tarning %m [%.%#],%-G%.%#',
    test_efm = '%E%.%#Failed %m [%.%#],%-C%.%#Error Message%.%#,%-C%.%#Stack Trace%.%#,%Z%.%#in %f:line %l,%C%m,Failed!%.%# - %m - %o %.%#,Passed!%.%# - %m - %o %.%#,%-G%.%#',
    resharper_inspect_cmd = 'jb InspectCode --absolute-paths --severity=HINT --no-build --format=Text',
    resharper_inspect_efm = ' %#%f:%l %m,%-G%.%#',
}

function M.set_target(path)
    if #path > 0 then
        vim.g.dotnet_target = path
        vim.notify(string.format('Set dotnet target to: %s', vim.g.dotnet_target))
        return
    end

    require('telescope.builtin').find_files({
        prompt_tilte = 'Dotnet Targets',
        find_command = {
            'rg', '--files', '-g', '*.{sln,csproj}', '.'
        },
        attach_mappings = function ()
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')
            actions.select_default:replace(function(buffer)
                vim.g.dotnet_target = action_state.get_selected_entry().value
                actions.close(buffer)
                vim.schedule(function()
                    vim.notify(string.format('Set dotnet target to: %s', vim.g.dotnet_target))
                end)
            end)
            return true
        end,
    })
end

function M.get_target()
    return vim.g.dotnet_target or nil
end

function M.set_configuration(value)
    vim.g.dotnet_configuration = value
    print(string.format('Set dotnet configuration to: %s', value))
end

function M.get_configuration()
    return vim.g.dotnet_configuration or 'Debug'
end

function M.set_test_filter(filter)
    local function escape(test)
        local t = test
        t = string.gsub(t, '%(', '\\(')
        t = string.gsub(t, '%)', '\\)')
        t = string.gsub(t, '"', '\\"')
        return 'Name~'..t
    end

    if #filter > 0 then
        vim.g.dotnet_test_filter = escape(filter)
        vim.notify(string.format('Set test filter to: %s', filter))
        return
    end

    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local config = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    pickers.new(
        {},
        {
            prompt_tilte = 'Dotnet Tests',
            sorter = config.generic_sorter(),
            finder = finders.new_oneshot_job(
                {'dotnet', 'test', '-t', '-v', 'q' },
                {
                    entry_maker = function(entry)
                        local i, j = string.find(entry, '^%s+')
                        if i ~= nil then
                            local s = string.sub(entry, j + 1)
                            return {
                                value = s,
                                display = s,
                                ordinal = s,
                            }
                        end
                        return nil
                    end
                }),
            attach_mappings = function(prompt_bufnr, _)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry().value
                    vim.g.dotnet_test_filter = escape(selection)
                end)
                return true
            end,
        }
    ):find()
end

function M.get_filter()
    return vim.g.dotnet_test_filter
end

function M.build()
    local target = M.get_target()
    if target == nil then
        print('No target is specified!')
        return
    end

    make(
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
    local target = M.get_target()
    if target == nil then
        print('No target is specified!')
        return
    end

    local args = { 'test', target }

    local filter = M.get_filter()
    if filter ~= nil then
        table.insert(args, '--filter')
        table.insert(args, filter)
    end

    make('dotnet', args, M.test_efm)
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

    vim.fn.setqflist({}, 'a', {
        title = 'ReSharper inspection of staged',
        lines = vim.fn.readfile(output),
        efm = M.resharper_inspect_efm,
    })
    vim.cmd('copen')
end

return M
