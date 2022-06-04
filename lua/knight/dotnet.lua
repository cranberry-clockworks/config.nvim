local find = require('telescope.builtin').find_files
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local M = {}

local function build(prompt_bufnr, _)
    actions.select_default:replace(function()
        local project = action_state.get_selected_entry()[1]
        actions.close(prompt_bufnr)
        vim.cmd('compiler dotnet_build')
        vim.cmd('make')
        vim.cmd('copen')
    end)
    return true
end

function M.build()
    find({
        attach_mappings = build,
        find_command = {
            'rg',
            '--files',
            '-g',
            '*.{csproj,sln}',
            '.',
        },
        previewer = false,
    })
end

vim.keymap.set('n', '<leader>db', M.build, { noremap = true })

return M
