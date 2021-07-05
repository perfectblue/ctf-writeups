# pypypypy

1. Load `<class 'object'>` by `LOAD_CONST, 6`.
2. If you see the `__subclasses__` list of `<class 'object'>`, there are `operator.attrgetter` and `warnings.catch_warnings`.
3. `warnings.catch_warnings._module.__builtins__` will give builtins functions.
4. Use `eval` and `input` to solve.
