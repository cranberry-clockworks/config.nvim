local map_opts = {noremap = true, silent = true}

-- Diagnostics
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, map_opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, map_opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, map_opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, map_opts)

-- Quick lists
vim.keymap.set('n', '<c-down>', "<cmd>cnext<cr>", map_opts)
vim.keymap.set('n', '<c-up>', "<cmd>cprev<cr>", map_opts)

-- Local lists
vim.keymap.set('n', '<M-down>', "<cmd>lnext<cr>", map_opts)
vim.keymap.set('n', '<M-up>', "<cmd>lprev<cr>", map_opts)

-- Diff
vim.keymap.set('n', '<leader>cw', "<cmd>Gwrite<cr>", map_opts)
vim.keymap.set('n', '<leader>cl', "<cmd>diffget //2 | diffupdate<cr>", map_opts)
vim.keymap.set('n', '<leader>cr', "<cmd>diffget //3 | diffupdate<cr>", map_opts)

-- Other
vim.keymap.set('n', '<leader>ss', "<cmd>nohlsearch<cr>", map_opts)
vim.keymap.set('n', '<leader>se', function() require('fun.spelling').toggle_spellcheck() end, map_opts)
