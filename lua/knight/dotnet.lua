local project_grep_pattern = '*.{csproj,sln}'
local active_project = nil

local M = {}

function change_active_project_and_execute(action)
    local find_files = require('telescope.builtin').find_files
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    local function find_callback(prompt_bufnr, _)
        actions.select_default:replace(function()
            active_project = action_state.get_selected_entry()[1]
            actions.close(prompt_bufnr)
            action(active_project)
        end)
        return true
    end

    find_files({
        attach_mappings = find_callback,
        find_command = {
            'rg',
            '--files',
            '-g',
            project_grep_pattern,
            '.',
        },
        previewer = false,
        prompt_title = 'Select .NET Project',
    })
end

local function build(project)
    vim.cmd('compiler dotnet_build')
    vim.cmd('make '..project)
    vim.cmd('copen')
end

function M.build(force_find)
    force_find = force_find or false

    if force_find then
        active_project = nil
    end

    if active_project ~= nil then
        build(active_project)
        return
    end

    change_active_project_and_execute(build)
end

function M.drop_project_selection()
    active_project = nil
    print('Removed active .NET project')
end

vim.keymap.set('n', '<leader>dd', M.drop_project_selection, { noremap = true })
vim.keymap.set('n', '<leader>db', M.build, { noremap = true })

return M
