
function! marktodo#toggle()
  let line = getline(".")
  if line =~# "-- "
    let line = substitute(line, "-- ", "++ ", "g")
  else
    let line = substitute(line, "++ ", "-- " ,"g")
  endif
  call setline(".", line)
endfunction

function! marktodo#done_down()
  let startpos = marktodo#start_of_project()
  let endpos = marktodo#end_of_project()
  exe startpos.','.endpos 'sort /++/'
endfunction

function! marktodo#add_tag(tag)
  let tag = ' #' . a:tag
  let cur_line = getline(".")
  let new_line = cur_line . tag
  call setline(".", new_line)
  return 1
endfunction

function! marktodo#remove_tag(tag)
  let tag = ' #' . a:tag
  let cur_line = getline(".")
  let new_line = substitute(cur_line, tag, "", "g")
  call setline('.', new_line)
  return 1
endfunction

function! marktodo#toggle_tag(tag)
  let tag = ' #' . a:tag
  let cur_line = getline(".")
  if cur_line =~# tag
    call marktodo#remove_tag(a:tag)
  else
    call marktodo#add_tag(a:tag)
  endif
  return 1
endfunction

function! marktodo#start_of_project()
  return search('^#', 'Wbn') + 1
endfunction

function! marktodo#end_of_project()
  let endpos = search('^\n', 'Wn') - 1
  if endpos == -1
    let endpos = getpos('$')[1]
  endif
  return endpos
endfunction

function! marktodo#select_project()
  let start = marktodo#start_of_project()
  let end = marktodo#end_of_project()
  call setpos('.',[0, start, 1])
  normal! v
  call setpos('.',[0, end, 999])
endfunction

function! marktodo#syntax()
  syn match marktodoActiveItem /^\s*--\s/
  hi link marktodoActiveItem Keyword
  syn match marktodoCompleteItem /^\s*++\s.*$/
  hi link marktodoCompleteItem Comment

  syn match marktodoTodayLine /#today/
  syn match marktodoToday +--\%(.*#today\)\@=+
  hi link marktodoToday Identifier
  syn match marktodoWeek +--\%(.*#week\)\@=+
  hi link marktodoWeek Label
  syn match marktodoNext +--\%(.*#next\)\@=+
  hi link marktodoNext Search

  syn match marktodoTag /#\w\+/
  hi link marktodoTag Comment

  syn cluster mkdNonListItem contains=htmlItalic,htmlBold,htmlBoldItalic,mkdFootnotes,mkdID,mkdURL,mkdLink,mkdLinkDef,mkdLineBreak,mkdBlockquote,mkdCode,mkdIndentCode,mkdListItem,mkdRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,marktodoActiveItem,marktodoCompleteItem,marktodoToday,marktodoWeek,marktodoNext,marktodoTag
  setlocal comments=b:*,b:+,b:-,b:--

endfunction

function! marktodo#newline(offset)
  let lnum = line('.')
  let line = getline('.')
  let startlnum = lnum+a:offset
  call append(startlnum, '')
  execute startlnum+1
  if line =~# "[-+][-+] "
    call setline(startlnum+1, "-- ")
  endif
  startinsert!
  return "\<End>"

endfunction

function! marktodo#mapping()
  if mapcheck("o", "n") == ''
    nmap <silent> <buffer> o :call marktodo#newline(0)<CR>
    nmap <silent> <buffer> O :call marktodo#newline(-1)<CR>
  endif

endfunction


function! marktodo#init()
  map <buffer> <silent> <leader><space> :call marktodo#toggle()<CR>
  call marktodo#mapping()
  call marktodo#syntax()
endfunction

au BufLeave,CursorHold *.md :w

