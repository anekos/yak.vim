
let s:V = vital#of('yak')
let s:VimBuffer = s:V.import('Vim.Buffer')


let s:yak_window = 0
let s:yak_last = ''


let g:yak_options = '-GA' " MY


function! s:show_yak(text)
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

function! yak#show_last()
  if s:yak_last == ''
    call s:show_yak('EMPTY')
  else
    call s:show_yak(s:yak_last)
  endif
endfunction

function! yak#translate(text)
  if 0 < len(a:text)
    let l:text = a:text
  else
    let l:text = s:VimBuffer.get_last_selected()
  endif
  let l:yakked = system('yak ' . g:yak_options . ' ' . shellescape(l:text))
  call s:show_yak(l:yakked)
endfunction
