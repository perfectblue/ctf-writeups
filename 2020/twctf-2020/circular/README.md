All we need to do is solve `X^2 + k*Y^2 = m mod N`, where `k` and `m` are random
numbers chosen by the remote and `N` is a RSA modulus (factorization unknown).

The (supposed) hardness of this problem is the basis of now broken Ong-Schnorr-Shamir signature
scheme. Polland and Schnorr published a polynomial time algorithm for this exact problem
in 1987 [1].

NB: Pollard's article has a couple of typos:

	- equation (2) should be `(x_1^2 + ky_1^2)(x_2^2+ky_2^2) = X^2 + kY^2` instead of `x_1^2 + ky_1^2(x_2^2+ky_2^2) = X^2 + kY^2`.
	- in step 2) you find `m_0 = m/(u^2 + kv^2)` rather than `m_0 = m(u^2 + kv^2)`

Otherwise, the algorithm works as advertised and gets you the flag.


[1] Pollard, John M., Claus P. Schnorr. "An Efficient Solution of the Congruence x²+ky² = m (mod n)." IEEE TRANSACTIONS ON INFORMATION THEORY, VOL. IT-33, NO. 5, SEPTEMBER 1987
