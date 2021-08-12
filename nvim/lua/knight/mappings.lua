-- Leader key
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<space>', '', { noremap = true })

-- Quick lists
vim.api.nvim_set_keymap('n', '<C-j>', "<cmd>cnext<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', "<cmd>cprev<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l><C-l>', "<cmd>cclose<cr>", { noremap = true })

-- Local lists
vim.api.nvim_set_keymap('n', '<M-j>', "<cmd>lnext<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<M-k>', "<cmd>lprev<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<M-l><M-l>', "<cmd>lclose<cr>", { noremap = true })

-- Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fr', "<cmd>lua require('telescope.builtin').git_branches()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fs', "<cmd>lua require('telescope.builtin').git_status()<cr>", { noremap = true })

-- Dotnet tools
vim.api.nvim_set_keymap('n', '<leader>db', "<cmd>lua dotnet_tool('build')<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dc', "<cmd>lua dotnet_tool('clean')<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>df', "<cmd>lua dotnet_tool('format')<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dr', "<cmd>lua dotnet_tool('run')<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dt', "<cmd>lua dotnet_tool('test')<cr>", { noremap = true })

-- Other
vim.api.nvim_set_keymap('n', '<leader>ss', "<cmd>nohlsearch<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>qb', "<cmd>bufdo bd<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ee', "<cmd>lua toggle_spellcheck('en')<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>er', "<cmd>lua toggle_spellcheck('ru')<cr>", { noremap = true })

-- Knife
vim.api.nvim_set_keymap('n', '<leader>lg', "<cmd>lua require('knife').generate_xmldoc_under_cursor()<cr>", { noremap = true })
