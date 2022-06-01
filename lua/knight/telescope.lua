local M = {}

local function build_limited_previewer(filepath, bufnr, opts)
    local previewers = require('telescope.previewer')
    opts = opts or {}

    filepath = vim.fn.expand(filepath)
    vim.loop.fs_stat(filepath, function(_, stat)
        if not stat then return end
        if stat.size > 100000 then
            return
        else
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
        end
    end)
end

function M.theme(preview)
    local config = require('telescope.themes').get_dropdown({
        borderchars = {
            { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
            prompt = {"─", "│", " ", "│", '┌', '┐', "│", "│"},
            results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
            preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
        },
        width = 0.8,
        prompt_title = false,
        preview_title = false
    })

    if not preview then
        config.previewer = false
    end

    return config
end

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
        }
    })

    local builtin = require('telescope.builtin')
    local previewers = require('telescope.previewers')
    local options = { noremap = true }
    vim.keymap.set('n', '<leader>ff', function() builtin.find_files(M.theme()) end, options)
    vim.keymap.set('n', '<leader>ft', function() builtin.filetypes(M.theme()) end, options)
    vim.keymap.set('n', '<leader>fg', function() builtin.live_grep(M.theme(true)) end, options)
    vim.keymap.set('n', '<leader>fb', function() builtin.buffers(M.theme()) end, options)
    vim.keymap.set('n', '<leader>gb', function() builtin.git_branches(M.theme()) end, options)
    vim.keymap.set('n', '<leader>gs', function() builtin.git_status(M.theme()) end, options)
    vim.keymap.set('n', '<leader>fz', function() builtin.spell_suggest(M.theme()) end, options)
end

return M
