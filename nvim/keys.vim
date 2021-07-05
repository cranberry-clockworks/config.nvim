" Quick list
nnoremap <C-j> :cnext<CR>
nnoremap <C-k> :cprev<CR>
nnoremap <C-l><C-l> :cclose<CR>

" Local list
nnoremap <M-j> :lnext<CR>
nnoremap <M-k> :lprev<CR>
nnoremap <M-l><M-l> :lclose<CR>

nnoremap <F7> :call ToggleSpellCheck()<CR>
inoremap <F7> <C-o>:call ToggleSpellCheck()<CR>

nnoremap <F9> :nohlsearch<CR>
inoremap <F9> <C-o>:nohlsearch<CR>

" Telescope
nnoremap <M-f> <cmd>Telescope find_files<CR>
nnoremap <M-g> <cmd>Telescope live_grep<CR>
nnoremap <M-b> <cmd>Telescope buffers<CR>
nnoremap <M-n> <cmd>Telescope git_branches<CR> 
nnoremap <M-s> <cmd>Telescope git_status<CR>

" dotnet tools
nnoremap <M-d> <cmd>lua dotnet_picker()<CR>
