" britive.vim - A Vim integration plugin for Britive CLI
" Maintainer: Peter Benjamin
" Version: 0.0.2

if exists('g:loaded_britive')
      finish
endif
let g:loaded_britive = 1

" BritiveCompletion provides Britive sub-command completion suggestions to :Britive command
function! s:BritiveCompletion(A,L,P) abort
      return filter([
                        \ 'api'
                        \ 'cache'
                        \ 'checkin'
                        \ 'checkout'
                        \ 'clear'
                        \ 'configure'
                        \ 'login'
                        \ 'logout'
                        \ 'ls'
                        \ 'request'
                        \ 'secret'
                        \ 'user'
                        \ ], 'v:val =~ a:A')
endfunction

" Britive command wraps `britive` cli in a terminal buffer
command! -nargs=* -complete=customlist,s:BritiveCompletion Britive
                  \ term pybritive <args>

" BritiveProfileCompletion provides profile name completion suggestions to
" :BritiveCheckout and :BritiveConsole commands
function! s:BritiveProfileCompletion(A,L,P) abort
      return filter(systemlist('pybritive ls profiles --silent --format=csv | awk -F, ''{print $1"/"$2"/"$3}'' '), 'v:val =~ a:A')
endfunction


function! s:BritiveCheckout(mode,profile) abort
      let l:profile = shellescape(a:profile)
      if has('macunix')
            let l:open = 'open'
      elseif has('unix')
            let l:open = 'xdg-open'
      elseif has('win32')
            let l:open = 'start'
      endif
      if a:mode == 'console'
            if has('unix')
                  let l:cmd = 'pybritive checkout --console --silent ' .. l:profile .. ' | xargs -t ' .. l:open
            else
                  let l:cmd = 'pybritive checkout --console --silent ' .. l:profile .. ' | ' .. l:open
            endif
            echom l:cmd
            execute '! ' .. l:cmd
      else
            let l:cmd = 'pybritive checkout --silent ' .. l:profile
            echom l:cmd
            execute '! ' .. l:cmd
      endif
endfunction

command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveCheckout
                  \ call s:BritiveCheckout('',<q-args>)
command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveConsole
                  \ call s:BritiveCheckout('console',<q-args>)

if exists(':FZF')
      command! -nargs=* FZFBritiveCheckout
                        \ call fzf#run(fzf#wrap({'source':'pybritive ls profiles --silent --format=csv | awk -F, ''{print $1"/"$2"/"$3}'' ','sink': function('<sid>BritiveCheckout',[''])},<bang>0))
      command! -nargs=* FZFBritiveConsole
                        \ call fzf#run(fzf#wrap({'source':'pybritive ls profiles --silent --format=csv | awk -F, ''{print $1"/"$2"/"$3}'' ','sink': function('<sid>BritiveCheckout',['console'])},<bang>0))
endif
