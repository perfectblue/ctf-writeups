Random elements of Rubik's Cube group tend to have small order (a few thousand), so we can
compule the discrete logarithm with brute force.


	function dlog(g, h) {
		var it = new Cube();
		var l = 0n;
		while (! eq(it, h)) {
			l += 1n;
			it = it.multiply(g);
		}
		return l;
	}
