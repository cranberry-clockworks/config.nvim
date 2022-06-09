local ls = require('luasnip')

local M = {}

function M.setup()
    ls.config.set_config({
        history = true,
    })

    vim.keymap.set(
        { 'i', 's' },
        '<c-l>',
        function()
            print("Forward")
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end,
        { silent = true }
    )
    vim.keymap.set(
        { 'i', 's' },
        '<c-h>',
        function()
            print("Backward")
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end,
        { silent = true }
    )
end

return M
