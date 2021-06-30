language en_UK

" Vim-Plug
call plug#begin()

" Color scheme
Plug 'morhetz/gruvbox'

" Auto complete via LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Git
Plug 'tpope/vim-fugitive'

" Surroundings
Plug 'tpope/vim-surround'

call plug#end()

" Clipboard
set clipboard+=unnamedplus

" Indentation
set expandtab smarttab autoindent tabstop=4 softtabstop=4 shiftwidth=4

" Appearance settings
colorscheme gruvbox

" Enable syntax highlighting
syntax on

" Show line numbers
set number

" Show edited files in title
set title

" Distinct files by type
filetype plugin indent on

" Show status info
set ruler showcmd showmode

" Highlight search items
set incsearch

set fileformat=unix
set encoding=utf-8
set ffs=unix,dos

set termguicolors

" Show extra column for lintier messages
set signcolumn=yes

" Status line
set statusline=
set statusline+=[#%b]
set statusline+=\ %<%f
set statusline+=\ %h%w%m%r
set statusline+=\ %y
set statusline+=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\"\ bom\":\"\").\"]\\"}
set statusline+=[%{&ff}]
set statusline+=%=
set statusline+=\ %l/%L\ :\ %v\ [%3p%%]

" Show invisible
:set list
:set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,precedes:«,extends:»

" Platform specific settings for Windows
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'windows.vim'

" Autocmpletion
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'autocompletion.vim'

" Key mappings
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'keys.vim'

" Common LSP settings
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'lsp.vim'

" Rust specific
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'rust.vim'

" C# specific
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'csharp.vim'

" Treesitter
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'treesitter.vim'

" Telescope
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'telescope.vim'
