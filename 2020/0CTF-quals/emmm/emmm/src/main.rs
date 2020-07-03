use rand::{Rng, SeedableRng};
use rand_pcg::Pcg64Mcg;
use std::collections::HashMap;

#[cfg(not(feature = "lite"))]
mod params {
	pub const P: u64 = 247359019496198933;
	pub const C: u64 = 223805275076627807;
	pub const INV_C: u64 = 1131579515458719391;
	pub const MASK: u64 = (1<<60)-1;
}

#[cfg(feature = "lite")]
mod params {
	pub const P: u64 = 993597193;
	pub const C: u64 = 223805275;
	pub const INV_C: u64 = 771823827;
	pub const MASK: u64 = (1<<30)-1;
}

fn add(x: u64, k: u64) -> u64 {
	let r = ((x as u128 * k as u128)%(params::P as u128)) as u64;
	//eprintln!("add {} {} -> {}", x, k, r);
	r
}

fn neg(x: u64) -> u64 {
	let mut a = x as i64;
	let mut b = params::P as i64;
	let mut aa = 1i64;
	let mut ab = 0i64;
	let mut ba = 0i64;
	let mut bb = 1i64;

	while a != 0 {
		let q = b/a;
		let r = b%a;
		b = r;
		ba -= q*aa;
		bb -= q*ab;
		std::mem::swap(&mut a, &mut b);
		std::mem::swap(&mut aa, &mut ba);
		std::mem::swap(&mut ab, &mut bb);
	}

	let mut n = aa+ba;

	if n < 0 {
		n += params::P as i64;
	}
	debug_assert!(n >= 0);
	let n = n as u64;
	debug_assert!(n < params::P);
	debug_assert!(x*n%params::P == 1);

	n
}

fn sub(x: u64, y: u64) -> u64 { add(x, neg(y)) }

fn sbox(x: u64) -> u64 {
	let r = (x.wrapping_mul(params::C)&params::MASK)%params::P;
	//eprintln!("sbox {} -> {}", x, r);
	r
}

fn inv_sbox(x: u64) -> u64 { // not 100% correct
	(x.wrapping_mul(params::INV_C)&params::MASK)%params::P
}

fn encrypt(x: u64, k1: u64, k2: u64) -> u64 {
	let y = add(sbox(add(x, k1)), k2);
	y
}

fn decrypt(x: u64, k1: u64, k2: u64) -> u64 {
	sub(inv_sbox(sub(x, k2)), k2)
}

struct BypassHasher(u64);

impl Default for BypassHasher {
	fn default() -> Self { BypassHasher(0) }
}

impl core::hash::Hasher for BypassHasher {
	fn finish(&self) -> u64 { self.0 }
	fn write(&mut self, _: &[u8]) { unreachable!() }
	fn write_u64(&mut self, x: u64) { self.0 = x; }
}

fn main() {
	let mut args = std::env::args();
	args.next().unwrap();
	let res_file = args.next().unwrap();
	let nthreads: u32 = args.next().unwrap().parse().unwrap();

	if cfg!(feature = "lite") {
		eprintln!("Using lite cipher");
	}

	eprintln!("reading known plaintexts...");
	let kp: Vec<(u64, u64)> = {
		use std::io::*;
		let f = std::fs::OpenOptions::new()
			.read(true)
			.open(res_file)
			.expect("cannot open res");
		BufReader::new(f)
			.lines()
			.map(|line| {
				let line = line.expect("line");
				let mut ts = line.split_ascii_whitespace();
				let p = ts.next().unwrap().parse().unwrap();
				let c = ts.next().unwrap().parse().unwrap();
				(p, c)
			})
			.collect()
	};
	eprintln!("reading known plaintexts... {} pairs", kp.len());
	let d = (1<<(58/2 + 1))/kp.len();
	let d = 2*d;
	eprintln!("D factor = {}", d);

	let check_key = |k1, k2| {
		for &(a, ea) in kp.iter() {
			if encrypt(a, k1, k2) != ea {
				return false;
			}
		}
		true
	};

	if cfg!(feature = "lite") {
		assert!(check_key(502685070, 831560500));
	}

	{
		let mut rng = Pcg64Mcg::from_rng(rand::thread_rng())
			.expect("could not initialize rng");
		let a = rng.gen::<u64>() % params::P;
		let b = rng.gen::<u64>() % params::P;
		assert_eq!(sub(add(b, a), a), b);
		assert_eq!(sub(add(b, a), b), a);
	}

	let tried_diffs = std::sync::atomic::AtomicUsize::new(0);

	rayon::scope(|sc| {
		for _ in 0..nthreads {
			sc.spawn(|_| {
				let mut rng = Pcg64Mcg::from_rng(rand::thread_rng())
					.expect("could not initialize rng");
				let mut mem = HashMap::<u64, u32>::with_capacity(kp.len());

				loop {
					let diff = rng.gen::<u32>() as u64 % params::P;
					//eprintln!("trying diff {}", diff);
					mem.clear();

					for (ia, &(a, ea)) in kp.iter().enumerate() {
						let fda = sbox(sub(diff, a));
						let key = add(ea, fda);
						if let Some(ib) = mem.insert(key, ia as u32) {
							let (b, eb) = kp[ib as usize];
							let k1 = sub(diff, add(a, b));
							let k2 = sub(eb, fda);

							println!("collision between {} and {}; diff = {}", ia, ib, diff);
							println!("potential key: {} {}", k1, k2);
							if check_key(k1, k2) {
								println!("!!! RECOVERED KEY: {} {}", k1, k2);
								std::process::exit(0);
							}
						}
					}
					let id = tried_diffs.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
					eprintln!("progress: {} diffs; {:.1}%",
						id+1,
						(id+1) as f64 / d as f64 * 50.
					);
				}
			});
		}
	});
}

#[cfg(test)]
mod tests {
	use super::*;

	#[cfg(not(feature = "lite"))]
	#[test]
	fn test() {
		include!("../../tests");
	}

	#[cfg(feature = "lite")]
	#[test]
	fn test() {
		include!("../../tests.lite");
	}
}
