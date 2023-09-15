let s:yak_window = 0
let s:yak_last = ''


if !exists('g:yak_options')
  let g:yak_options = '-GAD' " MY
endif


function! s:show_yak_by_popup(text)
  if s:yak_window != 0
    call popup_close(s:yak_window)
  endif
  let l:lines = split(a:text, "\n")
  let s:yak_last = a:text
  let s:yak_window = popup_create(l:lines, {
    \   'moved': 'any',
    \   'drag': 1,
    \ })
    " \   'border': [1, 1, 1, 1],
endfunction

function! s:show_yak_by_echo(text)
  echo a:text
endfunction

function! s:show_yak(text)
  if has('popupwin')
    call s:show_yak_by_popup(a:text)
  else
    call s:show_yak_by_echo(a:text)
  endif
endfunction

function! s:append(text)
  call append('.', split(a:text, '\n'))
endfunction

function! s:get_selected_text() abort
  let l:start_line = line("'<")
  let l:end_line = line("'>")
  let l:start_col = col("'<")
  let l:end_col = col("'>")

  if l:start_line == l:end_line
    let l:line = getline(l:start_line)
    return strpart(l:line, l:start_col - 1, l:end_col - l:start_col + 1)
  endif

  let l:text = strpart(getline(l:start_line), l:start_col - 1) . "\n"
  for l:line in range(l:start_line + 1, l:end_line - 1)
    let l:text .= getline(l:line) . "\n"
  endfor
  let l:text .= strpart(getline(l:end_line), 0, l:end_col)

  return l:text
endfunction

function! s:replace_selected_text(text)
    let l:save_reg = @"
    normal! gvy
    normal! ci"
    execute 'normal! a' . a:text
    let @" = l:save_reg
endfunction

function! yak#show_last()
  if s:yak_last == ''
    call s:show_yak('EMPTY')
  else
    call s:show_yak(s:yak_last)
  endif
endfunction

function! yak#translate(text, bang)
  if 0 < len(a:text)
    let l:text = a:text
  else
    let l:text = s:get_selected_text()
  endif

  " call systemlist('notify-send -u low ' . shellescape(l:text))

  let l:text = trim(l:text)
  if l:text == ''
    echoerr 'Empty text'
    return
  endif

  let l:yakked = system('yak ' . g:yak_options . ' -- ' . shellescape(l:text))
  if a:bang
    call s:append(l:yakked)
  else
    call s:show_yak(l:yakked)
  endif
endfunction
