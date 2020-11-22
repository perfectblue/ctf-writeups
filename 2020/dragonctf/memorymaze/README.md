Solution script in dickit.py

Solved as team effort.

TLDR, you can choose a file to write to, but if you choose /proc/self/map_files/xxxxxxxx-yyyyyyyy, if the page is mapped, it will give a permission error and if it doesn't exist it will give a nonexistent file error. This lets you construct an oracle to figure out what pages are mapped (and thus the layout of the maze). This lets you find an efficient path through the maze so you can solve it under their path length constraint.
