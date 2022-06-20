local M = {}

function M.setup()
    local nls = require('null-ls')
    local config = vim.fn.expand(vim.opt.runtimepath:get()[1] .. '/vale.ini')
    nls.setup({
        sources = {
            nls.builtins.diagnostics.vale.with({
                extra_args = { '--config', config },
                extra_filetypes = { 'gitcommit' },
            }),
        },
    })
end

return M
