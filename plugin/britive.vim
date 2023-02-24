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

command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveCheckout
                  \ !britive checkout <args>

command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveCheckoutEnv
                  \ !britive checkout --mode=displayenv <args>

command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveConsole
                  \ !britive checkout --console <args>
