-- Leader key
vim.api.nvim_set_keymap('n', '<space>', '', { noremap = true })

-- Quick lists
vim.api.nvim_set_keymap('n', '<C-j>', "<cmd>cnext<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', "<cmd>cprev<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l><C-l>', "<cmd>cclose<cr>", { noremap = true })

-- Local lists
vim.api.nvim_set_keymap('n', '<M-j>', "<cmd>lnext<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<M-k>', "<cmd>lprev<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<M-l><M-l>', "<cmd>lclose<cr>", { noremap = true })

-- Other
vim.api.nvim_set_keymap('n', '<leader>ss', "<cmd>nohlsearch<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>qb', "<cmd>bufdo bd<cr>", { noremap = true })
