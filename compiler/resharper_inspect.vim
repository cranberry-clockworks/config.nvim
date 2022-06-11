if exists("current_compiler")
    finish
endif
let current_compiler = "resharper_inspect"

" older Vim always used :setlocal
if exists(":CompilerSet") != 2 
    command -nargs=* CompilerSet setlocal <args>
endif

let resharper_inspect_output = tempname()

exe 'CompilerSet makeprg=jb\ InspectCode\ --absolute-paths\ --severity=HINT\ --no-build\ --format=Text\ --output=\"' .. resharper_inspect_output .. '\"'
CompilerSet errorformat=%m
