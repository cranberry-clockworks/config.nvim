" Find files using Telescope command-line sugar.
nnoremap <M-f> <cmd>Telescope find_files<cr>
nnoremap <M-g> <cmd>Telescope live_grep<cr>
nnoremap <M-b> <cmd>Telescope buffers<cr>
nnoremap <M-n> <cmd>Telescope git_branches<cr> 
nnoremap <M-s> <cmd>Telescope git_status<cr>

lua <<EOF

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_position = "bottom",
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_defaults = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 0,
    width = 0.75,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 0.8,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}


dotnet_picker = function(opts)
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local sorters = require('telescope.sorters')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    dotnet_build = function(prompt_bufnr)
        local current_picker = action_state.get_selected_entry(prompt_bufnr)
        vim.cmd(string.format("!dotnet build \"%s\"", current_picker.value));
        actions.close(prompt_bufnr)
    end

    local cmd = { 'rg','-g', '*{csproj,sln}', '--files', '.' }

    pickers.new(opts, {
        prompt_title = "dotnet",
        finder = finders.new_oneshot_job(
            cmd,
            opts
        ),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(_, map)
            -- Map "<cr>" in insert mode to the function, actions.set_command_line
            map('i', '<C-b>', dotnet_build)
            map('n', '<C-b>', dotnet_build)

            -- If the return value of `attach_mappings` is true, then the other
            -- default mappings are still applies.
            --
            -- Return false if you don't want any other mappings applied.
            --
            -- A return value _must_ be returned. It is an error to not return anything.
            return true
        end
    }):find()
end


EOF
