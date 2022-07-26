local M = {}

function M.map_keys(_, bufnr)
    local options = require('cfg.keymaps').options
    options['buffer'] = bufnr

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, options)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, options)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, options)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, options)
    vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, options)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, options)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, options)
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.formatting, options)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, options)
    vim.keymap.set(
        'n',
        '<leader>wr',
        vim.lsp.buf.remove_workspace_folder,
        options
    )
    vim.keymap.set('n', '<leader>ws', function()
        require('telescope.builtin').lsp_workspace_symbols()
    end, options)
end

function M.setup()
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = true,
        severity_sort = false,
    })

    require('mason').setup()
    require('mason-lspconfig').setup({
        automatic_installation = true,
    })

    local configuration = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )

    configuration.omnisharp.setup({
        on_attach = M.map_keys,
        capabilities = capabilities,
    })

    configuration.sumneko_lua.setup({
        on_attach = M.map_keys,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                diagnostics = {
                    globals = { 'vim' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file('', true),
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })
end

return M
