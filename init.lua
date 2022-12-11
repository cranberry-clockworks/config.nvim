local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')
        .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({
            'git',
            'clone',
            '--depth',
            '1',
            'https://github.com/wbthomason/packer.nvim',
            install_path,
        })
        vim.cmd('packadd packer.nvim')
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
    use({ 'wbthomason/packer.nvim' })
    use({
        'rebelot/kanagawa.nvim',
        config = function()
            vim.cmd('colorscheme kanagawa')
        end,
    })
    use({ 'tpope/vim-fugitive' })
    use({ 'tpope/vim-surround' })
    use({
        'nvim-treesitter/nvim-treesitter',
        run = function()
            require('nvim-treesitter.install').compilers = { 'clang' }
            require('nvim-treesitter.install').update({ with_sync = true })()
        end,
        config = function()
            require('nvim-treesitter.configs').setup({
                auto_install = true,
                highlight = {
                    enable = true,
                },
            })
        end,
    })
    use({
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'cranberry-knight/telescope-compiler.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
        },
        config = function()
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case',
                        '--trim',
                    },
                },
                pickers = {
                    find_files = {
                        previewer = false,
                    },
                    buffers = {
                        previewer = false,
                        mappings = {
                            i = { ['<c-w>'] = 'delete_buffer' },
                            n = { ['<c-w>'] = 'delete_buffer' },
                        },
                    },
                },
                extensions = {
                    file_browser = {
                        previewer = false,
                        theme = 'ivy',
                        dir_icon = '■',
                        grouped = true,
                    },
                },
            })
            telescope.load_extension('compiler')
            telescope.load_extension('file_browser')
        end,
    })
    use({
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
            { 'jose-elias-alvarez/null-ls.nvim' },
        },
        config = function()
            local lsp = require('lsp-zero')
            -- lsp.preset('recommended')
            lsp.set_preferences({
                suggest_lsp_servers = true,
                setup_servers_on_start = true,
                set_lsp_keymaps = true,
                configure_diagnostics = true,
                cmp_capabilities = true,
                manage_nvim_cmp = true,
                call_servers = 'local',
                sign_icons = {
                    error = 'E',
                    warn = 'W',
                    hint = 'H',
                    info = 'I',
                },
            })

            lsp.configure('sumneko_lua', {
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

            local nls = require('null-ls')
            nls.setup({
                on_attach = lsp.build_options('null-ls').on_attach,
                sources = {
                    nls.builtins.diagnostics.vale.with({
                        extra_args = {
                            '--config',
                            vim.fn.expand(
                                vim.opt.runtimepath:get()[1] .. '/vale.ini'
                            ),
                        },
                        extra_filetypes = { 'gitcommit' },
                    }),
                    nls.builtins.formatting.stylua,
                    nls.builtins.formatting.prettier,
                },
            })

            lsp.setup()
        end,
    })
    use({
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
    })
    use({
        'danymat/neogen',
        requires = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
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
        end,
    })

    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- Essentials
vim.cmd('language en_GB')
vim.g.bulitin_lsp = true

-- Behaviours
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.opt.hidden = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wrap = false
vim.opt.title = true
vim.g.syntax_on = true
vim.cmd('filetype plugin indent on')

-- Seraching
vim.opt.grepprg = 'rg --vimgrep --smart-case --no-heading'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Indentation
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Appearance
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

-- Show invisibles
vim.opt.list = true
vim.opt.listchars = {
    tab = '▷ ',
    trail = '·',
    precedes = '«',
    extends = '»',
}

-- Encoding and endings
vim.opt.encoding = 'utf-8'
vim.opt.bomb = true
vim.opt.ffs = { 'dos', 'unix' }

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_bufsettings = 'noma nomod nonu nobl nowrap ro nu rnu'
vim.g.netrw_list_hide = '^\\./$'

-- Keymaps
vim.g.mapleader = ' '

-- Reload configuration
vim.keymap.set('n', '<F12>', function()
    dofile(vim.env.MYVIMRC)
    require('packer').sync()
end)

-- Generic
vim.keymap.set('n', '<leader>n', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<leader>tsc', function()
    if vim.wo.spell then
        vim.wo.spell = false
        vim.notify('Disable spellcheck')
        return
    end

    vim.wo.spell = true
    vim.bo.spelllang = 'en,ru'
    vim.notify('Enable spellcheck')
end)
vim.keymap.set('n', '<leader>thw', function()
    local width = vim.call('input', 'Enter new hard wrap text width: ')
    vim.opt.wrap = false
    vim.opt.textwidth = tonumber(width)
    vim.opt.colorcolumn = tostring(width)
end)
vim.keymap.set('n', '<leader>tsw', function()
    vim.opt.textwidth = tonumber(0)
    vim.opt.colorcolumn = tostring(0)
    vim.cmd('set wrap!')
    vim.notify('Enable text soft wrap')
end)

-- Telescope
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>fe', '<cmd>Telescope file_browser path=%:p:h<cr>')
vim.keymap.set('n', '<leader>fc', '<cmd>Telescope file_browser<cr>')
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>sf', '<cmd>Telescope filetypes<cr>')
vim.keymap.set('n', '<leader>sc', '<cmd>Telescope compiler<cr>')
vim.keymap.set('n', '<leader>ss', '<cmd>Telescope spell_suggest<cr>')
vim.keymap.set('n', '<leader>gb', '<cmd>Telescope git_branches<cr>')
vim.keymap.set('n', '<leader>gs', '<cmd>Telescope git_status<cr>')
vim.keymap.set(
    'n',
    '<leader>ws',
    '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>'
)

-- LSP
vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist)

-- Quickfix list
vim.keymap.set('n', '<leader>cn', '<cmd>cnext<cr>')
vim.keymap.set('n', '<leader>cp', '<cmd>cprev<cr>')
vim.keymap.set('n', '<leader>co', '<cmd>copen<cr>')
vim.keymap.set('n', '<leader>cc', '<cmd>cclose<cr>')

-- Location list
vim.keymap.set('n', '<leader>ln', '<cmd>lnext<cr>')
vim.keymap.set('n', '<leader>lp', '<cmd>lprev<cr>')
vim.keymap.set('n', '<leader>lo', '<cmd>lopen<cr>')
vim.keymap.set('n', '<leader>lc', '<cmd>lclose<cr>')

-- Diff
vim.keymap.set('n', '<leader>dw', '<cmd>Gwrite<cr>')
vim.keymap.set('n', '<leader>dl', '<cmd>diffget //2 | diffupdate<cr>')
vim.keymap.set('n', '<leader>dr', '<cmd>diffget //3 | diffupdate<cr>')
