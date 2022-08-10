local M = {}

function M.setup()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')

    telescope.setup({
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
            borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
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
        },
        pickers = {
            find_files = {
                previewer = false
            },
            buffers = {
                previewer = false,
                mappings = {
                    i = { ['<c-w>'] = 'delete_buffer' },
                    n = { ['<c-w>'] = 'delete_buffer' }
                }
            },
            filetypes = {
                previewer = false,
            },
            git_status = {
                previewer = false,
            },
        },
        extensions = {
            file_browser = {
                dir_icon = '■',
            }
        }
    })

    telescope.load_extension('compiler')
    telescope.load_extension('file_browser')

    local options = require('cfg.keymaps').options

    vim.keymap.set('n', '<leader>ff', builtin.find_files, options)
    vim.keymap.set('n', '<leader>ct', builtin.filetypes, options)
    vim.keymap.set('n', '<leader>cc', '<cmd>Telescope compiler<cr>', options)
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, options)
    vim.keymap.set('n', '<leader>fb', builtin.buffers, options)
    vim.keymap.set('n', '<leader>gb', builtin.git_branches, options)
    vim.keymap.set('n', '<leader>gs', builtin.git_status, options)
    vim.keymap.set('n', '<leader>cz', builtin.spell_suggest, options)
    vim.keymap.set('n', '<leader>fe', '<cmd>Telescope file_browser path=%:p:h<cr>', options)
    vim.keymap.set('n', '<leader>fc', '<cmd>Telescope file_browser<cr>', options)
end

return M
