function! neoterm#repl#set(value)
  let g:neoterm_repl_command = a:value
endfunction

function! neoterm#repl#send(...)
  let l:opts = extend(a:1, { 'scope': 'line', 'target': 0 }, 'keep')
  let l:instance = s:target(l:opts)
endfunction

function! s:target(opts)
  if a:opts.target > 0
    if has_key(g:neoterm.instances, a:opts.target)
      let l:instance = g:neoterm.instances[a:opts.target]

      return s:load_repl(l:instance)
    else
      echoe printf('neoterm-%s not found', a:opts.target)
    end
  elseif g:neoterm_term_per_tab && has_key(t:, 'neoterm_id')
    if has_key(g:neoterm.instances, t:neoterm_id)
      let l:instance = g:neoterm.instances[t:neoterm_id]

      return s:load_repl(l:instance)
    else
      echoe printf('neoterm-%s not found', t:neoterm_id)
    end
  elseif g:neoterm.has_any()
    let l:instance = g:neoterm.last()

    return s:load_repl(l:instance)
  else
    return {}
  end
endfunction


function! s:load_repl(instance)
  if !g:neoterm_auto_repl_cmd || a:instance.repl_loaded
    return a:instance
  end

  call neoterm#exec({
        \ 'cmd': [g:neoterm_repl_command, g:neoterm_eof],
        \ 'target': a:instance.id
        \ })

  let a:instance.repl_loaded = 1
endfunction
