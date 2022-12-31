local function notify(message)
    vim.schedule(function()
        vim.notify(message)
    end)
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

    require('telescope.builtin').find_files({
        cwd = root,
        prompt_title = 'Select .NET debug DLL entry',
        search_dirs = { '**/bin' },
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

local M = {}

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

return M
