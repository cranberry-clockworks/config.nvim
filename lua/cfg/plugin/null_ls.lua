local M = {}

function M.setup()
    local nls = require('null-ls')

    local vale_config =
        vim.fn.expand(vim.opt.runtimepath:get()[1] .. '/vale.ini')
    nls.setup({
        on_attach = require('cfg.plugin.lsp').map_keys,
        sources = {
            nls.builtins.diagnostics.vale.with({
                extra_args = { '--config', vale_config },
                extra_filetypes = { 'gitcommit' },
            }),
            nls.builtins.formatting.stylua,
            nls.builtins.formatting.prettier,
        },
    })
end

return M
