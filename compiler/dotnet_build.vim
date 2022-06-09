if exists("current_compiler")
    finish
endif
let current_compiler = "dotnet_build"

" older Vim always used :setlocal
if exists(":CompilerSet") != 2 
    command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=dotnet\ build
CompilerSet errorformat=
    \%-ABuild%.%#,
    \%-ZTime%.%#,
    \%-C%.%#,
    \%f(%l\\\,%c):\ %trror\ %m\ [%.%#],
    \%f(%l\\\,%c):\ %tarning\ %m\ [%.%#],
    \%-G%.%#
