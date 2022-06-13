syntax match PythonKwArg "\v[\(\,]\_s?\s{-}\zs\w+\ze\=(\=)@!"
syntax match PythonKwArg "\v^\s{-}\zs\w+\ze\=(\=)@!"

syn keyword PythonMatch match case

syn match PythonConstant /\<[A-Z_][A-Z_0-9]*\>/
syn match PythonDunder "__\w*__"

hi def link PythonKwArg Special
hi def link PythonConstant Constant
hi def link PythonDunder PreProc
hi def link PythonMatch Conditional
