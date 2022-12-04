local M = {}

local function config(name)
    return string.format("require('cfg.plugin.%s').setup()", name)
end

function M.setup()
    local bootstrap = false
    local packer_path = vim.fn.stdpath('data')
        .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
        bootstrap = vim.fn.system({
            'git',
            'clone',
            'https://github.com/wbthomason/packer.nvim',
            packer_path,
        })
    end

    local packer = require('packer')

    packer.init({ transitive_opt = false })
    packer.startup(function(use)
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
            'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup()
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
                local builtin = require('telescope.builtin')

                telescope.setup({
                    defaults = {
                        layout_strategy = 'vertical',
                        layout_config = {
                            vertical = {
                                prompt_position = 'top',
                                mirror = true,
                            },
                        },
                        sorting_strategy = 'ascending',
                        prompt_tile = false,
                        borderchars = {
                            '─',
                            '│',
                            '─',
                            '│',
                            '┌',
                            '┐',
                            '┘',
                            '└',
                        },
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
                        filetypes = {
                            previewer = false,
                        },
                        git_status = {
                            previewer = false,
                        },
                    },
                    extensions = {
                        file_browser = {
                            previewer = false,
                            theme = 'ivy',
                            dir_icon = '■',
                        },
                    },
                })

                telescope.load_extension('compiler')
                telescope.load_extension('file_browser')

                local options = require('cfg.keymaps').options

                vim.keymap.set('n', '<leader>ff', builtin.find_files, options)
                vim.keymap.set('n', '<leader>st', builtin.filetypes, options)
                vim.keymap.set(
                    'n',
                    '<leader>sc',
                    '<cmd>Telescope compiler<cr>',
                    options
                )
                vim.keymap.set('n', '<leader>fg', builtin.live_grep, options)
                vim.keymap.set('n', '<leader>fb', builtin.buffers, options)
                vim.keymap.set('n', '<leader>gb', builtin.git_branches, options)
                vim.keymap.set('n', '<leader>gs', builtin.git_status, options)
                vim.keymap.set(
                    'n',
                    '<leader>sz',
                    builtin.spell_suggest,
                    options
                )
                vim.keymap.set(
                    'n',
                    '<leader>fe',
                    '<cmd>Telescope file_browser path=%:p:h<cr>',
                    options
                )
                vim.keymap.set(
                    'n',
                    '<leader>fc',
                    '<cmd>Telescope file_browser<cr>',
                    options
                )
            end,
        })
        use({
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
            config = config('treesitter'),
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
            },
            config = function()
                local lsp = require('lsp-zero')
                lsp.preset('recommended')
                lsp.setup()
            end,
        })
        use({
            'jose-elias-alvarez/null-ls.nvim',
            config = config('null_ls'),
        })
        use({
            'mfussenegger/nvim-dap',
            requires = {
                'rcarriga/nvim-dap-ui',
                requires = {
                    'mfussenegger/nvim-dap',
                },
            },
            config = config('dap'),
        })
        use({
            'danymat/neogen',
            requires = { 'nvim-treesitter/nvim-treesitter' },
            config = config('neogen'),
        })

        if bootstrap then
            packer.sync()
        end
    end)
end

return M
