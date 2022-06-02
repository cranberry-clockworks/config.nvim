local M = {}

local on_attach = function(client, bufnr)
    local options = {
        buffer = bufnr,
        noremap = true,
        silent = true,
    }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, options)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, options)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, options)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, options)
    vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, options)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, options)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, options)
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.formatting, options)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, options)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, options)
    vim.keymap.set(
        'n',
        '<leader>ws',
        function ()
            require("telescope.builtin").lsp_workspace_symbols({previewer = false})
        end,
        options
    )
end

function M.setup_lsp()
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = true,
        severity_sort = false,
    })

    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

    require('nvim-lsp-installer').setup({
        automatic_installation = true,
    })

    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    local config = require('lspconfig')
    config.omnisharp.setup({
        on_attach = on_attach,
        capabilities = capabilities,
    })

    config.sumneko_lua.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        diagnostic = {
            globals = { 'vim' }
        },
    })
end

return M
