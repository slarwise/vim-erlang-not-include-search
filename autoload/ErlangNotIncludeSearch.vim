let s:pattern_templates = {
            \ 'function': '^\(-spec\s\+\)\=%s\s*(',
            \ 'type':     '^-\s*type\s*\%(\|(\)%s\s*(',
            \ 'opaque':   '^-\s*opaque\s*\%(\|\)%s\s*('
            \ }

function! ErlangNotIncludeSearch#GotoDefinitionUnderCursor(split) abort
    let under_cursor = s:GetModuleAndSymbolUnderCursor()
    if empty(under_cursor['module'])
        call s:GotoFunctionInCurrentFile(under_cursor['symbol'], a:split)
    else
        call s:GotoSymbolInModule(under_cursor['module'],
                    \ under_cursor['symbol'], a:split)
    endif
endfunction

function! s:GetModuleAndSymbolUnderCursor() abort
    let iskeyword_original = &l:iskeyword
    setlocal iskeyword+=:
    let cword_with_colon = expand('<cword>')
    let &l:iskeyword = iskeyword_original
    let split_on_colon = split(cword_with_colon, ':', 1)
    let symbol = split_on_colon[-1]
    let module = len(split_on_colon) == 1 ? '' : split_on_colon[0]
    return {'module': module, 'symbol': symbol}
endfunction

function! s:GotoFunctionInCurrentFile(funcname, split) abort
    let pattern = substitute(s:pattern_templates['function'], '%s', a:funcname, '')
    if a:split
        let linenr = search(pattern, 'cnw')
        if linenr > 0
            execute 'split +' . linenr
        endif
    else
        call search(pattern, 'csw')
    endif
endfunction

function! s:GotoSymbolInModule(module, symbol, split) abort
    let module_path = s:FindFile(a:module . '.erl')
    let module_path = empty(module_path) ? s:FindFile(a:module . '.hrl') : module_path
    if empty(module_path)
        return
    endif
    let pattern = map(values(s:pattern_templates),
                \ 'substitute(v:val, "%s", a:symbol, "")')
    let pattern = join(pattern, '\|')
    let linenr = s:SearchInFile(module_path, pattern)
    if linenr < 1
        return
    endif
    execute (a:split ? 'split' : 'edit') . ' +' . linenr . ' ' . module_path
endfunction

function! s:FindFile(fname) abort
    let path = findfile(a:fname)
    if !empty(path)
        return path
    endif
    " Taken from https://github.com/tpope/vim-fugitive/blob/master/autoload/fugitive.vim
    if &includeexpr =~# '\<v:fname\>'
        " TODO: This doesn't seem to work if &includeexpr is a variable pointing
        " to a closure
        sandbox let fname = eval(substitute(&includeexpr, '\C\<v:fname\>', '\=string(a:fname)', 'g'))
        let path = findfile(fname)
    endif
    return path
endfunction

function! s:SearchInFile(file, pattern) abort
    let contents = readfile(a:file)
    return match(contents, a:pattern) + 1
endfunction
