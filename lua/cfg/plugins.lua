local bootstrap = false
local packer_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
    bootstrap = vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path})
end

local packer = require('packer')

packer.startup(
    function(use)
        use({'wbthomason/packer.nvim'})
        use({'ellisonleao/gruvbox.nvim'})
        use({'tpope/vim-fugitive'})
        use({'tpope/vim-surround'})
        use({
            'nvim-telescope/telescope.nvim',
            requires = {
                'nvim-lua/popup.nvim',
                'nvim-lua/plenary.nvim',
                'cranberry-knight/telescope-compiler.nvim',
            },
        })
        use({
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
        })

        use({'williamboman/nvim-lsp-installer'})
        use({'neovim/nvim-lspconfig'})
        use({'jose-elias-alvarez/null-ls.nvim'})

        use({'mfussenegger/nvim-dap'})
        use({
            'rcarriga/nvim-dap-ui',
            requires = {'mfussenegger/nvim-dap'},
        })

        use({'L3MON4D3/LuaSnip'})

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
        })

        use({'numToStr/Comment.nvim'})

        if bootstrap then
            packer.sync()
        end
    end
)
