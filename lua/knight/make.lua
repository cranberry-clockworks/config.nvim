local function split_on_command_and_args(makeprg)
    local cmd = makeprg
    local args = {}

    local pos = cmd:find('%s+')
    if pos == nil then
        return cmd, args
    end

    local rest = cmd:sub(pos + 1)
    cmd = cmd:sub(1, pos - 1)

    for arg in rest:gmatch('%S+') do
        table.insert(args, arg)
    end

    return cmd, args
end

local M = {}

function M.make_async(opts)
    local command, args = split_on_command_and_args(vim.o.makeprg)
    for _, v in ipairs(opts.fargs) do
        table.insert(args, v)
    end

    local efm = vim.o.efm
    local title = string.format('%s %s', command, opts.args)

    local job = require('plenary').job:new({
        command = command,
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
                vim.notify(string.format('Make job finished with code: %d', exit_code))
            end)
        end,
    })

    vim.fn.setqflist({}, 'f')
    vim.cmd('copen')
    job:start()
end

function M.make_sync(opts)
    vim.cmd('split')
    local cmd = string.format('%s %s', vim.o.makeprg, opts.args)
    vim.cmd(string.format('term %s', cmd))
end

vim.api.nvim_create_user_command(
    'MakeAsync',
    M.make_async,
    {
        nargs = "*",
        force = true,
        desc = 'Execute :make async'
    }
)

vim.api.nvim_create_user_command(
    'MakeSync',
    M.make_sync,
    {
        nargs = "*",
        force = true,
        desc = 'Execute :make sync'
    }
)
