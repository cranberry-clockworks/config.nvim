language en_UK

" Vim-Plug
call plug#begin()

" Colorscheme
Plug 'morhetz/gruvbox'

" Autocomplete via LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'

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

set encoding=utf-8

set termguicolors

" Show extra column for linter messages
set signcolumn=yes

" Platform specific settings for Windows
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'windows.vim'

" Autocmpletion
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'autocompletion.vim'

" Key mappings
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'keys.vim'

" Common LSP settigns
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'lsp.vim'

" Rust specific
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'rust.vim'

" C# specific
execute 'source ' . fnamemodify(stdpath('config'), ':p') . 'csharp.vim'
