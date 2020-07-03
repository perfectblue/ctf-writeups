The challenge calculated `ctext = [65537]flag` over a hyperelliptic curve.
To recover the flag we need to multiply by the inverse of 65537 modulo the group's order.

The order can be calculated using Magma:

	K := FiniteField(2^256);
	P := PolynomialRing(K);
	w := P.1;
	f := w^5 + w^3 + 1;
	h := w^2 + w;
	H := HyperellipticCurve(f, h);
	print #Jacobian(H);

Now we decrypt the flag (in Sagemath):

	order = 13407807929942597099574024998205846127384782207827457971403006387925941306569427075743805985793764139096494648696821820448189053384542053304334065342873600
	e = 65537
	d = int(pow(e, -1, order))
	flag = mul(ctext, d)
	print(decode(flag))

