checkedAgainstInt = ['']*13
checkedAgainstInt[0] = 'f';
checkedAgainstInt[1] = 'h';
checkedAgainstInt[2] = 'n';
checkedAgainstInt[3] = 'j';
checkedAgainstInt[4] = 'u';
checkedAgainstInt[5] = 'c';
checkedAgainstInt[6] = 'v';
checkedAgainstInt[7] = 'b';
checkedAgainstInt[8] = 'n';
checkedAgainstInt[9] = 'j';
checkedAgainstInt[10] = 'u';
checkedAgainstInt[11] = 't';
checkedAgainstInt[12] = 'r';
checkedAgainstInt=''.join(checkedAgainstInt)
gggg=''
for i in range(len(checkedAgainstInt)):
  gggg+= chr(ord(checkedAgainstInt[i])+1)
print gggg