local function file_picker(enrich, pattern)
    local find_files = require('telescope.builtin').find_files
    local actions = require('telescope.actions')
    local state = require('telescope.actions.state')

    find_files({
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                local item = state.get_selected_entry()[1]
                actions.close(prompt_bufnr)
                enrich({ item })
            end)
            return true
        end,
        find_command = { 'rg', '--files', '-g', pattern, '.' },
        previewer = false,
        prompt_title = 'Select Make Item'
    })
end

local config = {
    cs = {
        default = 'build',
        build = {
            command = 'dotnet',
            args = {
                'build'
            },
            efm = {
                '%-AMicrosoft%.%#',
                '%-ZBuild%.%#',
                '%-C%.%#',
                '%f(%l\\,%c): %trror %m [%.%#]',
                '%f(%l\\,%c): %tarning %m [%.%#]',
                '%-G%.%#',
            },
            picker = function(enrich)
                file_picker(enrich, '*{.csproj,.sln}')
            end,
        },
        run = {
            command = 'dotnet',
            args = { 'run', '--project' },
            picker = function(enrich)
                file_picker(enrich, '*{.csproj,.sln}')
            end,
        },
        test = {
            command = 'dotnet',
            args = { 'test' },
            picker = function(enrich)
                file_picker(enrich, '*{.csproj,.sln}')
            end,
        },
        inspect = {
            command = 'jb',
            args = { 'InspectCode', '-output="'..vim.fn.expand('$TEMP/inspection')..'"', '--format=Text', '-a' },
            picker = function(enrich)
                file_picker(enrich, '*{.csproj,.sln}')
            end,
            post = function()
                local efm = vim.o.efm
                vim.o.efm = ' %#%f:%l %m,%-G%.%#'
                vim.cmd(vim.fn.expand('cfile $TEMP/inspection'))
                vim.o.efm = efm
            end
        }
    },
}

local plenary = require('plenary')
local item = nil
local job = nil

local function create_title(command, args)
    return table.concat({ command, table.concat(args, ' ') }, ' ')
end

local function create_pipe(title, efm)
    return function(_, data)
        vim.schedule(function()
            vim.cmd('copen')
            vim.fn.setqflist({}, 'a', {
                title = title,
                lines = { data },
                efm = efm,
            })
        end)
    end
end

local function make(command, args, efm, post)
    if job ~= nil then
        vim.notify('There is another job is already running')
        return
    end

    post = post or function() end

    job = plenary.job:new({
        command = command,
        args = args,
        cwd = vim.loop.cwd(),
        on_stdout = create_pipe(create_title(command, args), efm),
        on_exit = function()
            vim.schedule(post)
            vim.schedule(function()
                vim.notify('Make job finished')
            end)
            job = nil
        end
    })

    if job == nil then
        return
    end

    vim.fn.setqflist({}, 'f')
    job:start()
end

local M = {}

local function head_and_tail(str)
    local pos = str:find('%s+')
    if pos == nil then
        return str, nil
    end
    return str:sub(1, pos-1), str:sub(pos+1)
end

local defaults = {
    picker = function(enrich)
        enrich({ vim.fn.expand('%') })
    end,
    efm = '%m',
}

function M.run(target, arguments)
    target = target or 'default'
    arguments = arguments or {}

    local targets = config[vim.o.filetype] or {}

    if (target == 'default') then
        target = targets[target]
    end

    local t = targets[target] or {}

    local command
    local efm
    local args = {}
    local make_item = t.make_item or nil
    local post = t.post or nil

    local use_makeprg = t.command == nil
    if use_makeprg then
        local makeprg_command, makeprg_args = head_and_tail(vim.o.makeprg)
        command = makeprg_command
        table.insert(args, makeprg_args)
        efm = vim.o.efm
        if (make_item == nil) then
            defaults.picker(function(value)
                make_item = value
            end)
        end
    else
        command = t.command
        args = t.args
        efm = t.efm or defaults.efm
        if (make_item == nil) then
            vim.notify('There is no active make item')
            return
        end
    end

    if type(efm) == 'table' then
        efm = table.concat(efm, ',')
    end

    for _, v in ipairs(make_item) do
        table.insert(args, v)
    end

    for _,v in ipairs(arguments) do
        table.insert(args, v)
    end

    make(command, args, efm, post)
end

function M.cancel()
    if job == nil then
        return
    end
    job:shutdown()
end

function M.select(target)
    target = target or 'default'

    local targets = config[vim.o.filetype] or {}

    if (target == 'default') then
        target = targets[target]
    end

    local t = targets[target] or {}

    local picker = t.picker or defaults.picker

    picker(function(value)
        t.make_item = value
    end)
end

vim.keymap.set('n', '<leader>bs', M.select, { noremap = true })
vim.keymap.set('n', '<leader>bb', M.run, { noremap = true })
vim.keymap.set('n', '<leader>rs', function() M.select('run') end, { noremap = true })
vim.keymap.set('n', '<leader>rr', function() M.run('run') end, { noremap = true })
vim.keymap.set('n', '<leader>ts', function() M.select('test') end, { noremap = true })
vim.keymap.set('n', '<leader>tt', function() M.run('test') end, { noremap = true })
vim.keymap.set('n', '<leader>is', function() M.select('inspect') end, { noremap = true })
vim.keymap.set('n', '<leader>ii', function() M.run('inspect') end, { noremap = true })

return M
