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
    end

    dotnet_clean = function(prompt_bufnr)
        local current_picker = action_state.get_selected_entry(prompt_bufnr)
        vim.cmd(string.format("!dotnet clean \"%s\"", current_picker.value));
    end
    
    -- Relies on the dotnet-format:
    -- https://github.com/dotnet/format
    -- To quick install execute:
    -- dotnet tool install -g dotnet-format
    dotnet_format = function(prompt_bufnr)
        local current_picker = action_state.get_selected_entry(prompt_bufnr)
        vim.cmd(string.format("!dotnet-format \"%s\"", current_picker.value));
    end

    dotnet_run = function(prompt_bufnr)
        local current_picker = action_state.get_selected_entry(prompt_bufnr)
        vim.cmd(string.format("!dotnet run -p \"%s\"", current_picker.value));
    end

    dotnet_test = function(prompt_bufnr)
        local current_picker = action_state.get_selected_entry(prompt_bufnr)
        vim.cmd(string.format("!dotnet test \"%s\"", current_picker.value));
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
            map('i', '<C-b>', dotnet_build)
            map('n', '<C-b>', dotnet_build)

            map('i', '<C-c>', dotnet_clean)
            map('n', '<C-c>', dotnet_clean)

            map('i', '<C-f>', dotnet_format)
            map('n', '<C-f>', dotnet_format)

            map('i', '<C-r>', dotnet_run)
            map('n', '<C-r>', dotnet_run)

            map('i', '<C-t>', dotnet_test)
            map('n', '<C-t>', dotnet_test)
            
            map('i', '<CR>', function(_) end)
            map('n', '<CR>', function(_) end)
            
            return true
        end
    }):find()
end
