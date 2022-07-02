let g:profiling = 'stopped'
let g:profile_file = ''

fun! Profile(action, ...)
  let data = a:0
  if g:profiling == 'stopped'
    call ProfileStart()
  elseif g:profiling == 'started'
    if a:action == 'stop'
      call ProfileStop()
    elseif a:action == 'pause'
      call ProfilePause()
    elseif a:action == 'portion'
      call ProfilePortion(data)
    else
      call ProfileStop()
    endif
  else
    echo "No matching command..."
  endif
endfunction

fun! ProfileStart()
  let g:profiling = 'started'
  let l:date = system('date "+%Y-%m-%dT%H:%M:%S" | tr -d "\n"')
  let g:profile_file = 'profile-' . l:date . '.log'
  echo 'starting profile with ' . g:profile_file
  execute 'profile start ' . g:profile_file
  "profile start $g:profile_file
  profile func *
  profile file *
endfunction

fun! ProfilePause()
  let g:profiling = 'paused'
  echo 'Pausing profile, you will need to exit to see results'
  execute 'profile pause'
endfunction

fun! ProfileStop()
  let g:profiling = 'stopped'
  echo 'Stopping profile, profile written to ' . g:profile_file
  execute 'profile stop'
endfunction

fun! ProfileOpen()
  tabnew g:profile_file
endfunction

command! -nargs=* Profile call Profile(<q-args>)
command! ProfileOpen call ProfileOpen()

" Run from an empty buffer
function! GetCommandFrequency()
  " Be sure to change viminfo path if you put yours elsewhere (like nvim's shada or my vim-cache).
  .! grep -e"^:"  ~/.viminfo
  %v/^:/d
  %sm/\v^:(silent|verb\w*) /:
  %sm,[ /].*
  %sm/^:..,../:
  %sm/^:%/:
  %g/\v^:?\s*$/d
  %sort
  %g/^:\W/d
  %! uniq -c
  %sort n
  " Ignore single use items
  %g/   1 :/d
  10,$-10delete
  0put ='Bottom (but more than once) usage:'
  10put ='Top usage:'
  $put ='out of total non-unique commands'
  $put =''
  $! grep -e"^:"  ~/.viminfo | wc -l
  " Indent for posting to reddit.
  exec "norm! gg0\<C-v>GI    "
endf

