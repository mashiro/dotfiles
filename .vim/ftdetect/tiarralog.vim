au BufNewFile,BufRead * 
\   if expand("%:p") =~ "tiarra\/log\/.*\.txt"
\ |		set filetype=tiarralog
\ |	endif

