local M = {}

function M.cfile(filename, efm, title)
    local file = io.open(filename, 'r')
    if file == nil then
        error("Can't open the file: "..filename)
    end

    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end

    file:close()

    vim.fn.setqflist({}, 'r', { title = title, lines = lines, efm = efm })
end

return M
