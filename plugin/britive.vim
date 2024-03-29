" britive.vim - A Vim integration plugin for Britive CLI
" Maintainer: Peter Benjamin
" Version: 0.0.3

if exists('g:loaded_britive')
      finish
endif
let g:loaded_britive = 1

" BritiveCompletion provides Britive sub-command completion suggestions to
" :Britive command
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
command! -nargs=* -complete=customlist,s:BritiveCompletion Britive silent ! pybritive <args>

" BritiveAPICompletion function provides class names & methods as completion
" suggestions to :BritiveAPI command
function! BritiveAPICompletion(A,L,P) abort
      return filter([
                        \ 'applications.catalog',
                        \ 'applications.create',
                        \ 'applications.delete',
                        \ 'applications.disable',
                        \ 'applications.enable',
                        \ 'applications.get',
                        \ 'applications.list',
                        \ 'applications.scan',
                        \ 'applications.test',
                        \ 'applications.update',
                        \ 'environment_groups.get',
                        \ 'environment_groups.list',
                        \ 'environments.create',
                        \ 'environments.delete',
                        \ 'environments.get',
                        \ 'environments.list',
                        \ 'environments.scan',
                        \ 'environments.test',
                        \ 'environments.update',
                        \ 'my_access.approval_request_status',
                        \ 'my_access.checkin',
                        \ 'my_access.checkin_by_name',
                        \ 'my_access.checkout',
                        \ 'my_access.checkout_by_name',
                        \ 'my_access.credentials',
                        \ 'my_access.favorites',
                        \ 'my_access.frequents',
                        \ 'my_access.get_checked_out_profile',
                        \ 'my_access.list_checked_out_profiles',
                        \ 'my_access.list_profiles',
                        \ 'my_access.request_approval',
                        \ 'my_access.request_approval_by_name',
                        \ 'my_access.whoami',
                        \ 'my_access.withdraw_approval_request',
                        \ 'my_access.withdraw_approval_request_by_name',
                        \ 'profiles.create',
                        \ 'profiles.delete',
                        \ 'profiles.disable',
                        \ 'profiles.enable',
                        \ 'profiles.get',
                        \ 'profiles.list',
                        \ 'profiles.update',
                        \ 'reports.list',
                        \ 'reports.run',
                        \ 'scans.diff',
                        \ 'scans.history',
                        \ 'scans.scan',
                        \ 'scans.status',
                        \ 'tags.create',
                        \ 'tags.delete',
                        \ 'tags.disable',
                        \ 'tags.enable',
                        \ 'tags.get',
                        \ 'tags.list',
                        \ 'tags.search',
                        \ 'tags.update',
                        \ 'tags.users_for_tag',
                        \ 'task_services.get',
                        \ 'tasks.get',
                        \ 'tasks.list',
                        \ 'tasks.statuses',
                        \ 'users.delete',
                        \ 'users.disable',
                        \ 'users.enable',
                        \ 'users.get',
                        \ 'users.get_by_name',
                        \ 'users.get_by_status',
                        \ 'users.list',
                        \ 'users.reset_mfa',
                        \ 'users.reset_password',
                        \ 'users.search',
                        \ 'users.update',
                        \ ], 'v:val =~ a:A')
endfunction

" BritiveAPI command wraps `pybritive api` cli sub-command to enable
" user-friendly tab-completions
command! -nargs=* -complete=customlist,BritiveAPICompletion BritiveAPI ! pybritive api <args>

" BritiveProfileCompletion provides profile name completion suggestions to
" :BritiveCheckout and :BritiveConsole commands
function! s:BritiveProfileCompletion(A,L,P) abort
      return filter(systemlist('pybritive ls profiles --silent --format=csv | awk -F, ''{print $1"/"$2"/"$3}'' '), 'v:val =~ a:A')
endfunction

function! s:BritiveCheckout(args) abort
      if empty(a:args.profile)
            let l:cmd = 'pybritive ls profiles --format=list | fzf-tmux --multi --reverse -p ''70%'' --prompt ''Britive Profiles> '' --bind=$''ctrl-r:reload(pybritive ls profiles --format=list)'' --query "${INITIAL_QUERY}" | xargs -t -L1 -I{} pybritive checkout --mode=browser "{}"'
            echom trim(system(l:cmd))
      else
            let l:profile = shellescape(a:args.profile)
            if a:args.mode == 'env'
                  execute '! pybritive checkout ' .. l:profile
            elseif a:args.mode == 'browser'
                  execute '! pybritive checkout -m browser ' .. l:profile
            endif
      endif
endfunction

command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveCheckout call s:BritiveCheckout({'mode': 'env', 'profile': <q-args>})
command! -nargs=* -complete=customlist,s:BritiveProfileCompletion BritiveConsole call s:BritiveCheckout({'mode': 'browser', 'profile': <q-args>})
