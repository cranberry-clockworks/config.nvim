local M = {}

function M.setup()
    local nls = require('null-ls')
    local settings = vim.opt.runtimepath:get()[1] .. 'vale.ini'
    nls.setup({
        sources = {
            nls.builtins.diagnostics.vale.with({
                '--config="'.. settings .. '"'
            }),
        },
    })
end

return M
