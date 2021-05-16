#![feature(new_uninit)]

mod digester;
use std::mem::MaybeUninit;
use rayon::prelude::*;

use digester::Digest;

#[derive(Clone, Copy)]
struct Entry(u32);

impl Entry {
	const fn empty() -> Self { Entry(0) }
	const fn is_empty(self) -> bool { self.0 == 0 }
}

struct Table {
	mem: Box<[Entry]>
}

impl Table {
	const KEY_LEN: u32 = 32;
	const KEY_MASK: u64 = (1<<Self::KEY_LEN)-1;

	fn new() -> Self {
		let mem: Box<[MaybeUninit<Entry>]> = Box::new_zeroed_slice(1<<Self::KEY_LEN);
		let mem = Box::into_raw(mem) as *mut [Entry];
		Table {
			mem: unsafe { Box::from_raw(mem) }
		}
	}

	fn insert(&mut self, x: u64) {
		let mut key = ((x>>32) & Self::KEY_MASK) as usize;
		let val = (x & 0xffff_ffff) as u32;
		unsafe {
			/*
			while ! self.mem.get_unchecked(key).is_empty() {
				key = (key+1) & (Self::KEY_MASK as usize);
				if self.mem.get_unchecked(key).0 == val {
					return; // self-collision
				}
			}
			*self.mem.get_unchecked_mut(key) = Entry(val);
			*/
			*self.mem.get_unchecked_mut(key) = Entry(val);
		}
	}

	fn contains(&self, x: u64) -> bool {
		let mut key = ((x>>32) & Self::KEY_MASK) as usize;
		let val = (x & 0xffff_ffff) as u32;
		unsafe {
			self.mem.get_unchecked(key).0 == val
			/*
			loop {
				let e = *self.mem.get_unchecked(key);
				if e.is_empty() {
					break false;
				}
				if e.0 == val {
					break true;
				}
				key = (key+1) & (Self::KEY_MASK as usize);
			}*/
		}
	}

	fn capacity(&self) -> u64 {
		Self::KEY_MASK
	}
}

fn salt(i: u64) -> u64 {
	((i+2) as u64).wrapping_mul(0x13371337deadbeef)
}

fn collide(a: &[u8], b: &[u8]) -> (Vec<u8>, Vec<u8>) {
	let common_len = {
		let n = a.len().max(b.len());
		(n+7)/8*8
	};
	eprintln!("padding to {}", common_len);

	let mut full_a = a.to_vec();
	while full_a.len() < common_len {
		full_a.push(b'_');
	}

	let mut full_b = b.to_vec();
	while full_b.len() < common_len {
		full_b.push(b'_');
	}

	let mut d = digester::Digest::new();
	d.append(full_a.as_slice());
	assert_eq!(d.uncompressed_len, 0);
	let ihv_a = d.state;

	eprintln!("IHV A: {:016x} {:016x}", ihv_a.0, ihv_a.1);

	let mut d = digester::Digest::new();
	d.append(full_b.as_slice());
	assert_eq!(d.uncompressed_len, 0);
	let ihv_b = d.state;

	eprintln!("IHV B: {:016x} {:016x}", ihv_b.0, ihv_b.1);

	let mut mem = Table::new();


	for i in (0..mem.capacity()).rev() {
		let mut t = ihv_a;
		t.0 ^= salt(i);
		t = Digest::sponge(t);
		mem.insert(t.1);
		if (i+1)&0x3ff_ffff == 0 {
			eprintln!("inserted {:.2}% keys", i as f64 / mem.capacity() as f64 * 100.0);
		}
	}
	eprintln!("searching...");

	let mem = &mem;
	let (la, lb, sa, sb) = (0..10000u64)
		.into_par_iter()
		.find_map_any(|gid| {
			let range = gid<<26 .. (gid+1)<<26;
			for ib in range {
				let mut tb = ihv_b;
				let sb = salt(ib);
				tb.0 ^= sb;
				tb = Digest::sponge(tb);
				if mem.contains(tb.1) {
					eprintln!("found candidate {:016x}", sb);
					//let mut closest = (64, 0);
					for ia in 0..mem.capacity() {
						let mut ta = ihv_a;
						let sa = salt(ia);
						ta.0 ^= sa;
						ta = Digest::sponge(ta);
						if ta.1 == tb.1 {
							eprintln!("found internal collision {:016x} -- {:016x}", sa, sb);
							return Some((ta.0, tb.0, sa, sb));
						} else {
							//let diff = ta.1 ^ tb.1;
							//closest = closest.min((diff.count_ones(), ta.1));
						}
					}
					eprintln!("false positive: {:016x}", sb);//; {:016x} closest {} {:016x}", sb, tb.1, closest.0, closest.1);
				}
			}
			eprintln!("range {} done", gid);
			None
		})
		.unwrap();
	full_a.extend_from_slice(&sa.to_le_bytes()[..]);
	full_b.extend_from_slice(&sb.to_le_bytes()[..]);
	full_a.extend_from_slice(&la.to_le_bytes()[..]);
	full_b.extend_from_slice(&lb.to_le_bytes()[..]);

	(full_a, full_b)
}

fn main() {
	let a = Digest::hex_digest_of(b"yyy_____\x8c\x5b\xa7\x79\x1d\x43\x7f\xbe\x8d\x6c\x24\x3a\xe4\x21\xe2\xe8");
	let b = Digest::hex_digest_of(b"zzzz____\x23\xe9\x90\x32\xbf\x76\x9c\x65\x00\x00\x00\x00\x00\x00\x00\x00");
	assert_eq!(a, b);

	let a = &[105, 110, 102, 108, 97, 116, 111, 110, 158, 135, 128, 34, 226, 218, 178, 175, 129, 119, 70, 69, 171, 84, 127, 63];
	let b = &[116, 97, 117, 95, 95, 95, 95, 95, 148, 11, 65, 38, 185, 9, 10, 46, 99, 118, 156, 183, 42, 126, 46, 110];

	assert_eq!(
		Digest::hex_digest_of(a),
		Digest::hex_digest_of(b),
	);

	let c = &[90, 98, 111, 115, 111, 110, 95, 95, 40, 171, 21, 142, 44, 229, 99, 229, 211, 220, 90, 231, 93, 140, 75, 72];
	let d = &[87, 98, 111, 115, 111, 110, 95, 95, 127, 223, 202, 207, 55, 209, 38, 94, 33, 119, 60, 48, 13, 19, 60, 129];

	assert_eq!(
		Digest::hex_digest_of(c),
		Digest::hex_digest_of(d),
	);

	let x = &[105, 110, 102, 108, 97, 116, 111, 110, 158, 135, 128, 34, 226, 218, 178, 175, 129, 119, 70, 69, 171, 84, 127, 63, 16, 49, 86, 99, 175, 168, 209, 146, 42, 94, 143, 160, 216, 254, 15, 213];
	let y = &[90, 98, 111, 115, 111, 110, 95, 95, 40, 171, 21, 142, 44, 229, 99, 229, 211, 220, 90, 231, 93, 140, 75, 72, 179, 103, 16, 170, 204, 42, 193, 142, 141, 182, 181, 176, 113, 165, 51, 228];

	assert_eq!(
		Digest::hex_digest_of(x),
		Digest::hex_digest_of(y),
	);

	assert_eq!(x.len(), a.len()+16);

	let mut sol = &[
		x.to_vec(), b.into_iter().chain(x[a.len()..].into_iter()).cloned().collect(),
		y.to_vec(), d.into_iter().chain(y[c.len()..].into_iter()).cloned().collect(),
	];

	let d =  Digest::hex_digest_of(x);
	for s in sol {
		assert_eq!(d, Digest::hex_digest_of(s));
		println!("{}", hex::encode(&s));
	}

	return;


	let (a, b) = collide(b"inflaton", b"tau_____");
	println!("a = {:?} b = {:?}", a, b);
	let (c, d) = collide(b"Zboson__", b"Wboson__");
	println!("c = {:?} d = {:?}", c, d);
	let (x, y) = collide(&a[..], &c[..]);
	println!("x = {:?} y = {:?}", x, y);
}
