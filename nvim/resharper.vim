let g:dot_settigns = "../../RF.DotSettings"

function! JbFormatCurrentBuffer()
    if &mod
        echo "Buffer is modified! Write buffer first."
        return
    endif

    silent !clear
    execute "!jb cleanupcode --settings=\"" . g:dot_settigns . "\" " . bufname("%")
    bufdo e
endfunction
