" Basic {{{1

" Initialize {{{2
augroup MyAutoCmd
    autocmd!
augroup END

" Encoding {{{2
set fileencodings=ucs-bom,iso-2022-jp,utf-8,cp932,euc-jp,default,latin1
set fileformats=unix,dos,mac
set ambiwidth=double

" Optioins {{{2
"set backupdir=~/tmp,.
"set directory=~/tmp,.
set viminfo& viminfo+=n~/.viminfo

" view
set modeline
set modelines=5
set visualbell
set t_vb=
"set antialias
set number
set ruler
"set cursorline
set foldmethod=marker
set laststatus=2
set cmdheight=1
set showcmd
set showmode
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set splitbelow
set splitright

" search
set nohlsearch
set incsearch
set ignorecase
set smartcase
set nowrapscan

" edit
set hidden
set autoindent
set smartindent
set backspace=indent,eol,start
set showmatch
set wildmenu
set formatoptions& formatoptions+=mM
set iminsert=0
set imsearch=-1
set tags& tags+=./tags;
set clipboard=unnamed

" tab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab

" mouse support (disable)
set mouse=
"if &term =~ '^screen'
"    autocmd MyAutoCmd VimLeave * :set mouse=
"    set ttymouse=xterm2
"endif
"if has('gui_running')
"    set mousemodel=popup
"    set nomousefocus
"    set mousehide
"endif

" Color {{{2
if (1 < &t_Co || has('gui')) && has('syntax')
    syntax on
    set background=dark
    if (256 <= &t_Co)
        autocmd MyAutoCmd ColorScheme *
        \   if !has('gui_running')
        \ |     highlight Normal ctermbg=none
        \ |     highlight NonText ctermbg=none
        \ |     highlight LineNr ctermbg=none
        \ | endif
        colorscheme xoria256
    endif
endif

" Utilities {{{1
" CD {{{2
command! -nargs=? -complete=dir -bang CD  call s:change_current_dir('<args>', '<bang>')

" CTagsR {{{2
command! -nargs=? CtagsR !ctags --tag-relative --recurse --sort=yes --append=no -f tags

" Enc {{{2
command! -bang -bar -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -bar -complete=file -nargs=? EucJp edit<bang> ++enc=euc-jp <args>
command! -bang -bar -complete=file -nargs=? Cp932 edit<bang> ++enc=cp932 <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>

function! s:change_current_dir(directory, bang) " {{{2
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif
    if a:bang == ''
        pwd
    endif
endfunction

function! s:toggle_option(option_name) " {{{2
    execute 'setlocal' a:option_name.'!'
    execute 'setlocal' a:option_name.'?'
endfunction

" Mappings {{{1
" leader
let mapleader = ','

" edit/reload .vimrc
nnoremap <silent> <Space>ev :<C-u>edit ~/.vimrc<CR>
nnoremap <silent> <Space>eg :<C-u>edit ~/.gvimrc<CR>
nnoremap <silent> <Space>rv :<C-u>source ~/.vimrc \| if has('gui_running') \| source ~/.gvimrc \| endif<CR>
nnoremap <silent> <Space>rg :<C-u>source ~/.gvimrc<CR>

" save, quit
nnoremap <silent> <Space>w :<C-u>update<CR>
nnoremap <silent> <Space>q :<C-u>quit<CR>

" escape
noremap <Nul> <C-@>
noremap! <Nul> <C-@>
noremap <C-@> <Esc>
noremap! <C-@> <Esc>
inoremap <silent> <C-j> <Esc>

" emacs like
noremap <C-a> <Home>
noremap! <C-a> <Home>
noremap <C-e> <End>
noremap! <C-e> <End>
noremap! <C-f> <Right>
noremap! <C-b> <Left>
noremap! <C-p> <Up>
noremap! <C-n> <Down>
noremap <C-k> D
inoremap <C-k> <C-o>D
cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>

" adding and subtracting
nnoremap + <C-a>
nnoremap - <C-x>

" add new line
"nnoremap <Space>O :<C-u>call append(expand('.'), '')<Cr>j

" toggle option
nnoremap <Space>o <Nop>
nnoremap <Space>ow :<C-u>call <SID>toggle_option('wrap')<CR>
nnoremap <Space>on :<C-u>call <SID>toggle_option('number')<CR>
nnoremap <Space>ol :<C-u>call <SID>toggle_option('list')<CR>
nnoremap <Space>op :<C-u>call <SID>toggle_option('paste')<CR>

" fold
"nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
"nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
"vnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
"vnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'
nnoremap <Space>h zc
nnoremap <Space>l zo
nnoremap <Space>zo zO
nnoremap <Space>zc zC
nnoremap <Space>zO zR
nnoremap <Space>zC zM

" window
"nnoremap <C-w>h <C-w>h:call <SID>window_min_resize()<CR>
"nnoremap <C-w>l <C-w>l:call <SID>window_min_resize()<CR>
"nnoremap <C-w>j <C-w>j:call <SID>window_min_resize()<CR>
"nnoremap <C-w>k <C-w>k:call <SID>window_min_resize()<CR>
"nnoremap <C-w>H <C-w>H:call <SID>window_min_resize()<CR>
"nnoremap <C-w>L <C-w>L:call <SID>window_min_resize()<CR>
"nnoremap <C-w>J <C-w>J:call <SID>window_min_resize()<CR>
"nnoremap <C-w>K <C-w>K:call <SID>window_min_resize()<CR>
"function! s:window_min_resize()
"    if winwidth(0) < 84
"        vertical resize 84
"    endif
"    if winheight(0) < 30
"        resize 30
"    endif
"endfunction

" tab
"nnoremap <C-t> <Nop>
"nnoremap <C-t>n :<C-u>tabnew<Cr>
"nnoremap <C-t>c :<C-u>tabclose<Cr>
"nnoremap <C-t>o :<C-u>tabonly<Cr>
"nnoremap <C-t>l gt
"nnoremap <C-t>h gT
"nnoremap <C-t>j gt
"nnoremap <C-t>k gT

" change current directury
nnoremap <silent> <Space>cd :<C-u>CD<CR>

" AutoCmd {{{1
" Fix 'fileencoding' to use 'encoding'
" if the buffer only contains 7-bit characters.
" Note that if the buffer is not 'modifiable',
" its 'fileencoding' cannot be changed, so that such buffers are skipped.
autocmd MyAutoCmd BufReadPost *
\ if &modifiable && !search('[^\x00-\x7F]', 'cnw')
\ | setlocal fileencoding=
\ | endif

" adjust highlight settings according to the current colorscheme.
"autocmd MyAutoCmd ColorScheme *
"\   highlight Pmenu         guifg=#d0d0d0 guibg=#222233
"\ | highlight PmenuSel      guifg=#eeeeee guibg=#4f4f87 gui=bold
"\ | highlight PmenuSbar                   guibg=#333344

" omni-completion
"if exists("+omnifunc")
"    autocmd MyAutoCmd Filetype *
"    \   if &omnifunc == ""
"    \ |     setlocal omnifunc=syntaxcomplete#Complete
"    \ | endif
"endif

" auto ime off (gvim only)
autocmd MyAutoCmd InsertLeave * set iminsert=0 imsearch=0

" vim -b : edit binary using xxd-format!
augroup Binary
    autocmd!
    autocmd BufReadPre *.bin let &binary = 1
    autocmd BufReadPost * call BinReadPost()
    autocmd BufWritePre * call BinWritePre()
    autocmd BufWritePost * call BinWritePost()
    function! BinReadPost()
        if &binary
            silent %!xxd -g1
            set ft=xxd
        endif
    endfunction
    function! BinWritePre()
        if &binary
            let s:saved_pos = getpos( '.' )
            silent %!xxd -r
        endif
    endfunction
    function! BinWritePost()
        if &binary
            silent %!xxd -g1
            call setpos( '.', s:saved_pos )
            set nomod
        endif
    endfunction
augroup END


" Plugins {{{1

" dein.vim
let s:cache_dir = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_dir . '/dein'
let s:dein_install_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:dein_repo = 'https://github.com/Shougo/dein.vim'

if !isdirectory(s:dein_install_dir)
    execute printf('!git clone %s %s', s:dein_repo, s:dein_install_dir)
endif

if &compatible
    set nocompatible
endif
execute 'set runtimepath^=' . s:dein_install_dir

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir, [expand('<sfile>'), '~/.vim/dein.toml'])
    call dein#load_toml(expand('~/.vim/dein.toml'))
    call dein#end()
    call dein#save_state()
endif

if dein#check_install()
    call dein#install()
endif

" End {{{1
"call neobundle#end()
filetype plugin indent on

"NeoBundleCheck

if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif

" vim: expandtab softtabstop=4 shiftwidth=4
" vim: foldmethod=marker
