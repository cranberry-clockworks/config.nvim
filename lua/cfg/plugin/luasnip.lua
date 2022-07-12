local M = {}

function M.setup()
    local ls = require('luasnip')
    ls.config.set_config({
        history = true,
    })

    local map_opts = { silent = true, noremap = true }
    vim.keymap.set(
        { 'i', 's' },
        '<c-l>',
        function()
            print("Forward")
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end,
        map_opts
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
        map_opts
    )
end

return M
