" Options {{{1
if has('win32')
    set guifont=M+1VM+IPAG_circle:h10:cSHIFTJIS
elseif has('gui_macvim')
    "set guifont=AndaleMono:h12
    set guifont=M+1VM+IPAG_circle:h11
    set transparency=20
endif

set guioptions=eg
set columns=120
set lines=40


" Color {{{1
colorscheme xoria256


" End {{{1
if filereadable(expand('~/.gvimrc.local'))
    source ~/.gvimrc.local
endif
