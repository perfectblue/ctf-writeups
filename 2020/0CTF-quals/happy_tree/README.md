## Happy Tree

This was a pretty cool challenge involving executing this large in-memory AST
tree. The basic premise goes, we create a ton of structs like the below:

```c
struct node
{
  int arg1;
  int arg2;
  void (*executor)(struct node *, int);
  int jobs;
  struct node **child;
};
```

And then starting from the top, we run the "executor" passing the node itself.
The executor function will then traverse its children nodes, and do something
with them, most likely dereferencing those children and then in turn executing
them. You also have two arguments (arg1, arg2) used to specify how this executor
should run. 

Here what I did, was I first executed the program, and after it constructed all
the trees, I just dumped the entire memory (in no ASLR) and then just worked
with that. The resulting tree I got was just beautiful (see the [tree](./tree)
file). Now I wrote this parser code that dumps the tree, AND also decompiles the
AST back into a C-like language (see [code.c](./code.c)). 

In the end, the code is just doing some bitshift-xor operation (`a ^ (a >> s)`)
and I just wrote a solver to reverse that (z3 would be too slow, so I wrote a
manual solver). The concept is pretty cool, but in the end after dumping the
tree (note that I had to simply the ast tree), it seemed way too repetitive and
trivial once I reversed it. Still, nevertheless it was a cool challenge.

