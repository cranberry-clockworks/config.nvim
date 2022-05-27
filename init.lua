-- Plugins
vim.api.nvim_exec(
[[
call plug#begin()

" Color scheme
Plug 'cranberry-knight/mirror.nvim'

" LSP Configuration
Plug 'neovim/nvim-lspconfig'

" Inline hints
Plug 'nvim-lua/lsp_extensions.nvim'

" Auto complete via LSP
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'

" LSP signature help
Plug 'ray-x/lsp_signature.nvim'

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
local textwidth = 100
vim.opt.textwidth = textwidth
vim.cmd(string.format("set colorcolumn=%i", textwidth))

-- Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

-- Colorscheme
vim.cmd('colorscheme mirror')

-- Encoding and endings
vim.opt.encoding = 'utf-8'
vim.opt.bomb = true
vim.opt.ffs = { 'dos', 'unix' }

-- Netrw
vim.g.netrw_banner=0

require('knight')
