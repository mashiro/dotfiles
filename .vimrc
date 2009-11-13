" Options {{{1
set nocompatible
set runtimepath^=~/.vim
syntax on
filetype on
filetype indent on
filetype plugin on

" view
set antialias
set number
set ruler
set cursorline
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
set formatoptions+=mM
set iminsert=0
set imsearch=-1
set tags+=./tags;,./**/tags

" tab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
set smarttab

" backup
set backupdir=~/.vim_backup/backup
set directory=~/.vim_backup/swap
set clipboard=unnamed


"Encoding {{{1
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
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
set fileformats=unix,dos,mac
if exists('&ambiwidth')
  set ambiwidth=double
endif



"Map {{{1
" save, quit
"nnoremap <silent> <Space>w :<C-u>up<CR>
"nnoremap <silent> <Space>q :<C-u>quit<CR>

" fold
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
vnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
vnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'

" tab
nnoremap <C-t>n :tabnew<Cr>
nnoremap <C-t>c :tabclose<Cr>
nnoremap <C-t>l :tabnext<Cr>
nnoremap <C-t>h :tabprev<Cr>


"Command {{{1
" ctags
command! CtagsR !ctags -R --C++-kinds=+p --fields=+iaS --extra=+q .<CR>


"Function {{{1
function! s:include_guard()
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



"AutoCmd {{{1
" Adjust highlight settings according to the current colorscheme.
autocmd ColorScheme *
\   highlight Pmenu         guifg=#d0d0d0 guibg=#222233
\ | highlight PmenuSel      guifg=#eeeeee guibg=#4f4f87 gui=bold
\ | highlight PmenuSbar                   guibg=#333344

" MSBuild
"autocmd Filetype c,cpp,cs,vb compiler msbuild

" changelog
autocmd BufNewFile,BufRead *.changelog set filetype=changelog
let g:changelog_timeformat = "%Y-%m-%d"
let g:changelog_username = "mashiro <y.mashiro@gmail.com>"

" include guard
autocmd BufNewFile *.h,*.hh,*.hpp call s:include_guard()


"Plugin {{{1
" autocomplpop.vim
let g:AutoComplPop_IgnoreCaseOption = 1
let g:AutoComplPop_BehaviorKeywordLength = 2
let g:AutoComplPop_BehaviorFileLength = 0

" FuzzyFinder.vim
nnoremap <silent> <C-n> :FufBuffer!<CR>
nnoremap <silent> <C-p> :FufDir!<CR>
nnoremap <silent> ,fb :FufBuffer!<CR>
nnoremap <silent> ,ff :FufFile!<CR>
nnoremap <silent> ,fd :FufDir!<CR>

" quickrun.vim
let g:quickrun_config = {
\  'go': {
\    'command': '6g',
\    'exec': ['6g %s', '6l -o %s:p:r %s:p:r.6', '%s:p:r %a', 'rm -f %s:p:r']
\  }
\}


"Color {{{1
" colors
if &t_Co >= 256 || has("gui_running")
    colorscheme xoria256
else
    set background=dark
endif


" End {{{1
cd ~

