" debugsignature.vim -  Add simple logging line to Python function call
" Maintainer:           Wojtek Porczyk <wojciech@porczyk.eu>
" Version:              1.0

" TODO: *args, **kwargs
" TODO: user-defined debug callable instead of hardcoded 'self.log.debug'
" TODO: debug callable passed as argument to allow multiple keymaps

if exists('g:loaded_debugsignature')
    finish
else
    let g:loaded_debugsignature = 1
endif

function! DebugSignature()
python << endpython
import re
import vim

re_def = re.compile(r'^\s*def\s+\w+\(.*$')
re_sig = re.compile(r'^(\s*)def\s+(\w+)\(([\w\s,=*]*)\):\s*(#.*)?$')

def main():
    # in cursor row is 1-based, col is 0-based
    row, col = vim.current.window.cursor
    sig = vim.current.buffer[row - 1] # 0-based
    try:
        shiftwidth = vim.current.buffer.options['shiftwidth'] or 8
    except:
        shiftwidth = 8

    if not re_def.match(sig):
        sys.stderr.write('function signature not found')
        return

    while True:
        m = re_sig.match(sig)
        if m:
            break

        row += 1
        try:
            sig += vim.current.buffer[row - 1]
        except IndexError:
            sys.stderr.write('invalid signature\n')
            return

    indent = m.group(1)
    name = m.group(2)
    args = m.group(3)

    indent += ' ' * shiftwidth
    args = (i.split('=')[0].strip() for i in args.split(','))
    args = [i for i in args if i not in ('self', 'cls')]

    if args:
        vim.current.buffer.append(
            '{indent}self.log.debug(\'{name}({format})\').format({args})'.format(
                indent=indent,
                name=name,
                format=', '.join('{}={{!r}}'.format(arg) for arg in args),
                args=', '.join(args)),
            row)
    else:
        vim.current.buffer.append(
            '{indent}log.debug(\'{name}()\')'.format(indent=indent, name=name),
            row)

    vim.current.window.cursor = (row+1, 0)
    vim.command('{},{}:retab!'.format(row, row))

main()

endpython
endfunction
