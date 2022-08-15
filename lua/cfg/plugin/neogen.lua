local M = {}

function M.setup()
    local ng = require('neogen')
    ng.setup({
        snippet_engine = 'luasnip',
        languages = {
            cs = {
                template = {
                    annotation_convention = 'xmldoc',
                },
            },
        },
    })

    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<Leader>/f', function()
        ng.generate({ type = 'class' })
    end, opts)

    vim.keymap.set('n', '<Leader>/f', function()
        ng.generate({ type = 'func' })
    end, opts)

    vim.keymap.set('n', '<Leader>//', function()
        ng.generate({})
    end, opts)
end

return M
