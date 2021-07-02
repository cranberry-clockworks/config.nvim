nnoremap <F9> :nohlsearch<CR>

" Telescope
nnoremap <M-f> <cmd>Telescope find_files<CR>
nnoremap <M-g> <cmd>Telescope live_grep<CR>
nnoremap <M-b> <cmd>Telescope buffers<CR>
nnoremap <M-n> <cmd>Telescope git_branches<CR> 
nnoremap <M-s> <cmd>Telescope git_status<CR>

" dotnet tools
nnoremap <M-d> <cmd>lua dotnet_picker()<CR>
