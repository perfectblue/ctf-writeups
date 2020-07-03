with open("dumped.so", "rb") as f:
    data = f.read()

print data.index('malloc(): memory corruption')
