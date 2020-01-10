WhiteHat 2020 Quals: RE 01
==========================

We are given a 32-bit windows binary, `whitehat.exe`. On reversing the binary, this is what we find:

It opens a file `data` and reads it in 15 chunks of 4096 bytes each. Depending on the 0th byte of each chunk, it swaps around the chunks.
Then, it does some checks on the the data using the 10th byte of each chunk. Then, it hashes the modified data using a custom hash function, SHF,
and compares the hash to a known value. If all these checks pass, it hashes the original data file, and prints it as the flag. It then, stomps over the 10-th byte
and modifies it with some other values, before saving the file to `output.png`.

So, since all but 15-bytes of the original data have been modified, we can use the checks to bruteforce the correct values for these, to get the original data.

From the binary, we can extract the important checks:

```c
  if ( (*data)[10] != 7 || data[13][10] != 12 )
    return 1;
  for ( l = 1; l <= 6; ++l )
  {
    v28 = data[l][10] - 52;
    if ( v28 > 9u )
      return 1;
  }
  for ( m = 7; m <= 11; ++m )
  {
    v28 = data[m][10] - 77;
    if ( v28 > 9u )
      return 1;
  }
  if ( data[12][10] - 34 > 9 )
    return 1;
  v4 = pow((long double)data[1][10], 3.0);
  v5 = pow((long double)data[2][10], 3.0) + v4;
  v28 = (signed int)(pow((long double)data[3][10], 3.0) + v5);
  if ( v28 != 98 )
    return 1;
  v6 = pow((long double)data[4][10], 3.0);
  v7 = pow((long double)data[5][10], 3.0) + v6;
  v8 = pow((long double)data[6][10], 3.0) + v7;
  v28 = (signed int)(pow((long double)data[7][10], 3.0) + v8);
  if ( v28 != 107 )
    return 1;
  v9 = pow((long double)data[9][10], 3.0);
  v10 = pow((long double)data[10][10], 3.0) + v9;
  v11 = pow((long double)data[11][10], 3.0) + v10;
  v28 = (signed int)(pow((long double)data[12][10], 3.0) + v11);
  if ( v28 != 191 )
    return 1;
```

Since the value of the 0-th and 13-th character are fixed, we can write a bruteforce script to find out the possible values for the remaining characters
which satisfy all the checks.

```py
opts1 = []
for i in range(52, 61+1):
    for j in range(52, 61+1):
        for k in range(52, 61+1):
            if((k*k*k + i*i*i + j*j*j) % 256 == 98):
                opts1.append([i, j, k])

opts2 = []
for i in range(52, 61+1):
    for j in range(52, 61+1):
        for k in range(52, 61+1):
            for l in range(77, 86+1):
                if((k*k*k + i*i*i + j*j*j + l*l*l) % 256 == 107):
                    opts2.append([i, j, k, l])

opts3 = []
for i in range(77, 86+1):
    for j in range(77, 86+1):
        for k in range(77, 86+1):
            for l in range(34, 43+1):
                if((k*k*k + i*i*i + j*j*j + l*l*l) % 256 == 191):
                    opts3.append([i, j, k, l])

print len(opts1)
print len(opts2)
print len(opts3)
```

The number of possible options are `3 18 42` along with the 8th character which has `10` possible values, which means we have a total of `22680` combinations which is easily bruteforceable.

We can write a python script that tries all possible values, and checks if the hash is correct according the binary: `solve3.py`.

On running the program, we get the valid array: `[7, 54, 61, 61, 59, 56, 58, 80, 83, 79, 85, 83, 38, 12]`.

Using this array, we can generate the original data value by replacing the value of the 10th byte in each block and reversing the swaps: `get_flag.py`

On running the program with the valid `data` file, we get the flag:

```sh
$ ./whitehat.exe
Press any key to continue . . .

Flag = WhiteHat{8333769562446613979}
```
