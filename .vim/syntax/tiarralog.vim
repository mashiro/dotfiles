" Vim syntax file
" Language:    tiarra log file
" Written By:  mashiro <y.mashiro@gmail.com>
" Last Change: 2010 Jan 06

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn match  tiarralogLine       "^.*$" contains=tiarralogTime
syn match  tiarralogTime       contained "\(\d\{2\}:\)\{1,2\}\d\{2\}" skipwhite nextgroup=tiarralogSelf,tiarralogOthers,tiarralogNotice,tiarralogJoin,tiarralogLeave,tiarralogTopic,tiarralogMode,tiarralogNick
syn region tiarralogSelf       contained start=+>+ end=+<+ contains=tiarralogChannel nextgroup=tiarralogSelfText keepend
syn region tiarralogOthers     contained start=+<+ end=+>+ nextgroup=tiarralogOthersText keepend
syn region tiarralogNotice     contained start=+(+ end=+)+ nextgroup=tiarralogNoticeText keepend
syn region tiarralogJoin       contained start="+" end="$" keepend
syn region tiarralogLeave      contained start="[-!]" end="$" keepend
syn region tiarralogMode       contained start="Mode" end="$" keepend
syn region tiarralogTopic      contained start="Topic" end="$" keepend
syn match  tiarralogNick       contained "[^ ><(].\+ -> .\+"
syn match  tiarralogSelfText   contained ".*" contains=tiarralogUrl
syn match  tiarralogOthersText contained ".*" contains=tiarralogUrl
syn match  tiarralogNoticeText contained ".*"
syn match  tiarralogUrl        contained "\(https\?\|ftp\)://\S*"

" Define the default highlighting.
hi def link tiarralogLine       Normal
hi def link tiarralogTime       Number
hi def link tiarralogJoin       Include
hi def link tiarralogLeave      Include
hi def link tiarralogTopic      Identifier
hi def link tiarralogMode       Statement
hi def link tiarralogNick       Statement
hi def link tiarralogSelf       Special
hi def link tiarralogSelfText   Normal
hi def link tiarralogOthers     Type
hi def link tiarralogOthersText Normal
hi def link tiarralogNotice     Comment
hi def link tiarralogNoticeText Comment
hi def link tiarralogUrl        String

let b:current_syntax = "tiarralog"
