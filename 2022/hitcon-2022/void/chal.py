#!/usr/local/bin/python3

source = input('>>> ')
if len(source) > 13337: exit(print(f"{'L':O<13337}NG"))
code = compile(source, '∅', 'eval').replace(co_consts=(), co_names=())
print(ascii(eval(code, {'__builtins__': {}})))
print('ok')
