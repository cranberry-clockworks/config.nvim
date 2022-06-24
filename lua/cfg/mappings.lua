local M = {}

function M.setup()
    local optins = {
        noremap = true,
        silent = true
    }

    -- Diagnostics
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

    -- Quick lists
    vim.keymap.set('n', '<c-down>', "<cmd>cnext<cr>", { noremap = true })
    vim.keymap.set('n', '<c-up>', "<cmd>cprev<cr>", { noremap = true })

    -- Local lists
    vim.keymap.set('n', '<M-down>', "<cmd>lnext<cr>", { noremap = true })
    vim.keymap.set('n', '<M-up>', "<cmd>lprev<cr>", { noremap = true })

    -- Diff
    vim.keymap.set('n', '<leader>dw>', "<cmd>Gwrite<cr>", { noremap = true })
    vim.keymap.set('n', '<leader>dl>', "<cmd>diffget //2 | diffupdate<cr>", { noremap = true })
    vim.keymap.set('n', '<leader>dr>', "<cmd>diffget //3 | diffupdate<cr>", { noremap = true })

    -- Other
    vim.keymap.set('n', '<leader>ss', "<cmd>nohlsearch<cr>", { noremap = true })
end

return M
