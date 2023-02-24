" britive.vim - A Vim integration plugin for Britive CLI
" Maintainer: Peter Benjamin
" Version: 0.0.1

if exists('g:loaded_britive')
      finish
endif
let g:loaded_britive = 1

" BritiveCompletion provides Britive sub-command completion suggestions to :Britive command
function! s:BritiveCompletion(A,L,P) abort
      return filter([
                        \ 'checkin',
                        \ 'checkout',
                        \ 'configure',
                        \ 'listapplications',
                        \ 'listenvs',
                        \ 'listprofiles',
                        \ 'listsecrets',
                        \ 'login',
                        \ 'logout',
                        \ 'ls',
                        \ 'user',
                        \ 'viewsecret',
                        \ ], 'v:val =~ a:A')
endfunction

" Britive command wraps `britive` cli in a terminal buffer
command! -nargs=* -complete=customlist,s:BritiveCompletion Britive
                  \ !britive <args>

" BritiveProfileCompletion provides profile name completion suggestions to
" :BritiveCheckout and :BritiveConsole commands
function! s:BritiveProfileCompletion(A,L,P) abort
      return filter(map(json_decode(system('britive listprofiles 2>/dev/null')), {_,v -> v.name}), 'v:val =~ a:A')
endfunction

function! s:BritiveOpen(profile) abort
      echom 'britive checkout --console --silent ' . a:profile
      if has('macunix')
            execute '!britive checkout --console --silent ' . a:profile . ' 2>/dev/null | xargs -t open'
      elseif has('unix')
            execute '!britive checkout --console --silent ' . a:profile . ' 2>/dev/null | xargs -t xdg-open'
      elseif has('win32')
            echoerr "Command is unimplemented for Windows."
      else
            echoerr "System OS is unknown. Could not open Britive console URL."
      endif
endfunction

command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveCheckout
                  \ !britive checkout <args>

command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveCheckoutEnv
                  \ !britive checkout --mode=displayenv <args>

command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveConsole
                  \ !britive checkout --console <args>

command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveConsoleOpen
                  \ call s:BritiveOpen(<q-args>)
