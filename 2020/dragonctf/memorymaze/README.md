Solution script in dickit.py

Solved as team effort. TLDR, you can choose a file to write to, but if you choose /proc/self/map_files/xxxxxxxx-yyyyyyyy, if the page is mapped, it will give an io error and if it doesn't exist it will give a missing file error
