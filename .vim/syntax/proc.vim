" Vim syntax file
" Language:	Oracle Pro*C/C++
" Maintainer:	Michael Jarvis <michael@jarvis.com>
" Last Change:	2003 May 22


" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" Read the C++ syntax to start with, which in turn reads the C syntax
if version < 600
    so <sfile>:p:h/cpp.vim
else
    runtime! syntax/cpp.vim
    unlet b:current_syntax
endif


" Oracle Pro C/C++ extensions...so far we just just highlight 
" EXEC SQL statements.
syn region procStatement         start="EXEC SQL" end=";"

" Default highlighting
if version >= 508 || !exists("did_proc_syntax_inits")
    if version < 508
        let did_proc_syntax_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif
    HiLink procStatement          PreProc
    delcommand HiLink
endif

let b:current_syntax = "proc"

" vim: ts=4
