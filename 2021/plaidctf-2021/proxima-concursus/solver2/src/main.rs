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
	const KEY_LEN: u32 = 30;
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

fn collide() -> (String, String) {
	let mut mem = Table::new();

	for i in (0..mem.capacity()).rev() {
		let mut d = Digest::new();
		d.append(strip(&gen_moves(true, i)));
		let key = d.digest();
		mem.insert(key);
		if (i+1)&0xff_ffff == 0 {
			eprintln!("inserted {:.2}% keys", i as f64 / mem.capacity() as f64 * 100.0);
		}
	}
	eprintln!("searching...");

	let mem = &mem;
	let (ia, ib) = (0..10000u64)
		.into_par_iter()
		.find_map_any(|gid| {
			let range = gid<<26 .. (gid+1)<<26;
			for ib in range {
				let mut d = Digest::new();
				d.append(strip(&gen_moves(false, ib)));
				let bkey = d.digest();
				if mem.contains(bkey) {
					eprintln!("found candidate {:016x}", ib);
					//let mut closest = (64, 0);
					for ia in 0..mem.capacity() {
						let mut d = Digest::new();
						d.append(strip(&gen_moves(true, ia)));
						let akey = d.digest();

						if bkey == akey {
							eprintln!("found internal collision {:016x} -- {:016x}", ib, ia);
							return Some((ia, ib));
						} else {
							//let diff = ta.1 ^ tb.1;
							//closest = closest.min((diff.count_ones(), ta.1));
						}
					}
					eprintln!("false positive: {:016x}", ib);//; {:016x} closest {} {:016x}", sb, tb.1, closest.0, closest.1);
				}
			}
			eprintln!("range {} done", gid);
			None
		})
		.unwrap();

	let a = gen_moves(true, ia);
	let b = gen_moves(false, ib);
	(
		String::from_utf8(strip(&a).to_vec()).unwrap(),
		String::from_utf8(strip(&b).to_vec()).unwrap(),
	)
}

fn strip<const N: usize>(x: &[u8; N]) -> &[u8] {
	if x[N-1] == 0 {
		&x[..N-1]
	} else {
		&x[..]
	}
}

fn gen_moves(win: bool, mut seed: u64) -> [u8; 28] {
	let mut out = [0u8; 28];
	let mut h = [0; 10];
	let mix = |x: u64| {
		let x = x.wrapping_mul(0x13371337deadbeef);
		x ^ (x>>41)
	};
	seed ^= 0x13371337deadbeef;
	seed = mix(seed);
	seed ^= 0x13371337deadbeef;
	seed = mix(seed);

	let intro_len = if win { 26 } else { 27 };
	for i in 0..intro_len {
		if i%2 == 0 { // O
			let mut good = 0;
			for pos in (0..10).step_by(2) {
				if h[pos] < 3 {
					good += 1;
				}
			}
			let mut sel = seed%good;
			seed = mix(seed);
			let mut x = 8;
			for pos in (0..10).step_by(2) {
				x = pos;
				if h[pos] < 3 {
					if sel == 0 {
						break;
					}
					sel -= 1;
				}
			}
			out[i] = b'0' + x as u8;
			h[x] += 1;
		} else { // X
			let mut good = 0;
			for pos in (0..10).skip(1).step_by(2) {
				if h[pos] < 3 {
					good += 1;
				}
			}
			let mut sel = seed%good;
			seed = mix(seed);
			let mut x = 8;
			for pos in (0..10).skip(1).step_by(2) {
				x = pos;
				if h[pos] < 3 {
					if sel == 0 {
						break;
					}
					sel -= 1;
				}
			}
			out[i] = b'0' + x as u8;
			h[x] += 1;
		}
	}

	let mut end_move = 99;
	if win {
		for pos in (0..10).step_by(2) {
			if h[pos] == 3 {
				end_move = pos;
				break;
			}
		}
	} else {
		for pos in (0..10).skip(1).step_by(2) {
			if h[pos] == 3 {
				end_move = pos;
				break;
			}
		}
	}

	assert!(end_move <= 10, "{:?}", h); // pigeonhole principle
	out[intro_len] = b'0' + end_move as u8;

	out
}

fn main() {
	println!("{:?}", collide());
}
