" Avoid showing extra messages when using completion
set shortmess+=c

" Setup completion menu
set completeopt=menuone,noinsert,noselect

" Inline hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

" Show diagnostic popup on cursor hold
set updatetime=300
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
