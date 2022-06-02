local M = {}

function M.setup()
    require('telescope').setup ({
        defaults = {
            layout_strategy = 'vertical',
            layout_config = {
                vertical = {
                    prompt_position = "top",
                    mirror = true,
                },
            },
            sorting_strategy = 'ascending',
            prompt_tile = false,
            borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--trim",
            },
        }
    })

    local builtin = require('telescope.builtin')
    local previewers = require('telescope.previewers')
    local options = { noremap = true }
    vim.keymap.set('n', '<leader>ff', function() builtin.find_files({previewer = false}) end, options)
    vim.keymap.set('n', '<leader>ft', function() builtin.filetypes({previewer = false}) end, options)
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, options)
    vim.keymap.set('n', '<leader>fb', function() builtin.buffers({previewer = false}) end, options)
    vim.keymap.set('n', '<leader>gb', function() builtin.git_branches({previewer = false}) end, options)
    vim.keymap.set('n', '<leader>gs', function() builtin.git_status({previewer = false}) end, options)
    vim.keymap.set('n', '<leader>fz', function() builtin.spell_suggest({previewer = false}) end, options)
end

return M
