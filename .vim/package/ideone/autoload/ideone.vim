" A ref source for godoc.
" Version: 0.0.1
" Author : mattn <mattn.jp@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

let s:languages = {
\ "bc": "110",
\ "clojure": "111",
\ "javascript:spidermonkey": "112",
\ "go": "114",
\ "unlambda": "115",
\ "python3": "116",
\ "r": "117",
\ "cobol:opencobol": "118",
\ "oz": "119",
\ "perl6": "54",
\ "cpp": "1",
\ "pascal:gpc": "2",
\ "perl": "3",
\ "python": "4",
\ "fortran": "5",
\ "whitespace": "6",
\ "ada": "7",
\ "ocaml": "8",
\ "intercal": "9",
\ "nemerle": "30",
\ "lisp": "32",
\ "scheme": "33",
\ "c": "34",
\ "javascript:rhino": "35",
\ "erlang": "36",
\ "tcl": "38",
\ "scala": "39",
\ "groovy": "121",
\ "nimrod": "122",
\ "factor": "123",
\ "fsharp": "124",
\ "falcon": "125",
\ "text": "62",
\ "java": "10",
\ "c:gcc": "11",
\ "brainfuck": "12",
\ "asm:nasm": "13",
\ "clips": "14",
\ "prolog:swi": "15",
\ "icon": "16",
\ "ruby": "17",
\ "pike": "19",
\ "vbnet": "101",
\ "d": "102",
\ "awk:gawk": "104",
\ "awk:nawk": "105",
\ "cobol:tinycobol": "106",
\ "forth": "107",
\ "prolog:gnu": "108",
\ "asm:gcc": "45",
\ "haskell": "21",
\ "pascal:fpc": "22",
\ "smalltalk": "23",
\ "nice": "25",
\ "lua": "26",
\ "csharp": "27",
\ "sh": "28",
\ "php": "29",
\}

function! ideone#testFunction(ideone_user, ideone_pass)
  let envelope = xml#createElement("soap:Envelope")
  let envelope.attr["xmlns:soap"] = "http://schemas.xmlsoap.org/soap/envelope/"
  let envelope.attr["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"

  let body = xml#createElement("soap:Body")
  call add(envelope.child, body)
  let testFunction = xml#createElement("testFunction")
  call add(body.child, testFunction)

    let user = xml#createElement("user")
    let user.attr["xsi:type"] = "xsd:string"
    call user.value(a:ideone_user)
    call add(testFunction.child, user)

    let pass = xml#createElement("pass")
    let pass.attr["xsi:type"] = "xsd:string"
    call pass.value(a:ideone_pass)
    call add(testFunction.child, pass)

  let str = '<?xml version="1.0" encoding="UTF-8"?>' . envelope.toString()
  let res = http#post("http://ideone.com/api/1/service", str)
  let dom = xml#parse(res.content)
  let ret = {}
  for item in dom.findAll("item")
    let ret[item.find("key").value()] = item.find("value").value()
  endfor
  return ret
endfunction

function! ideone#getLanguages(ideone_user, ideone_pass)
  let envelope = xml#createElement("soap:Envelope")
  let envelope.attr["xmlns:soap"] = "http://schemas.xmlsoap.org/soap/envelope/"
  let envelope.attr["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"

  let body = xml#createElement("soap:Body")
  call add(envelope.child, body)
  let getLanguages = xml#createElement("getLanguages")
  call add(body.child, getLanguages)

    let user = xml#createElement("user")
    let user.attr["xsi:type"] = "xsd:string"
    call user.value(a:ideone_user)
    call add(getLanguages.child, user)

    let pass = xml#createElement("pass")
    let pass.attr["xsi:type"] = "xsd:string"
    call pass.value(a:ideone_pass)
    call add(getLanguages.child, pass)

  let str = '<?xml version="1.0" encoding="UTF-8"?>' . envelope.toString()
  let res = http#post("http://ideone.com/api/1/service", str)
  let dom = xml#parse(res.content)
  let ret = {}
  for item in dom.findAll("item")
    let ret[item.find("key").value()] = item.find("value").value()
  endfor
  return ret
endfunction

function! ideone#createSubmission(ideone_user, ideone_pass, sourceCode, language, input, run, private)
  let envelope = xml#createElement("soap:Envelope")
  let envelope.attr["xmlns:soap"] = "http://schemas.xmlsoap.org/soap/envelope/"
  let envelope.attr["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"
  let body = xml#createElement("soap:Body")

    call add(envelope.child, body)
    let createSubmission = xml#createElement("createSubmission")
    call add(body.child, createSubmission)

    let user = xml#createElement("user")
    let user.attr["xsi:type"] = "xsd:string"
    call user.value(a:ideone_user)
    call add(createSubmission.child, user)

    let pass = xml#createElement("pass")
    let pass.attr["xsi:type"] = "xsd:string"
    call pass.value(a:ideone_pass)
    call add(createSubmission.child, pass)

    let sourceCode = xml#createElement("sourceCode")
    let sourceCode.attr["xsi:type"] = "xsd:string"
    call sourceCode.value(a:sourceCode)
    call add(createSubmission.child, sourceCode)

    let language = xml#createElement("language")
    let language.attr["xsi:type"] = "xsd:integer"
    call language.value(a:language)
    call add(createSubmission.child, language)

    let inpu = xml#createElement("input")
    let inpu.attr["xsi:type"] = "xsd:string"
    call inpu.value(a:input)
    call add(createSubmission.child, inpu)

    let run = xml#createElement("run")
    let run.attr["xsi:type"] = "xsd:boolean"
    call run.value(a:run ? "true" : "false")
    call add(createSubmission.child, run)

    let private = xml#createElement("private")
    let private.attr["xsi:type"] = "xsd:boolean"
    call private.value(a:private ? "true" : "false")
    call add(createSubmission.child, private)

  let str = '<?xml version="1.0" encoding="UTF-8"?>' . envelope.toString()
  let res = http#post("http://ideone.com/api/1/service", str)
  let dom = xml#parse(res.content)
  let ret = {}
  for item in dom.findAll("item")
    let ret[item.find("key").value()] = item.find("value").value()
  endfor
  return ret
endfunction

function! ideone#getLangIds(name)
  if has_key(s:languages, a:name)
    return [s:languages[a:name]]
  else
    let c = []
    for key in keys(s:languages)
      if key[:len(a:name)-1] == a:name
        call add(c, key)
      endif
    endfor
    return c
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
