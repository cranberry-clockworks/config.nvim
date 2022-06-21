-- Install packer if not present
local packer_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
    vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path})
    vim.cmd('packadd packer.nvim')
end

vim.g.mapleader = " "

local cfg = require('cfg')
local fun = require('fun')

-- Dependancies
require('packer').startup(
    function(use)
        use 'wbthomason/packer.nvim'
        use 'ellisonleao/gruvbox.nvim'
        use 'tpope/vim-fugitive'
        use 'tpope/vim-surround'
        use {
            'nvim-telescope/telescope.nvim',
            requires = {
                'nvim-lua/popup.nvim',
                'nvim-lua/plenary.nvim',
                'cranberry-knight/telescope-compiler.nvim',
            },
            config = cfg.telescope.setup,
        }
        use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
            config = cfg.treesitter.setup,
        }
        use {
            'neovim/nvim-lspconfig',
            requires = {
                'williamboman/nvim-lsp-installer',
                'hrsh7th/cmp-nvim-lsp',
            },
            after = {
                'nvim-lsp-installer',
                'telescope.nvim',
            },
            wants = 'nvim-lsp-installer',
            config = cfg.lsp.setup
        }
        use {
            'L3MON4D3/LuaSnip',
            config = cfg.luasnip.setup,
        }
        use {
            'hrsh7th/nvim-cmp',
            requires = {
                'L3MON4D3/LuaSnip',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-cmdline',
                'hrsh7th/cmp-nvim-lsp-signature-help',
            },
            after = {
                'LuaSnip',
                'nvim-lspconfig'
            },
            config = cfg.cmp.setup,
        }
        use {
            'numToStr/Comment.nvim',
            config = cfg.comment.setup,
        }
        use {
            'jose-elias-alvarez/null-ls.nvim',
            config = cfg.nullls.setup,
        }
    end
)

-- Essentials
vim.cmd('language en_GB')
vim.g.bulitin_lsp = true

-- Neovide client
vim.opt.guifont="JetBrains Mono:h11"
vim.g.neovide_refresh_rate=60
vim.g.neovide_cursor_trail_size=0
vim.g.neovide_cursor_trail_length=0

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

-- Text width
fun.text.set_hard_wrap(0, true)

-- Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

-- Colorscheme
vim.cmd('colorscheme gruvbox')

-- Encoding and endings
vim.opt.encoding = 'utf-8'
vim.opt.bomb = true
vim.opt.ffs = { 'dos', 'unix' }

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_bufsettings = "noma nomod nonu nobl nowrap ro nu rnu"
vim.g.netrw_list_hide = '^\\./$'

cfg.mappings.setup()
