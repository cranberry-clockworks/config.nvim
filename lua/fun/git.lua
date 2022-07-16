local M = {}

function M.get_staged()
    local result = {}
    require('plenary').job
        :new({
            command = 'git',
            args = {
                'diff',
                '--name-only',
                '--cached',
                '--diff-filter=ACM',
                '--relative',
            },
            cwd = vim.loop.cwd(),
            on_stdout = function(_, line)
                table.insert(result, line)
            end,
        })
        :sync()
    return result
end

return M
