# Vim-erlang-not-include-search

A (neo)vim plugin for going to definitions NOT covered by include- and
definition search. With this plugin you can

- Go to function definitions defined in the current module
- Go to function and type definitions prefixed by a module name

For example, if your cursor is on `my_function()` with no colon before
`my_function`, the current file will be searched. If your cursor is on
`another_module:type_or_function`, then the definition of `type_or_function`
will be searched for inside `another_module`. Make sure that `another_module`
can be found, see below.

## Setup

If you want to go to a definition in another module, you must make sure that
this file can be found. Here are two settings that are usually enough to do
this. Recommended place to put this is in your `after/ftplugin/erlang.vim`.

```vim
setlocal suffixesadd=.erl,.hrl
setlocal path+=path/to/your/code/**
```

No mappings are defined by default. This is what I have in my
`after/ftplugin/erlang.vim`:

```vim
nnoremap <buffer><silent> gd
            \ :<C-U>call ErlangNotIncludeSearch#GotoDefinitionUnderCursor(0)<CR>
nnoremap <buffer><silent> <C-W>gd
            \ :<C-U>call ErlangNotIncludeSearch#GotoDefinitionUnderCursor(1)<CR>
```

`GotoDefinitionUnderCursor` takes one argument, which says whether or not the
definition should be opened in a horizontal split.

## Include-search

Include-search in vim is awesome, and doesn't require much setup. See this
[gist](https://gist.github.com/slarwise/5cceef1c663822b383b59d9392e1890d).

## TODO

Show a preview of the funtion/type definition, just like
[vim-show-full-definition](https://github.com/slarwise/vim-show-full-definition).
