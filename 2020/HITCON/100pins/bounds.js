const N = 5040;

function bits_to_double(hi, lo) {
	const buf = new ArrayBuffer(8);
	const v = new DataView(buf);
	v.setUint32(0, lo, true);
	v.setUint32(4, hi, true);
	return v.getFloat64(0, true);
}

function rng_to_double(hi, lo) {
	hi |= 0x3FF00000;
	return bits_to_double(hi, lo) - 1;
}

function to_pin(f) {
	const i = Math.floor(f*N);
	//console.log(f, "=>", i);
	return i;
}

function high_bound(val) {
	var hi = 0;
	var lo = 0;
	for (var bit = 51; bit >= 0; bit -= 1) {
		var hi_ = hi;
		var lo_ = lo;
		if (bit >= 32) {
			hi_ |= 1<<(bit-32);
		} else {
			lo_ |= 1<<bit;
		}
		if (to_pin(rng_to_double(hi_, lo_)) <= val) {
			//console.log('bit', bit, 'taken');
			hi = hi_;
			lo = lo_;
		} else {
			//console.log('bit', bit, 'not taken');
		}
	}

	return [hi, lo];
}

for (var val = 0; val < N; val += 1) {
	const [ hi, lo ] = high_bound(val);
	console.log(val, hi, lo);
}
