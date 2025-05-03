local function notify(message)
    vim.schedule(function()
        vim.notify(message)
    end)
end

local function run(command)
    local temp_file_path = vim.fn.tempname()
    vim.api.nvim_exec(
        string.format('!%s | tee "%s"', command, temp_file_path),
        false
    )
    local output = vim.fn.readfile(temp_file_path)
    vim.loop.fs_unlink(temp_file_path)
    return output
end

local function select_project_with_telescope(callback)
    require('telescope.builtin').find_files({
        prompt_title = 'Select .NET project',
        search_file = '*.{sln,csproj}',
        attach_mappings = function()
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')
            actions.select_default:replace(function(buffer)
                callback(action_state.get_selected_entry().value)
                actions.close(buffer)
            end)
            return true
        end,
    })
end

local function select_debug_dll_with_telescope(callback)
    local root = vim.loop.cwd()

    local project_path = vim.g.dotet_build_target_path or ''
    if project_path:match('csproj$') then
        root = vim.fs.dirname(project_path)
    end

    local search_dirs = {}
    for line in string.gmatch(vim.fn.expand('**/bin'), "[^\n]+") do
        table.insert(search_dirs, line)
    end

    require('telescope.builtin').find_files({
        cwd = root,
        prompt_title = 'Select .NET debug DLL entry',
        search_dirs = search_dirs,
        search_file = '*.dll',
        no_ignore = true,
        attach_mappings = function()
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')
            actions.select_default:replace(function(buffer)
                callback(action_state.get_selected_entry().value)
                actions.close(buffer)
            end)
            return true
        end,
    })
end

local function has_warnings_or_erros(output)
    for _, line in ipairs(output) do
        local count = line:match('^%s*(%d+)%sWarning.*$')
            or line:match('^%s*(%d+)%sError.*$')
            or '0'
        if tonumber(count) > 0 then
            return true
        end
    end
    return false
end

local M = {
    build_efm = '%-ABuild%.%#,%-ZTime%.%#,%-C%.%#,%f(%l\\,%c): %trror %m [%.%#],%f(%l\\,%c): %tarning %m [%.%#],%-G%.%#',
}

function M.get_debug_dll_path()
    return vim.g.dotnet_debug_dll_path
end

function M.configure_build()
    select_project_with_telescope(function(path)
        vim.g.dotnet_build_target_path = path
        notify(string.format('Set .NET project to: "%s"', path))
    end)
end

function M.configure_debug()
    select_debug_dll_with_telescope(function(path)
        vim.g.dotnet_debug_dll_path = path
        notify(string.format('Set .NET debug DLL entry to: "%s"', path))
    end)
end

function M.build()
    local project_path = vim.g.dotnet_build_target_path
    if project_path == nil then
        notify('No .NET project selected!')
        return
    end
    local output = run(string.format('dotnet build "%s"', project_path))

    if not has_warnings_or_erros(output) then
        return
    end

    vim.fn.setqflist({}, 'r', {
        title = string.format('.NET Build results for "%s"', project_path),
        lines = output,
        efm = M.build_efm,
    })
    vim.cmd('copen')
end

function M.clean()
    local project_path = vim.g.dotnet_build_target_path
    local target = ''
    if project_path then
        target = string.format('"%s"', project_path)
    end
    vim.cmd(string.format('!dotnet clean %s', target))
end

function M.setup()
    vim.api.nvim_create_user_command(
        'DotnetTargetBuild',
        M.configure_build,
        { nargs = 0, force = true }
    )
    vim.api.nvim_create_user_command(
        'DotnetTargetDebug',
        M.configure_debug,
        { nargs = 0, force = true }
    )
    vim.api.nvim_create_user_command(
        'DotnetBuild',
        M.build,
        { nargs = 0, force = true }
    )
    vim.api.nvim_create_user_command(
        'DotnetClean',
        M.clean,
        { nargs = 0, force = true }
    )
end

return M
