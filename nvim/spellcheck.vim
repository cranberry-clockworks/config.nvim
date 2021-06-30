" Switch spellcheck languages

let g:selectedLanguage = 0
let g:languageList = [ "None", "En", "Ru" ]
function! ToggleSpellCheck()
  " Loop through languages
  let g:selectedLanguage = g:selectedLanguage + 1

  if g:selectedLanguage >= len(g:languageList) 
      let g:selectedLanguage = 0
  endif

  if g:selectedLanguage == 0
      set nospell
  endif
  
  if g:selectedLanguage == 1
      setlocal spell spelllang=en_gb
  endif
  
  if g:selectedLanguage == 2
      setlocal spell spelllang=ru_ru
  endif
  echo "Language:" g:languageList[g:selectedLanguage]
endf

map <F7> :call ToggleSpellCheck()<CR>
imap <F7> <C-o>:call ToggleSpellCheck()<CR>
