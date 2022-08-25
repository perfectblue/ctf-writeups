# holdthedoor

I decompiled the given .jar file with jadx, and saved it to `sources/`.
After that, I manually parsed each .java file to get the information.
Notice that we actually have to parse if statements and solve the equations from
them, as there are some **impossible** conditions inside there. (Lines 45-73 in
`solve.py`.)


