" Basic {{{1

" Initialize {{{2
augroup MyAutoCmd
    autocmd!
augroup END

" Encoding {{{2
set encoding&
set fileencoding&
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif
if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','. s:fileencodings_default
        unlet s:fileencodings_default
    else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
        else
            let &fileencodings = &fileencodings .','. s:enc_euc
        endif
    endif
    unlet s:enc_euc
    unlet s:enc_jis
endif
if has('autocmd')
    function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd MyAutoCmd BufReadPost * call AU_ReCheck_FENC()
endif
set fileformats=unix,dos,mac
if exists('&ambiwidth')
    set ambiwidth=double
endif

" Color {{{2
if (1 < &t_Co || has('gui')) && has('syntax')
    syntax on
    set background=dark
    if (256 <= &t_Co)
        colorscheme xoria256
    endif
endif

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
    let name = a:name
    let path = a:0 > 0 ? a:1 : '~/.vim/package'
    execute 'set runtimepath^=' . path . '/' . name
    execute 'set runtimepath+=' . path . '/' . name . '/after'
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
" pathogen.vim {{{2
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

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

" neocomplcache.vim {{{2
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_ignore_case = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_wildcard = 1
let g:neocomplcache_enable_cursor_hold_i = 0
let g:neocomplcache_enable_auto_select = 0
let g:neocomplcache_enable_camel_case_completion = 0
let g:neocomplcache_enable_underbar_completion = 0
imap <silent> <C-e> <Plug>(neocomplcache_snippets_expand)
smap <silent> <C-e> <Plug>(neocomplcache_snippets_expand)

" FuzzyFinder.vim {{{2
"let g:fuf_splitPathMatching = ' '
"let g:fuf_patternSeparator = ' '
"let g:fuf_modesDisable = ['mrucmd']
"let g:fuf_file_exclude = '\v\~$|\.(o|exe|bak|swp|gif|jpg|png)$|(^|[/\\])\.(hg|git|bzr|svn)($|[/\\])'
"let g:fuf_mrufile_exclude = '\v\~$|\.bak$|\.swp|\.howm$|\.(gif|jpg|png)$'
"let g:fuf_mrufile_maxItem = 10000
"let g:fuf_enumeratingLimit = 20
"nnoremap <silent> <Space>fb :FufBuffer<CR>
"nnoremap <silent> <Space>b :FufBuffer<CR>
"nnoremap <silent> <Space>ff :FufFile <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR>
"nnoremap <silent> <Space>fr :FufMruFile<CR>
"nnoremap <silent> <Space>fq :FufQuickfix<CR>
"nnoremap <silent> <Space>fl :FufLine<CR>
"nnoremap <silent> <Leader>ff :FufFile **/<CR>

" unite.vim {{{2
nnoremap [unite] <Nop>
nmap <Space> [unite]

nnoremap <silent> [unite]c :<C-u>UniteWithCurrentDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]g :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]s :<C-u>Unite file_rec<CR>
nnoremap <silent> [unite]f :<C-u>Unite file<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  " Overwrite settings.
  nmap <buffer> <ESC> <Plug>(unite_exit)
  imap <buffer> jj <Plug>(unite_insert_leave)
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)

  " <C-l>: manual neocomplcache completion.
  inoremap <buffer> <C-l> <C-x><C-u><C-p><Down>

  " Start insert.
  "let g:unite_enable_start_insert = 1
endfunction"}}}

let g:unite_source_file_mru_limit = 200
let g:unite_cursor_line_highlight = 'TabLineSel'
let g:unite_abbr_highlight = 'TabLine'

" For optimize.
let g:unite_source_file_mru_filename_format = ''

" yankring.vim {{{2
let g:yankring_history_file = '.yankring_history'


" zencoding.vim {{{2
let g:user_zen_leader_key = '<c-y>'
let g:user_zen_settings = {
\ 'lang': 'ja',
\ 'indentation': '  ',
\ 'html': {
\   'extends': 'javascript'
\ },
\ 'eruby': {
\   'extends': 'html,javascript,ruby'
\ },
\ 'haml': {
\   'extends': 'html,javascript,ruby'
\ },
\ 'javascript': {
\   'snippets': {
\     'jq':    "$(function() {\n  ${cursor}${child}\n});",
\     'each':  "$.each(arr, function(index, item)\n  ${child}\n});",
\     'ready': "$(document).ready(function() {\n  ${cursor}\n});",
\     'fn':    "(function() {\n\t${cursor}\n})();",
\     'tm':    "setTimeout(function() {\n\t${cursor}\n}, 100);",
\   },
\ },
\}


" quickrun.vim {{{2
let b:quickrun_config = {
\ 'outputter/buffer/split': ''
\}
let g:quickrun_config = {
\ 'cs': {
\   'command': 'dmcs',
\   'exec': ['%c %o %s -out:%s:p:r.exe', 'mono %s:p:r.exe %a', 'rm -f %s:p:r.exe'],
\   'tempfile': '%{tempname()}.cs',
\ },
\}


" End {{{1
if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif

set secure " must be written at the last. see :help 'secure'.

" vim: expandtab softtabstop=4 shiftwidth=4
" vim: foldmethod=marker
