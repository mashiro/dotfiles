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
set backupdir=~/tmp,.
set directory=~/tmp,.
set viminfo& viminfo+=n~/.viminfo

" view
set modeline
set modelines=5
set visualbell
set t_vb=
set antialias
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
"set tags& tags+=./tags;,./**/tags
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
command! -nargs=? CtagsR !ctags -R --C++-kinds=+p --fields=+iaS --extra=+q . <args>

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
" neobundle {{{2
if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle'))
NeoBundleFetch 'Shougo/neobundle.vim'

" vimproc {{{2
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'unix' : 'make -f make_unix.mak',
\    },
\ }

" webapi {{{2
NeoBundle 'mattn/webapi-vim'

" neocomplete {{{2
NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'

if neobundle#is_installed('neocomplete')
    let g:neocomplete#enable_at_startup = 1
else
    let g:neocomplcache_enable_at_startup = 1
endif

" neosnippet {{{2
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'

let g:neosnippet#snippets_directory='~/.vim/snippets'

imap <C-l> <Plug>(neosnippet_expand_or_jump)
smap <C-l> <Plug>(neosnippet_expand_or_jump)
xmap <C-l> <Plug>(neosnippet_expand_target)

imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" unite.vim {{{2
NeoBundle 'Shougo/unite.vim'

nnoremap [unite] <Nop>
nmap <Space> [unite]

nnoremap <silent> [unite]c :<C-u>UniteWithCurrentDir -buffer-name=files buffer bookmark file<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]s :<C-u>Unite file_rec file/new<CR>
nnoremap <silent> [unite]f :<C-u>Unite file file/new<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]u :<C-u>Unite source<CR>
nnoremap <silent> [unite]g :<C-u>Unite grep:.<CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  nmap <buffer> <ESC> <Plug>(unite_exit)
  imap <buffer> jj <Plug>(unite_insert_leave)
  imap <buffer> <C-j> <Plug>(unite_select_next_line)
  imap <buffer> <C-k> <Plug>(unite_select_previous_line)
  nmap <silent> <buffer> <expr> <C-s> unite#do_action('split')
  imap <silent> <buffer> <expr> <C-s> unite#do_action('split')
  nmap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
  imap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
endfunction"}}}

let g:unite_enable_start_insert = 1
let g:unite_source_file_mru_limit = 200
let g:unite_cursor_line_highlight = 'TabLineSel'
let g:unite_abbr_highlight = 'Normal'

if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
    let g:unite_source_grep_recursive_opt =''
endif

" quickrun.vim {{{2
NeoBundle 'thinca/vim-quickrun'

let g:quickrun_config = {
\   "_": {
\       "runner": "vimproc",
\       "runner/vimproc/updatetime": 50,
\       "outputter": "multi",
\       "outputter/multi/targets": ["buffer", "quickfix"],
\   }
\}

" gist.vim {{{2
NeoBundle 'mattn/gist-vim'

let g:github_user = "mashiro"

" vimfiler.vim {{{2
NeoBundle 'Shougo/vimfiler.vim'

let g:vimfiler_as_default_explorer = 1

" lightline.vim {{{2
NeoBundle 'itchyny/lightline.vim'

let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'mode_map': {'c': 'NORMAL'},
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
    \ },
    \ 'component_function': {
    \   'modified': 'MyModified',
    \   'readonly': 'MyReadonly',
    \   'fugitive': 'MyFugitive',
    \   'filename': 'MyFilename',
    \   'fileformat': 'MyFileformat',
    \   'filetype': 'MyFiletype',
    \   'fileencoding': 'MyFileencoding',
    \   'mode': 'MyMode'
    \ }
    \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

" yankround.vim {{{2
NeoBundle 'LeafCage/yankround.vim'

nmap p <Plug>(yankround-p)
xmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap gp <Plug>(yankround-gp)
xmap gp <Plug>(yankround-gp)
nmap gP <Plug>(yankround-gP)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)

" vim-over {{{2
NeoBundle 'osyo-manga/vim-over'

" caw.vim {{{2
NeoBundle 'tyru/caw.vim'

nmap <Leader>c <Plug>(caw:I:toggle)
vmap <Leader>c <Plug>(caw:I:toggle)

" editorconfig-vim {{{2"
NeoBundle 'editorconfig/editorconfig-vim'

" ag.vim {{{2
NeoBundle 'rking/ag.vim'

" vim-fakeclip {{{2
NeoBundle 'kana/vim-fakeclip'

" surround-vim {{{2
NeoBundle 'tpope/vim-surround'

" vim-fugitive {{{2
NeoBundle 'tpope/vim-fugitive'

" vim-ref {{{2
NeoBundle 'thinca/vim-ref'

let g:ref_source_webdict_sites = {
\   'alc': {
\     'url': 'http://eow.alc.co.jp/%s/UTF-8/',
\     'line': 37,
\   }
\ }
let g:ref_source_webdict_sites.default = 'alc'

" cpp-vim {{{2
NeoBundleLazy 'vim-jp/cpp-vim', {
\   'autoload': {'filetypes': ['cpp']}
\ }

" emmet-vim {{{2
NeoBundleLazy 'mattn/emmet-vim', {
\   'autoload': {'filetypes': ['html', 'css']}
\ }

" html5.vim {{{2
NeoBundleLazy 'othree/html5.vim', {
\  'autoload': {'filetypes': ['html', 'javascript']}
\ }

" vim-javascript {{{2
NeoBundleLazy 'pangloss/vim-javascript', {
\   'autoload': {'filetypes': ['javascript']}
\ }

" vim-coffee-script {{{2
NeoBundleLazy 'kchmck/vim-coffee-script', {
\   'autoload': {'filetypes': ['coffee']}
\ }
let g:coffee_compile_vert = 1
let g:coffee_watch_vert = 1
let g:coffee_run_vert = 1

" vim-json {{{2
NeoBundleLazy 'elzr/vim-json', {
\   'autoload': {'filetypes': ['json']}
\ }
let g:vim_json_syntax_conceal = 0

" vim-scala {{{2
NeoBundle 'derekwyatt/vim-scala', {
\   'autoload': {'filetypes': ['scala']}
\ }

" vim-go {{{2
NeoBundle 'fatih/vim-go', {
\   'autoload': {'filetypes': ['go']}
\ }
let g:go_disable_autoinstall = 1

" vim-slim {{{2
NeoBundle 'slim-template/vim-slim', {
\   'autoload': {'filetypes': ['slim']}
\ }


" End {{{1
call neobundle#end()
filetype plugin indent on

NeoBundleCheck

if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif

" vim: expandtab softtabstop=4 shiftwidth=4
" vim: foldmethod=marker
