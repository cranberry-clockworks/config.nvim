local cmp = require('cmp')

cmp.setup({
    completion = {
        autocomplete = true
    },
    snippet = {
        expand = function(args)
        end,
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    },
    documentation = {
        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
    }

})

local icons = {
    Class = "C class ",
    Color = "⭘ color ",
    Constant = "κ const ",
    Constructor = "c constructor ",
    Enum = "ξ enum ",
    EnumMember = "ε enum value",
    Field = "ℓ field ",
    File = "■ file ",
    Folder = "□ folder ",
    Function = "ƒ fn ",
    Interface = "Ï interface ",
    Keyword = "κ keyword ",
    Method = "ƒ method ",
    Module = "∷ module ",
    Property = "π property ",
    Snippet = "⚡snippet ",
    Struct = "S struct ",
    Text = "ä text ",
    Unit = "ū unit ",
    Value = "⌘ value ",
    Variable = "μ variable ",
}

local kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(kinds) do
    kinds[i] = icons[kind] or kind
end

local on_attach = function(client)
    require('lsp_signature').on_attach({
        bind = true,
        hint_prefix = "> ",
        handler_opts = { border = "single" },
        extra_trigger_chars = { '(', ',' },
    })

    capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )

    local border = {
        {"╭", "FloatBorder"},
        {"─", "FloatBorder"},
        {"╮", "FloatBorder"},
        {"│", "FloatBorder"},
        {"╯", "FloatBorder"},
        {"─", "FloatBorder"},
        {"╰", "FloatBorder"},
        {"│", "FloatBorder"},
    }

    vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, { border = border })

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <C-X><C-O>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>lq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    buf_set_keymap("n", "<leader>ls", "<cmd>Telescope lsp_workspace_symbols<CR>", opts)
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

    vim.api.nvim_exec([[
        autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = { "TypeHint", "ChainingHint", "ParameterHint" } }
    ]], false)
end

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

-- Configure Rust-Analyzer language server for Rust
-- https://github.com/neovim/nvim-lspconfig
require('lspconfig').rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})

-- Configure OmniSharp-Roslyn language server for C#
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#omnisharp

local pid = vim.fn.getpid()
local omnisharp_bin = "C:/Program Files/nvim/lsp/omnisharp-win-x64/OmniSharp.exe"

require('lspconfig').omnisharp.setup({
    on_attach = on_attach,
    cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) }
})


-- Configure Sumneko language server for Lua
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua
local sumneko_root = 'C:/Program Files/nvim/lsp/lua-language-server/'
local sumneko_bin = sumneko_root .. 'bin/Windows/lua-language-server'
local sumneko_main = sumneko_root .. 'main.lua'

local sumneko_runtime_path = vim.split(package.path, ';')
table.insert(sumneko_runtime_path, "lua/?.lua")
table.insert(sumneko_runtime_path, "lua/?/init.lua")

local sumneko_libs = {}
sumneko_libs[vim.fn.expand('$VIMRUNTIME/lua')] = true
sumneko_libs[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
sumneko_libs[vim.fn.stdpath("config") .. '/lua'] = true
sumneko_libs[vim.fn.stdpath("config") .. '/plugged/plenary.nvim/lua'] = true
sumneko_libs[vim.fn.stdpath("config") .. '/plugged/nvim-treesitter/lua'] = true

-- Dev
sumneko_libs['C:/Users/Knight/Documents/GitHub/knife/lua'] = true

require('lspconfig').sumneko_lua.setup {
    on_attach = on_attach,
    cmd = {sumneko_bin, '-E', sumneko_main};
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = sumneko_runtime_path,
            },
            diagnostics = {
                globals = {'vim'},
                disable = { 'lowercase-global' }
            },
            workspace = {
                library = sumneko_libs,
                preloadFileSize = 450,
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
