
command! -nargs=* -bang Yak call yak#translate(<q-args>, <bang>0)
command! YakLast call yak#show_last()
