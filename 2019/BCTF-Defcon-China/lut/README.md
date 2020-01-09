# BCTF Defcon China 2019 - Lut

This challenge was a flag checker, where our flag was of the format flag{AAAAAAAABBBBBBBB} where A and B are printable characters. The program calls an encryption function with a QWORD input, AAAAAAAA and BBBBBBBB. It then compare the results of the encryption function to two hardcoded QWORDS. Our job is to generate an input that will satisfy the hardcoded QWORD checks.

The encryption function consisted of countless (roughly 130,000 lines of assembly) QWORD XORs based on byte comparisons on the input.

To solve this challenge, we have to recognize that each byte influences the final result of the function linearly and independently since the only operations the encrypt uses is byte comparisons, and XORs, and the input does not get changed throughout the function based on other byte's values. As a result, we can brute force each 8 bytes of the input, and extract the XOR contribution that byte has on the final result. This results in 8 sets of 256 QWORDs.

Now the problem reduces to: given 8 sets of 256 QWORDs, find a combination using one QWORD from each set, whose values XORed together equals some desired value, where the desired value will be the hardcoded checks from the binary. I'm sure there is a linear algebra method to solve this problem, but that was not required to solve this problem, but was instead necessary for the next challenge in the CTF, Lut-Revenge.

To solve this chalelnge, we can perform a meet in the middle attack. We can take all XOR combinations of the first 4 sets and the last 4 sets, resulting in two sets of values. Then, we can iterate through one of the sets, and check if the XOR combination ^ desired_value exists in the other set. This way, we only have to brute force a 32 bit space, rather than a 64 bit space.

However, when implementing this, I ran into memory errors. To solve this, I simply limited the possible space to printable characters, which is only around 90 values as opposed to 256, thus improving upon speed and memory usage greatly.

## Flag
#### flag{[V]ee7_1N_M!ddL3}
