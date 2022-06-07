# Once unop a Dijkstar

## Background

We are given a rust binary that is broken.

## Analysis

Upon inspecting the binary, we can see multiple instructions that are nopped out.

The intent of this challenge is the "fix" the original buggy binary. However, we found it easier to reverse the code and reimplement it in python.

Essentially, the binary assigns weight multipliers to edges in the directed graph. We just have to reverse engineer the weights in the graph and run standard dijkstras to get the solution.

The reimplementation is shown in solve.py.

## Final Solution

Run with `python solve.py`

> 63-6, 58-7, 53-8, 24-15
> flag{alpha649436romeo3:GEax4LUzhsj1H3hQcGAgzuReWQc05ZzUC0Rw3oSIErKylPsCizy8SzjMoyOmpekaqRjpQcnid9KpoGw5N9e6KhQ}
