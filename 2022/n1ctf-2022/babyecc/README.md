# babyecc

As the `y` value can be interpreted as 10-degree polynomial of `m`,
we can get a 10-degree polynomial of `m` over mod `N = n_0 * n_1 * ... * n_6`.

I guessed that the flag will be in the same format as other crypto challenges:
`n1ctf{........-....-....-....-............}`.

As it's 43-byte, we have to calculate an epsilon value that holds `2^(8*43) < N^(1/10 - epsilon)`.
In this case, we can use `epsilon = 0.033` to get the flag. The solver is in `solve.sage`.

The flag is `n1ctf{7140f171-5fb5-484d-92f4-9f7ba02c33d0}`.