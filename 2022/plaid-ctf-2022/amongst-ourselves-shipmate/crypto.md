# Amongst Ourselves: Shipmate - Process Sample (Crypto)

There's a simple matrix multiplication in `ProcessSampleSystem.ts`.

I got a plaintext-ciphertext pair `"LMBDDPLPTMZQPQD?VQWF!YHV_"` and `"E_KGZZOSNYCKEGSC_D?RMVTRM"`.

It is solvable like this:

```py
#!/usr/bin/env sage

alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ_!?"
p = len(alphabet)
pt = "LMBDDPLPTMZQPQD?VQWF!YHV_"
ct = "E_KGZZOSNYCKEGSC_D?RMVTRM"

pt = [[ alphabet.index(pt[i * 5 + j]) for j in range(5) ] for i in range(5)]
ct = [[ alphabet.index(ct[i * 5 + j]) for j in range(5) ] for i in range(5)]

F = GF(p)

A = Matrix(F, pt)
B = Matrix(F, ct)

res = A.inverse() * B

ans = ''.join(alphabet[res[i][j]] for j in range(5) for i in range(5))
print(ans)
```

The flag is `PCTF{TEST_POSITIVE!_FR_GRAVEL?}`.