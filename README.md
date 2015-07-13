VIM plugin: debugsignature
==========================

This is small plugin enhancing my Python function debugging. Often I'd like to
know, what arguments have been passed to a function, so I've been writing
something like:

    def foo(arg1, arg2):
        sys.stderr.write('foo(arg1={}, arg2={})\n'.format(arg1, arg2))
        # function body

This plugin automates adding such signatures. Just place the cursor on the line
with `def` and hit F2 or whatever key you specified in `vimrc`.

Configuration
-------------

`F2` may be replaced for some other key or combination.

    nnoremap <silent> <F2> :call DebugSignature()<CR>
    inoremap <silent> <F2> <C-O>:call DebugSignature()<CR>

Author
------

Wojtek Porczyk `<woju invisiblethingslab com>`
