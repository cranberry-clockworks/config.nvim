-- Plugins
vim.api.nvim_exec(
[[
call plug#begin()

" Color scheme
Plug 'ellisonleao/gruvbox.nvim'

" LSP Configuration
Plug 'neovim/nvim-lspconfig'

" Inline hints
Plug 'nvim-lua/lsp_extensions.nvim'

" Auto complete via LSP
Plug 'L3MON4D3/LuaSnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/nvim-cmp'

Plug 'skywind3000/asyncrun.vim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Git
Plug 'tpope/vim-fugitive'

" Surroundings
Plug 'tpope/vim-surround'

Plug 'cranberry-knight/knife.nvim'

call plug#end()

" Dev plugins
" let &runtimepath.=',C:\Users\Knight\Documents\GitHub\knife.nvim'
]], false)

-- Essentials
vim.cmd('language en_GB')
vim.g.bulitin_lsp = true

-- Neovide client
vim.opt.guifont="JetBrains Mono:h12"
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
local textwidth = 120
vim.opt.textwidth = textwidth
vim.cmd(string.format("set colorcolumn=%i", textwidth))

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
vim.g.netrw_banner=0

require('knight')
