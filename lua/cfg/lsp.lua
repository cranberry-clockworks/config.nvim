local M = {}

function M.setup()
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = true,
        severity_sort = false,
    })

    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, opts)

    require('nvim-lsp-installer').setup({
        automatic_installation = true,
    })

    local configuration = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    local function map_keys(_, bufnr)
        local o = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, o)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, o)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, o)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, o)
        vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, o)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, o)
        vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, o)
        vim.keymap.set('n', '<leader>lf', vim.lsp.buf.formatting, o)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, o)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, o)
        vim.keymap.set('n', '<leader>ws', function() require("telescope.builtin").lsp_workspace_symbols() end, o)
    end

    configuration.omnisharp.setup({
        on_attach = map_keys,
        capabilities = capabilities,
    })

    configuration.sumneko_lua.setup({
        on_attach = map_keys,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                diagnostics = {
                    globals = {'vim'},
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        }
    })
end

return M
