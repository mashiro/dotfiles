" Options {{{1
if has('win32')
    set guifont=Migu_1M:h10
elseif has('gui_macvim')
    set guifont=AndaleMono:h12
    set transparency=10
endif

set guioptions=egrL
set columns=120
set lines=40


" Color {{{1
colorscheme xoria256


" End {{{1
if filereadable(expand('~/.gvimrc.local'))
    source ~/.gvimrc.local
endif
