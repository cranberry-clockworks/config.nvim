local fun = require('fun')

vim.g.mapleader = " "

-- Essentials
vim.cmd('language en_GB')
vim.g.bulitin_lsp = true

-- Neovide client
vim.opt.guifont = 'JetBrains Mono:h10'
vim.g.neovide_refresh_rate = 60
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_trail_length = 0

-- Behaviours
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}
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
vim.opt.termguicolors = true
require('lighthaus').setup({
    bg_dark = false,
    lsp_underline_style = 'underline',
    italic_comments = true,
    italic_keywords = false,
})

-- Encoding and endings
vim.opt.encoding = 'utf-8'
vim.opt.bomb = true
vim.opt.ffs = { 'dos', 'unix' }

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_bufsettings = 'noma nomod nonu nobl nowrap ro nu rnu'
vim.g.netrw_list_hide = '^\\./$'

