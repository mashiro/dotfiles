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
filetype plugin indent on
set nocompatible
set runtimepath& runtimepath+=~/.vim,~/.vim/after
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
set tags& tags+=./tags;,./**/tags
set clipboard=unnamed

" tab
set tabstop=4
set shiftwidth=4
set softtabstop=4
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
        colorscheme xoria256
        if !has('gui_running')
            hi Normal ctermbg=none
            hi NonText ctermbg=none
            hi LineNr ctermbg=none
        endif
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

function! s:set_package_runtimepath(name, ...) " {{{2
    let l:name = a:name
    let l:path = a:0 > 0 ? a:1 : '~/.vim/package'
    execute 'set runtimepath^=' . l:path . '/' . l:name
    execute 'set runtimepath+=' . l:path . '/' . l:name . '/after'
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

" escape (jis)
noremap <Nul> <C-@>
noremap! <Nul> <C-@>
noremap <C-@> <Esc>
noremap! <C-@> <Esc>

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
nnoremap <C-t> <Nop>
nnoremap <C-t>n :<C-u>tabnew<Cr>
nnoremap <C-t>c :<C-u>tabclose<Cr>
nnoremap <C-t>o :<C-u>tabonly<Cr>
nnoremap <C-t>l gt
nnoremap <C-t>h gT
nnoremap <C-t>j gt
nnoremap <C-t>k gT

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
autocmd MyAutoCmd ColorScheme *
\   highlight Pmenu         guifg=#d0d0d0 guibg=#222233
\ | highlight PmenuSel      guifg=#eeeeee guibg=#4f4f87 gui=bold
\ | highlight PmenuSbar                   guibg=#333344

" omni-completion
if exists("+omnifunc")
    autocmd MyAutoCmd Filetype *
    \   if &omnifunc == ""
    \ |     setlocal omnifunc=syntaxcomplete#Complete
    \ | endif
endif

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
" neobundle.vim {{{2
if filereadable(expand('~/.vim/.neobundle'))
    source ~/.vim/.neobundle
endif

" neocomplcache.vim {{{2
let g:neocomplcache_enable_at_startup = 1
imap <silent> <C-e> <Plug>(neocomplcache_snippets_expand)
smap <silent> <C-e> <Plug>(neocomplcache_snippets_expand)

" unite.vim {{{2
nnoremap [unite] <Nop>
nmap <Space> [unite]

nnoremap <silent> [unite]c :<C-u>UniteWithCurrentDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]g :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]s :<C-u>Unite file_rec file/new<CR>
nnoremap <silent> [unite]f :<C-u>Unite file file/new<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]u :<C-u>Unite source<CR>

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

" templatefile.vim {{{2
autocmd User plugin-template-loaded call s:template_keywords()
function! s:template_keywords()
    " 置換キーワード
    let date      = escape(strftime('%Y-%m-%d'), '/\\')
    let file      = escape(expand('%:t:r'), '/\\')
    let file_ext  = escape(expand('%'), '/\\')
    let inc_guard = escape(toupper(substitute(file, '\\.', '_', 'g')), '/\\') . '_INCLUDED'
    silent! execute '%s/<+DATE+>/'          . date      . '/g'
    silent! execute '%s/<+FILE+>/'          . file      . '/g'
    silent! execute '%s/<+FILE_EXT+>/'      . file_ext  . '/g'
    silent! execute '%s/<+INCLUDE_GUARD+>/' . inc_guard . '/g'

    " <%= %> の中身をvimで評価して展開
    silent execute '%s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge'

    " <+CURSOR+> にカーソルを移動
    if search('<+CURSOR+>')
        silent execute 'normal! "_da>'
    endif
endfunction

" quickrun.vim {{{2
let g:quickrun_config = {
\   "_": {
\       "runner": "vimproc",
\       "runner/vimproc/updatetime": 50,
\       "outputter": "multi",
\       "outputter/multi/targets": ["buffer", "quickfix"],
\   }
\}

" gist.vim {{{2
let g:github_user = "mashiro"

" vimfiler.vim {{{2
let g:vimfiler_as_default_explorer = 1

" lightline.vim {{{2
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


" yankaround.vim {{{2
nmap p <Plug>(yankround-p)
xmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap gp <Plug>(yankround-gp)
xmap gp <Plug>(yankround-gp)
nmap gP <Plug>(yankround-gP)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)


" End {{{1
if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif

set secure " must be written at the last. see :help 'secure'.

" vim: expandtab softtabstop=4 shiftwidth=4
" vim: foldmethod=marker
