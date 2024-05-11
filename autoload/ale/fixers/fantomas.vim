" Author: ariciputi <andrea.riciputi@gmail.com>
" Description: Format F# files with Fantomas.

call ale#Set('fsharp_fantomas_executable', 'dotnet')
call ale#Set('fsharp_fantomas_options', '')

function! ale#fixers#fantomas#Fix(buffer) abort
    let l:executable = ale#Var(a:buffer, 'fsharp_fantomas_executable')
    let l:options = ale#Var(a:buffer, 'fsharp_fantomas_options')

    return {
    \    'command': ale#Escape(l:executable)
    \       . ' fantomas'
    \       . (empty(l:options) ? '' : ' ' . l:options)
    \       . ' %s',
    \    'read_buffer': 0,
    \    'output_stream': 'none',
    \    'process_with': 'FantomasCallback',
    \}
endfunction

" ALE does not play well with fixers that only change the target file on disk
" (https://github.com/dense-analysis/ale/issues/611). Running a callback that
" simply call the :edit command forces Vim to reload the file from disk.
function! FantomasCallback(buffer, output) abort
    edit
    return []
endfunction
