"=============================================================================
" File: ideone.vim
" Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
" Last Change: 27-Oct-2010.
" Version: 0.1
" WebPage: http://github.com/mattn/ideone-vim
" License: BSD
" Usage:
"
"   :Ideone
"     post whole text to ideone.
"
"   :'<,'>Ideone
"     post selected text to ideone.
"
"   :Ideone -p
"     post whole text to ideone with private.
"
"   :Ideone -r
"     post whole text to ideone with run.
"
" Tips:
"   * if you want to open browser after the post...
"
"     let g:ideone_open_browser_after_post = 1
"
"   * if you want to change the browser...
"
"     let g:ideone_browser_command = 'w3m %URL%'
"
"       or
"
"     let g:ideone_browser_command = 'opera %URL% &'
"
"     on windows, should work with your setting.
"
" Require:
"   webapi-vim : http://github.com/mattn/webapi-vim
"
" script type: plugin

if &cp || (exists('g:loaded_ideone_vim') && g:loaded_ideone_vim)
  finish
endif
let g:loaded_ideone_vim = 1
if !exists('g:ideone_open_browser_after_post')
  let g:ideone_open_browser_after_post = 0
endif

if !exists('g:ideone_browser_command')
  if has('win32')
    let g:ideone_browser_command = "!start rundll32 url.dll,FileProtocolHandler %URL%"
  elseif has('mac')
    let g:ideone_browser_command = "open %URL%"
  elseif executable('xdg-open')
    let g:ideone_browser_command = "xdg-open %URL%"
  else
    let g:ideone_browser_command = "firefox %URL% &"
  endif
endif

if !exists('g:ideone_put_url_to_clipboard_after_post')
  let g:ideone_put_url_to_clipboard_after_post = 1
endif

let s:ideone_user = ''
let s:ideone_pass = ''

function! s:Ideone(line1, line2, ...)
  let args = (a:0 > 0) ? split(a:1, '\s\+') : []
  let run = 1
  let private = 0
  for arg in args
    if arg == "-r" || arg == "--run"
      let run = 1
    elseif arg == "-p" || arg == "--private"
      let private = 1
    elseif len(arg) > 0
      echoerr 'Invalid arguments'
      unlet args
      return
    endif
  endfor
  if len(s:ideone_user) == 0
    let s:ideone_user = input('Username:')
    if len(s:ideone_user) == 0
      echo 'Canceled'
      return
    endif
  endif
  if len(s:ideone_pass) == 0
    let s:ideone_pass = inputsecret('Password:')
    if len(s:ideone_pass) == 0
      echo 'Canceled'
      return
    endif
  endif
 
  let ids = ideone#getLangIds(&ft)
  let id = ''
  if len(ids) == 0
    let id = "64"
  elseif len(ids) == 1
    let id = ids[0]
  else
    while 1
      for v in range(len(ids))
        echo (v+1).':'.ids[v]
      endfor
      let n = 0+input("Which language do you want to post?:")
      redraw
      if n == 0
        break
      endif
      if n > 0 && n <= len(ids)
        let tmp = ideone#getLangIds(ids[n-1])
        let id = tmp[0]
        break
      endif
    endwhile
  endif
  if len(id) == 0
    return
  endif
  let content = join(getline(a:line1, a:line2), "\n")."\n"
  let res = ideone#createSubmission(s:ideone_user, s:ideone_pass, content, id, '', run, private)
  if has_key(res, "error")
    if res["error"] == "OK"
      let url = "http://ideone.com/".res["link"]
	  echo url
      if len(url) > 0 && g:ideone_open_browser_after_post
        let cmd = substitute(g:ideone_browser_command, '%URL%', url, 'g')
        if cmd =~ '^!'
          silent! exec cmd
        else
          call system(cmd)
        endif
      endif
      if g:ideone_put_url_to_clipboard_after_post == 1
        if has('unix') && !has('xterm_clipboard')
          let @" = url
        else
          let @+ = url
        endif
      endif
    else
      echoerr res["error"]
    endif
  else
    echoerr 'Invalid Response'
  endif
endfunction

command! -nargs=? -range=% Ideone :call <SID>Ideone(<line1>, <line2>, <f-args>)
" vim:set et:
