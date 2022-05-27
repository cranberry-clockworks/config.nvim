-- skywind3000/asyncrun.vim is used

local term = "AsyncRun -mode=term -pos=bottom -focus=0"

local dotnet_build = function(project)
    vim.cmd(string.format("%s dotnet build \"%s\"", term, project))
end

local dotnet_clean = function(project)
    vim.cmd(string.format("%s dotnet clean \"%s\"", term, project))
end

-- Relies on the dotnet-format:
-- https://github.com/dotnet/format
-- To quick install execute:
-- dotnet tool install -g dotnet-format
local dotnet_format = function(project)
    vim.cmd(string.format("%s dotnet-format \"%s\"", term, project))
end

local dotnet_run = function(project)
    vim.cmd(string.format("%s dotnet run -p \"%s\"", term, project));
end

local dotnet_test = function(project)
    vim.cmd(string.format("%s dotnet test \"%s\"", term, project));
end

function dotnet_tool(command)
    if command == 'build' then
        func = dotnet_build
    elseif command == 'clean' then
        func = dotnet_clean
    elseif command == 'format' then 
        func = dotnet_format
    elseif command == 'run' then
        func = dotnet_run
    elseif command == 'test' then
        func = dotnet_test
    else 
        print('Uknown command!')
        return
    end

    local results = {}
    local job = require('plenary.job'):new { 
        command = 'rg', 
        args = { '--files', '-g', '*{csproj,sln}', '.' },
        cwd = vim.loop.cwd(),
        on_stdout = function(_, data) 
            table.insert(results, data)
        end, 
    } 

    job:sync() 

    table.sort(results) 

    for i,r in ipairs(results) do
        print(string.format('%i. %s', i, r))
    end

    i = tonumber(vim.call('input', string.format('Select project to %s: ', command)))
   
    if i == nil or i < 0 or i > table.maxn(results) then
        return
    end

    func(results[i])
end

