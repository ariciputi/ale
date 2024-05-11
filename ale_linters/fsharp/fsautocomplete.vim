" Author: Andrea Riciputi <andrea.riciputi@gmail.com>
" Description: A language server for F#

call ale#Set('fsharp_language_server_assembly', 'fsautocomplete')
call ale#Set('fsharp_language_server_executable', 'dotnet')

function! ale_linters#fsharp#fsautocomplete#SearchDirUpward(directory, patterns) abort
    let l:search_dir = a:directory
    let l:found = []

    for pp in a:patterns
        let l:glob_pattern = l:search_dir . '/' . pp
        let l:found = glob(l:glob_pattern, v:false, v:true)

        if !empty(l:found)
            break
        endif
    endfor

    if empty(l:found)
        let l:search_dir = fnameescape(fnamemodify(l:search_dir, ':h'))

        return ale_linters#fsharp#fsautocomplete#SearchDirUpward(l:search_dir, a:patterns)

    endif

    return fnamemodify(l:found[0], ':p:h')
endfunction

function! ale_linters#fsharp#fsautocomplete#Foo(buffer, patterns) abort
    let l:start_dir = fnameescape(fnamemodify(bufname(a:buffer), ':p:h'))

    return ale_linters#fsharp#fsautocomplete#SearchDirUpward(l:start_dir, a:patterns)
endfunction

function! ale_linters#fsharp#fsautocomplete#GetProjectRoot(buffer) abort
    " TODO: Find nearest project file <project name>.fsproj
    let l:git_path = ale#path#FindNearestDirectory(a:buffer, '.git')

    return !empty(l:git_path) ? fnamemodify(l:git_path, ':h:h') : ''
endfunction

"\   'cwd': function('ale_linters#python#pylsp#GetCwd'),
"\   'completion_filter': 'ale#completion#python#CompletionItemFilter',
call ale#linter#Define('fsharp', {
\   'name': 'fsautocomplete',
\   'lsp': 'stdio',
\   'executable': {b -> ale#Var(b, 'fsharp_language_server_executable') },
\   'command': {b -> '%e ' . ale#Var(b, 'fsharp_language_server_assembly') . ' --adaptive-lsp-server-enabled --debug --log-file foo.log' },
\   'project_root': function('ale_linters#fsharp#fsautocomplete#GetProjectRoot'),
\   'initialization_options': { 'AutomaticWorkspaceInit': v:true , 'KeywordsAutocomplete': v:true, 'Linter': v:true }
\})
