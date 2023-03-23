" britive.vim - A Vim integration plugin for Britive CLI
" Maintainer: Peter Benjamin
" Version: 0.0.3

if exists('g:loaded_britive')
      finish
endif
let g:loaded_britive = 1

" BritiveCompletion provides Britive sub-command completion suggestions to :Britive command
function! s:BritiveCompletion(A,L,P) abort
      return filter([
                        \ 'api',
                        \ 'cache',
                        \ 'checkin',
                        \ 'checkout',
                        \ 'clear',
                        \ 'configure',
                        \ 'login',
                        \ 'logout',
                        \ 'ls',
                        \ 'request',
                        \ 'secret',
                        \ 'user',
                        \ ], 'v:val =~ a:A')
endfunction

" Britive command calls `pybritive` cli in a shell session using vim's
" `:!{cmd}`
command! -nargs=* -complete=customlist,s:BritiveCompletion Britive
                  \ ! pybritive <args>

" BritiveProfileCompletion provides profile name completion suggestions to
" :BritiveCheckout and :BritiveConsole commands
function! s:BritiveProfileCompletion(A,L,P) abort
      return filter(
                        \ systemlist('pybritive ls profiles --silent --format=csv | awk -F, ''{print $1"/"$2"/"$3}'' '),
                        \ 'v:val =~ a:A')
endfunction

function! s:BritiveCheckout(profile) abort
      let l:cmd = 'pybritive checkout ' .. shellescape(a:profile)
      echom l:cmd
      execute '! ' .. l:cmd | redraw!
endfunction

function! s:BritiveConsoleOpen(profile) abort
      let l:cmd = 'pybritive checkout --console --mode=browser ' .. shellescape(a:profile)
      echom l:cmd
      execute '! ' .. l:cmd | redraw!
endfunction

command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveCheckout
            \ call s:BritiveCheckout(<q-args>)
command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveConsole
            \ call s:BritiveConsoleOpen(<q-args>)

if exists(':FZF')
      command! -nargs=* BritiveCheckoutFZF
                        \ call fzf#run(
                        \     fzf#wrap(
                        \           {
                        \                 'source'  : 'pybritive ls profiles --silent --format=csv | awk -F, ''{print $1"/"$2"/"$3}'' | grep -v "Application/Environment/Profile"',
                        \                 'sink'    : function('<sid>BritiveCheckout'),
                        \                 'options' : '--multi --bind="ctrl-r:reload(pybritive ls profiles --silent --format=csv | awk -F, ''{print \$1\"/\"\$2\"/\"\$3}'' | grep -v "Application/Environment/Profile")"',
                        \           },
                        \           <bang>0,
                        \     )
                        \ )
      command! -nargs=* BritiveConsoleFZF
                        \ call fzf#run(
                        \     fzf#wrap(
                        \           {
                        \                 'source'  : 'pybritive ls profiles --silent --format=csv | awk -F, ''{print $1"/"$2"/"$3}'' | grep -v "Application/Environment/Profile"',
                        \                 'sink'   : function('<sid>BritiveConsoleOpen'),
                        \                 'options' : '--multi --bind="ctrl-r:reload(pybritive ls profiles --silent --format=csv | awk -F, ''{print \$1\"/\"\$2\"/\"\$3}'' | grep -v "Application/Environment/Profile")"',
                        \           },
                        \           <bang>0,
                        \     )
                        \ )
endif
