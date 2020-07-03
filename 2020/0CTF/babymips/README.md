## Babymips

This was a REV using a very new arch (nanoMIPS) that had basically 0 support in
the standard multiarch toolchain, IDA, and ghidra. So I ended up first
downloading [the toolchain][1] and [instruction manual][2] from the official 
MIPS website. (The way I found the toolchain was actually by running strings on
the binary and finding the keyword "Codescape" in the toolchain name and then
searching that on the MIPS website :P). 

Then I sat down to do some manual reversing; thankfully, the code was relatively
straightforward to read. The code was basically a sudoku checker, but instead of
numbers, it utilizes the keys: "qweasdzxc" as if they represented the number
pad. Then the sudoku solver checked for uniqueness in rows, columns, and a
permuated rows one (basically, the code checker permuated every cell onto a
different position and checked rows of this permuated grid). The flag is
basically all the individual cells that you had to fill to complete the sudoku
problem.

Here I modified the [solution from Rosetta Code][3], cause who wants to rewrite
a sudoku solver from scratch?

[1]: https://codescape.mips.com/components/toolchain/nanomips/latest/index.html
[2]: https://s3-eu-west-1.amazonaws.com/downloads-mips/I7200/I7200+product+launch/MIPS_nanomips32_ISA_TRM_01_01_MD01247.pdf
[3]: http://rosettacode.org/wiki/Sudoku#Python
