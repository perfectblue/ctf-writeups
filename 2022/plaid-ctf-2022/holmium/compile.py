#!/usr/bin/env python
import subprocess

subprocess.run(["./holmium", "c", "main.hvm"])

with open("main.c") as f:
    content = f.read()

content = content.replace("MAX_WORKERS (16)", "MAX_WORKERS (2)")
content = content.replace(r"""    //printf("reduce "); debug_print_lnk(term); printf("\n");
    //printf("------\n");
    //printf("reducing: host=%d size=%llu init=%llu ", host, stack.size, init); debug_print_lnk(term); printf("\n");
    //for (u64 i = 0; i < 256; ++i) {
      //printf("- %llx ", i); debug_print_lnk(mem->node[i]); printf("\n");
    //}""", r"""    printf("reduce "); debug_print_lnk(term); printf("\n");
    printf("------\n");
    printf("reducing: host=%d size=%lu init=%lu (%lx)\n", host, stack.size, init, mem->node);
    for (u64 i = 0; i < 64; ++i) {
      printf("- %lx ", i); debug_print_lnk(mem->node[i]); printf("\n");
    }""")

with open("main.c", "w") as f:
    f.write(content)

subprocess.run(["gcc", "-no-pie", "-g", "-pthread", "-o", "main", "main.c"])
