local M = {}

function M.setup()
    require('telescope').setup ({
        defaults = {
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
            borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
        }
    })

    local builtin = require('telescope.builtin')
    local options = { noremap = true }
    vim.keymap.set('n', '<leader>ff', builtin.find_files, options)
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, options)
    vim.keymap.set('n', '<leader>fb', builtin.buffers, options)
    vim.keymap.set('n', '<leader>gb', builtin.git_branches, options)
    vim.keymap.set('n', '<leader>gs', builtin.git_status, options)
    vim.keymap.set('n', '<leader>fz', builtin.spell_suggest, options)
end

return M
