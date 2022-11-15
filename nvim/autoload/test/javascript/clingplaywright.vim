if !exists('g:test#javascript#clingplaywright#file_pattern')
    let g:test#javascript#clingplaywright#file_pattern = '\vplaywright/__tests__/.*\.ts$'
endif

function! test#javascript#clingplaywright#test_file(file) abort
    return a:file =~# g:test#javascript#clingplaywright#file_pattern
endfunction

function! test#javascript#clingplaywright#build_position(type, position) abort
    return ["--test_filter", substitute(a:position['file'], 'packages\/\(.*\)\.ts$', '\1', 'g')]
endfunction

function! test#javascript#clingplaywright#build_args(args) abort
    if index(a:args, "--project") < 0
        call add(a:args, '--project')
        call add(a:args, 'Chromium')
    endif
    return ['-u', 'build/fluctl/fluctl.py', '--noprogress', '-vv', 'test', 'playwright', 'all'] + a:args
endfunction

function! test#javascript#clingplaywright#executable() abort
    return 'python3'
endfunction

