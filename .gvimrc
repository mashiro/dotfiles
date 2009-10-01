" Options {{{1
if has('win32')
    set guifont=M+2VM+IPAG_circle:h10:cSHIFTJIS
elseif has('gui_macvim')
    set guifont=AndaleMono:h12
    set transparency=20
endif

set guioptions=ai
set columns=120
set lines=45

" Color {{{1
colorscheme xoria256

" End {{{1
if filereadable($HOME . '/.gvimrc.local')
    source $HOME/.gvimrc.local
endif

