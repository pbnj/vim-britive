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


function! s:BritiveCheckout(mode,profile) abort
      if a:mode == 'console'
            echom 'britive checkout --console --silent ' . a:profile
            if has('macunix')
                  execute '!britive checkout --console --silent ' . a:profile . ' 2>/dev/null | xargs -t open'
            elseif has('unix')
                  execute '!britive checkout --console --silent ' . a:profile . ' 2>/dev/null | xargs -t xdg-open'
            elseif has('win32')
                  echoerr 'Command is unimplemented for Windows. Run: britive checkout --console ' . a:profile
            else
                  echoerr 'System OS is unknown. Could not open Britive console URL. Run: britive checkout --console ' . a:profile
            endif
      elseif a:mode == 'env'
            echom 'britive checkout --silent  --mode=displayenv ' . a:profile
            execute '!britive checkout --silent  --mode=displayenv ' . a:profile
      else
            echom 'britive checkout --silent ' . a:profile
            execute '!britive checkout --silent ' . a:profile
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
                        \ call fzf#run(fzf#wrap({'source':'britive listprofiles | jq -rc .[].name','sink': function('<sid>BritiveCheckout',[''])},<bang>0))
      command! -nargs=* FZFBritiveCheckoutEnv
                        \ call fzf#run(fzf#wrap({'source':'britive listprofiles | jq -rc .[].name','sink': function('<sid>BritiveCheckout',['env'])},<bang>0))
      command! -nargs=* FZFBritiveConsole
                        \ call fzf#run(fzf#wrap({'source':'britive listprofiles | jq -rc .[].name','sink': function('<sid>BritiveCheckout',['console'])},<bang>0))
endif
