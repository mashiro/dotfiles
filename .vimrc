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
set backupdir=~/tmp,~/,./
set directory=~/tmp,~/,./
set clipboard=unnamed

" view
set antialias
set number
set ruler
"set cursorline
set foldmethod=marker
set laststatus=2 
set showcmd
set showmode
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" search
set hlsearch
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

" tab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
set smarttab

" mouse support
"set mouse=a
"if &term =~ '^screen'
"	autocmd MyAutoCmd VimLeave * :set mouse=
"	set ttymouse=xterm2
"endif
"if has('gui_running')
"	set mousemodel=popup
"	set nomousefocus
"	set mousehide
"endif


" Utilities {{{1
" CD {{{2
command! -nargs=? -complete=dir -bang CD  call s:change_current_dir('<args>', '<bang>')


" CTagsR {{{2
command! -nargs=? CtagsR !ctags -R --C++-kinds=+p --fields=+iaS --extra=+q . <args>


" Enc {{{2
command! -bang -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -nargs=? EucJp edit<bang> ++enc=euc-jp <args>
command! -bang -nargs=? Cp932 edit<bang> ++enc=cp932 <args>

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

function! s:include_guard() " {{{2
	let fl = getline(1)
	if fl =~ "^#if"
		return
	endif
	let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
	normal! gg
	execute "normal! i#ifndef " . gatename . "_INCLUDED"
	execute "normal! o#define " . gatename . "_INCLUDED\<CR>\<CR>\<CR>"
	execute "normal! Go#endif /* " . gatename . "_INCLUDED */"
	4
endfunction


function! s:python_header() " {{{2
	let fl = getline(1)
	if fl =~ "^#!"
		return
	endif
	normal! gg
	execute "normal! i#!/usr/bin/python"
	execute "normal! o# -*- encoding: utf-8 -*-\<CR>"
endfunction


" Mappings {{{1
" leader
let mapleader = ","

" edit .vimrc
nnoremap <silent> <Space>ev :<C-u>edit ~/.vimrc<CR>
nnoremap <silent> <Space>eg :<C-u>edit ~/.gvimrc<CR>

" load .vimrc
nnoremap <silent> <Space>rv :<C-u>source ~/.vimrc \| if has('gui_running') \| source ~/.gvimrc \| endif<CR>
nnoremap <silent> <Space>rg :<C-u>source ~/.gvimrc<CR>

" save, quit
nnoremap <silent> <Space>w :<C-u>update<CR>
nnoremap <silent> <Space>q :<C-u>quit<CR>

" escape (jis)
map <Nul> <C-@>
map! <Nul> <C-@>
noremap <C-@> <Esc>
noremap! <C-@> <Esc>

" emacs like
noremap <C-a> <Home>
noremap! <C-a> <Home>
noremap <C-e> <End>
noremap! <C-e> <End>
nnoremap <C-k> D
inoremap <C-k> <C-o>D

" add new line
"nnoremap <Space>O :<C-u>call append(expand('.'), '')<Cr>j

" toggle option
nnoremap <Space>ow :<C-u>setlocal wrap! \| setlocal wrap?<CR>
nnoremap <Space>on :<C-u>setlocal number! \| setlocal number?<CR>

" fold
"nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
"nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
"vnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
"vnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'
nnoremap <Space>zo zO
nnoremap <Space>zc zC

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
"	if winwidth(0) < 84
"		vertical resize 84
"	endif
"	if winheight(0) < 30
"		resize 30
"	endif
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


" AutoCmds {{{1
" adjust highlight settings according to the current colorscheme.
autocmd MyAutoCmd ColorScheme *
\   highlight Pmenu         guifg=#d0d0d0 guibg=#222233
\ | highlight PmenuSel      guifg=#eeeeee guibg=#4f4f87 gui=bold
\ | highlight PmenuSbar                   guibg=#333344

" omni-completion
if has("autocmd") && exists("+omnifunc")
	autocmd MyAutoCmd Filetype *
	\   if &omnifunc == ""
	\ |     setlocal omnifunc=syntaxcomplete#Complete
	\ | endif
endif

" auto ime off (gvim only)
autocmd MyAutoCmd InsertLeave * set iminsert=0 imsearch=0

" useful when changing directories when buffers are changed
autocmd MyAutoCmd BufEnter * execute ":lcd " . expand("%:p:h")

" changelog
autocmd MyAutoCmd BufNewFile,BufRead *.changelog set filetype=changelog
let g:changelog_timeformat = "%Y-%m-%d"
let g:changelog_username = "mashiro <y.mashiro@gmail.com>"

" include guard
autocmd MyAutoCmd BufNewFile *.h,*.hh,*.hpp call s:include_guard()

" python header
autocmd MyAutoCmd BufNewFile *.py call s:python_header()


" Plugins {{{1
" runtimepath enable {{{2
set runtimepath+=~/.vim/plugins/align
"set runtimepath+=~/.vim/plugins/autocomplpop
set runtimepath+=~/.vim/plugins/neocomplcache
set runtimepath+=~/.vim/plugins/fuzzyfinder
set runtimepath+=~/.vim/plugins/gist
set runtimepath+=~/.vim/plugins/quickrun
set runtimepath+=~/.vim/plugins/surround
set runtimepath+=~/.vim/plugins/vimirc
set runtimepath+=~/.vim/plugins/yankring
set runtimepath+=~/.vim/plugins/skk


" fuf.vim {{{2
let g:fuf_splitPathMatching = ' '
let g:fuf_patternSeparator = ' '
let g:fuf_modesDisable = ['mrucmd']
let g:fuf_file_exclude = '\v\~$|\.(o|exe|bak|swp|gif|jpg|png)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])'
let g:fuf_mrufile_exclude = '\v\~$|\.bak$|\.swp|\.howm$|\.(gif|jpg|png)$'
let g:fuf_mrufile_maxItem = 10000
let g:fuf_enumeratingLimit = 20
nnoremap <silent> <Space>fb :FufBuffer<CR>
nnoremap <silent> <Space>ff :FufFile <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR>
nnoremap <silent> <Space>fr :FufMruFile<CR>
nnoremap <silent> <Space>fq :FufQuickfix<CR>
nnoremap <silent> <Space>fb :FufLine<CR>
nnoremap <silent> <Leader>fb :FufFile **/<CR>


" Align.vim {{{2
let g:Align_xstrlen=3


" neocomplcache.vim {{{2
let g:NeoComplCache_EnableAtStartup = 1
let g:NeoComplCache_SmartCase = 1
let g:NeoComplCache_EnableCamelCaseCompletion = 1
let g:NeoComplCache_EnableUnderbarCompletion = 1
let g:NeoComplCache_MinSyntaxLength = 3


" skk.vim {{{2
let skk_jisyo = '~/.skk-jisyo'
let skk_large_jisyo = '~/.vim/plugins/skk/dict/SKK-JISYO.L'
let skk_show_annotation = 1


" End {{{1
if filereadable(expand('~/.vimrc.local'))
	source ~/.vimrc.local
endif

