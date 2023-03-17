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
      return filter(map(json_decode(system('pybritive ls profiles --silent')), {_,v -> v.name}), 'v:val =~ a:A')
endfunction


function! s:BritiveCheckout(mode,profile) abort
      if a:mode == 'console'
            echom 'pybritive checkout --console --silent ' . a:profile
            if has('macunix')
                  execute 'term pybritive checkout --console --silent ' . a:profile . ' | xargs -t open'
            elseif has('unix')
                  execute 'term pybritive checkout --console --silent ' . a:profile . ' | xargs -t xdg-open'
            elseif has('win32')
                  " unsure if pipe to start works on windows. needs testing.
                  execute 'term pybritive checkout --console --silent ' . a:profile . ' | start'
            else
                  echoerr 'System OS is unknown. Could not open Britive console URL. Run: pybritive checkout --console ' . a:profile
            endif
      else
            echom 'pybritive checkout ' . a:profile
            execute 'term pybritive checkout --silent ' . a:profile
      endif
endfunction

command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveCheckout
                  \ call s:BritiveCheckout('',<q-args>)

command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveCheckoutEnv
                  \ call s:BritiveCheckout('env',<q-args>)

command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveConsole
                  \ call s:BritiveCheckout('console',<q-args>)

if exists(':FZF')
      command! -nargs=* FZFBritiveCheckout
                        \ call fzf#run(fzf#wrap({'source':'pybritive ls profiles | jq -rc .[].name','sink': function('<sid>BritiveCheckout',[''])},<bang>0))
      command! -nargs=* FZFBritiveCheckoutEnv
                        \ call fzf#run(fzf#wrap({'source':'pybritive ls profiles | jq -rc .[].name','sink': function('<sid>BritiveCheckout',['env'])},<bang>0))
      command! -nargs=* FZFBritiveConsole
                        \ call fzf#run(fzf#wrap({'source':'pybritive ls profiles | jq -rc .[].name','sink': function('<sid>BritiveCheckout',['console'])},<bang>0))
endif
