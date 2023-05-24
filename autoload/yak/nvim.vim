function! yak#nvim#popup(text) abort
  let l:lines = split(a:text, '\n')

  let l:width = 40
  let l:height = 5
  let l:row = line('.')
  let l:col = col('.')
  let l:border_opts = { 'style': 'double', 'highlight': 'FloatBorder' }

  let l:border_bufnr = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(l:border_bufnr, 0, -1, v:false, l:lines)
  call nvim_buf_set_option(l:border_bufnr, 'bufhidden', 'wipe')
  call nvim_buf_set_option(l:border_bufnr, 'filetype', 'popup')

  " let l:border_winid = nvim_open_win(l:border_bufnr, v:false, {
  "      \ 'relative': 'cursor',
  "      \ 'width': width,
  "      \ 'height': height,
  "      \ 'row': row,
  "      \ 'col': col,
  "      \ 'style': 'minimal'
  "      \ })

  let l:bufnr = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_option(l:bufnr, 'bufhidden', 'wipe')
  call nvim_buf_set_option(l:bufnr, 'filetype', 'popup')

  let l:winid = nvim_open_win(l:bufnr, v:true, {
        \ 'relative': 'cursor',
        \ 'width': width,
        \ 'height': height,
        \ 'row': row,
        \ 'col': col,
        \ 'style': 'minimal'
        \ })

  call nvim_win_set_option(l:winid, 'winblend', 50)
  " call nvim_win_set_option(l:border_winid, 'winhighlight', 'NormalFloat:FloatBorder')
  " call nvim_win_set_option(l:border_winid, 'winblend', 50)
  let l:autocmd_cmd = 'autocmd CursorMoved,CursorMovedI,BufHidden,BufLeave,BufWinLeave * if ! &buflisted | call nvim_win_close(' . l:winid . ', v:true) | endif'
  execute l:autocmd_cmd

  call nvim_buf_add_highlight(l:border_bufnr, -1, 'Normal', 0, 0, -1)
endfunction
