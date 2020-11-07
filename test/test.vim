" To run this from the command line, do
" nvim -c 'source test/test.vim'
source autoload/ErlangNotIncludeSearch.vim
set path=test

function! TestGotoFunctionInCurrentModule() abort
    let v:errors = []
    execute 'edit +call\ search("subtract0") test/a.erl'
    call ErlangNotIncludeSearch#GotoDefinitionUnderCursor(0)
    call assert_equal(1, col('.'))
    call assert_equal('subtract0(X, Y) ->', getline('.'))
    if !empty(v:errors)
        echo v:errors
    endif

    let v:errors = []
    execute 'edit +call\ search("subtract1") test/a.erl'
    call ErlangNotIncludeSearch#GotoDefinitionUnderCursor(0)
    call assert_equal(1, col('.'))
    call assert_equal('subtract1  (X, Y) ->', getline('.'))
    if !empty(v:errors)
        echo v:errors
    endif
endfunction

function! TestGotoFunctionInAnotherModule() abort
    let v:errors = []
    execute 'edit +call\ search("b:add0") test/a.erl'
    call ErlangNotIncludeSearch#GotoDefinitionUnderCursor(0)
    call assert_equal('test/b.erl', expand('%'))
    call assert_equal(1, col('.'))
    call assert_equal('add0(X, Y) ->', getline('.'))
    if !empty(v:errors)
        echo v:errors
    endif

    let v:errors = []
    execute 'edit +call\ search("b:add1") test/a.erl'
    call ErlangNotIncludeSearch#GotoDefinitionUnderCursor(0)
    call assert_equal('test/b.erl', expand('%'))
    call assert_equal(1, col('.'))
    call assert_equal('add1     (X, Y) ->', getline('.'))
    if !empty(v:errors)
        echo v:errors
    endif
endfunction

function! TestGotoTypeInAnotherModule() abort
    let v:errors = []
    execute 'edit +call\ search("b:my_int0") test/a.erl'
    call ErlangNotIncludeSearch#GotoDefinitionUnderCursor(0)
    call assert_equal('test/b.erl', expand('%'))
    call assert_equal(1, col('.'))
    call assert_equal('-type my_int0() :: integer().', getline('.'))
    if !empty(v:errors)
        echo v:errors
    endif

    let v:errors = []
    execute 'edit +call\ search("b:my_int1") test/a.erl'
    call ErlangNotIncludeSearch#GotoDefinitionUnderCursor(0)
    call assert_equal('test/b.erl', expand('%'))
    call assert_equal(1, col('.'))
    call assert_equal('-  type     my_int1() :: integer().', getline('.'))
    if !empty(v:errors)
        echo v:errors
    endif
endfunction

function! TestGotoOpaqueInAnotherModule() abort
    let v:errors = []
    execute 'edit +call\ search("b:my_float0") test/a.erl'
    call ErlangNotIncludeSearch#GotoDefinitionUnderCursor(0)
    call assert_equal('test/b.erl', expand('%'))
    call assert_equal(1, col('.'))
    call assert_equal('-opaque my_float0() :: float().', getline('.'))
    if !empty(v:errors)
        echo v:errors
    endif

    let v:errors = []
    execute 'edit +call\ search("b:my_float1") test/a.erl'
    call ErlangNotIncludeSearch#GotoDefinitionUnderCursor(0)
    call assert_equal('test/b.erl', expand('%'))
    call assert_equal(1, col('.'))
    call assert_equal('-   opaque      my_float1() :: float().', getline('.'))
    if !empty(v:errors)
        echo v:errors
    endif
endfunction

call TestGotoFunctionInCurrentModule()
call TestGotoFunctionInAnotherModule()
call TestGotoTypeInAnotherModule()
call TestGotoOpaqueInAnotherModule()
echo 'Done running tests'
