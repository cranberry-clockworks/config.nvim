local M = {}

local function config(name)
    return string.format("require('cfg.plugin.%s').setup()", name)
end

function M.setup()
    local bootstrap = false
    local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
        bootstrap = vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path })
    end

    local packer = require('packer')

    packer.init({transitive_opt = false})
    packer.startup(
        function(use)
            use({ 'wbthomason/packer.nvim' })
            use({
                'lighthaus-theme/vim-lighthaus',
                config = config('colorscheme')
            })
            use({ 'tpope/vim-fugitive' })
            use({ 'tpope/vim-surround' })
            use({ 'numToStr/Comment.nvim' })
            use({
                'nvim-telescope/telescope.nvim',
                requires = {
                    'nvim-lua/popup.nvim',
                    'nvim-lua/plenary.nvim',
                    'cranberry-knight/telescope-compiler.nvim',
                },
                config = config('telescope'),
            })
            use({
                'nvim-treesitter/nvim-treesitter',
                run = ':TSUpdate',
                config = config('treesitter')
            })
            use({
                'neovim/nvim-lspconfig',
                requires = {
                    'williamboman/nvim-lsp-installer',
                },
                config = config('lsp'),
            })
            use({
                'jose-elias-alvarez/null-ls.nvim',
                config = config('nullls'),
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
                'L3MON4D3/LuaSnip',
                config = config('luasnip')
            })
            use({
                'hrsh7th/nvim-cmp',
                requires = {
                    'L3MON4D3/LuaSnip',
                    'hrsh7th/cmp-nvim-lsp',
                    'hrsh7th/cmp-buffer',
                    'hrsh7th/cmp-path',
                    'hrsh7th/cmp-cmdline',
                    'hrsh7th/cmp-nvim-lsp-signature-help',
                },
                config = config('cmp'),
            })

            if bootstrap then
                packer.sync()
            end
        end
    )
end

return M
