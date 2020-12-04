struct Mat {
	row: [u128; 128],
}

impl Mat {
	fn show(&self, t: &str) {
		eprintln!("--");
		for i in 0..128 {
			eprintln!("{} {:0128b}", t, self.row[i]);
		}
	}

	fn zero() -> Self {
		Mat {
			row: [0; 128],
		}
	}

	fn mul(&self, col: u128) -> u128 {
		let mut out = 0;
		for i in 0..128 {
			if col>>i&1 != 0 {
				for j in 0..128 {
					out ^= (self.row[j]>>i&1)<<j;
				}
			}
		}
		out
	}
}

impl Default for Mat {
	fn default() -> Self {
		let mut xs = Mat {
			row: [0; 128],
		};
		for i in 0..128 {
			xs.row[i] = 1<<i;
		}
		xs
	}
}

struct Solver {
	matrix: Mat,
	lhs: [u8; 128],
	rank: usize,
}

impl Solver {
	fn new() -> Self {
		Solver {
			matrix: Mat::zero(),
			lhs: [0; 128],
			rank: 0
		}
	}

	fn add_row(&mut self, mut row: u128, mut l: u8) -> bool {
		for i in 0..128 {
			if row>>i&1 != 0 {
				row ^= self.matrix.row[i];
				l ^= self.lhs[i];
			}
		}
		if row == 0 {
			if l != 0 {
				return false;
			}
			return true;
		}
		assert_ne!(self.rank, 128);
		let k = (127 - row.leading_zeros()) as usize;
		assert_eq!(self.matrix.row[k], 0);

		for i in 0..128 {
			if self.matrix.row[i]>>k&1 != 0 {
				self.matrix.row[i] ^= row;
				self.lhs[i] ^= l;
			}
		}

		self.matrix.row[k] = row;
		self.lhs[k] = l;
		self.rank += 1;

		true
	}

	fn a_solution(&self) -> u128 {
		let mut sol = 0;

		for i in 0..128 {
			sol |= (self.lhs[i] as u128) << i;
		}

		sol
	}

	fn nullspace(&self) -> Vec<u128> {
		let mut space = Vec::with_capacity(128-self.rank);

		for i in 0..128 {
			if self.matrix.row[i] == 0 {
				let mut col = 1<<i;
				for j in 0..128 {
					if self.matrix.row[j]&col != 0 {
						col ^= 1<<j;
					}
				}

				assert_eq!(self.matrix.mul(col), 0);
				space.push(col);
			}
		}
		assert_eq!(space.len(), 128-self.rank);

		space
	}
}

#[derive(Default)]
struct SymXS128 {
	state: Mat, // state0 is in 0..64, state1 in 64..128
}

impl SymXS128 {
	fn update(&mut self) {
		// s0 ^= s0<<23
		for i in (23..64).rev() {
			self.state.row[i] ^= self.state.row[i-23];
		}
		// s0 ^= s0>>17
		for i in 0..64-17 {
			self.state.row[i] ^= self.state.row[i+17];
		}
		// s0 ^= s1
		for i in 0..64 {
			self.state.row[i] ^= self.state.row[i+64];
		}
		// s0 ^= s1 >> 26
		for i in 0..64-26 {
			self.state.row[i] ^= self.state.row[i+64+26];
		}

		// swap halves
		for i in 0..64 {
			self.state.row.swap(i, i+64);
		}
	}
}

struct XS128 {
	s0: u64,
	s1: u64,
}

impl XS128 {
	fn new(s0: u64, s1: u64) -> Self {
		XS128 { s0, s1 }
	}

	fn update(&mut self) {
		let s0 = self.s1;
		let mut s1 = self.s0;
		self.s0 = s0;
		s1 ^= s1.wrapping_shl(23);
		s1 ^= s1.wrapping_shr(17);
		s1 ^= s0;
		s1 ^= s0.wrapping_shr(26);
		self.s1 = s1;
	}

	fn next(&mut self) -> u64 {
		self.update();
		self.s0
	}

	fn next_f64(&mut self) -> f64 {
		let bits = (self.next()>>12) | 0x3ff0000000000000;
		unsafe { std::mem::transmute::<u64, f64>(bits) - 1.0f64 }
	}
}

#[derive(Default, Clone, Copy)]
struct Con {
	value: u64,
	mask: u64,
}

fn main() {
	use std::io::BufRead;

	let input = std::io::stdin();
	let input = input.lock();
	let input = std::io::BufReader::new(input);
	let mut lines = input.lines();

	let mut constraints = vec![Con::default(); 300];
	let mut pin_constraints = vec![None; 300];
	while let Some(line) = lines.next() {
		let line = line.unwrap();
		if line == "end" {
			break;
		}
		let mut tokens = line.split(' ');
		let kind = tokens.next().unwrap();
		match kind {
			"bits" => {
				let pos: usize = tokens.next().unwrap().parse().unwrap();
				let value: u64 = tokens.next().unwrap().parse().unwrap();
				let mask: u64 = tokens.next().unwrap().parse().unwrap();
				assert!(pos <= constraints.len());
				constraints[pos].value |= value;
				constraints[pos].mask |= mask;
			},
			"pin" => {
				let pos: usize = tokens.next().unwrap().parse().unwrap();
				let value: u32 = tokens.next().unwrap().parse().unwrap();
				pin_constraints[pos] = Some(value);
			}
			_ => panic!("invalid kind"),
		}
	}

	let mut solver = Solver::new();

	let mut xs = SymXS128::default();
	//xs.state.show("init");

	for pos in 0..constraints.len() {
		xs.update();
		let con = &constraints[pos];
		for bit in 0..64 {
			if con.mask>>bit & 1 != 0 {
				let lhs = (con.value>>bit&1) as u8;
				if ! solver.add_row(xs.state.row[bit], lhs) {
					println!("end");
					return;
				}
			}
		}
	}

	eprintln!("rank = {}", solver.rank);
	//solver.matrix.show("m");

	let state = solver.a_solution();
	let nullspace = solver.nullspace();
	for guess in 0..1<<nullspace.len() {
		let mut sol = state;
		for (i, basis) in nullspace.iter().enumerate() {
			if guess>>i&1 != 0 {
				sol ^= basis;
			}
		}
		//eprintln!("state = {:032x}", sol);
		let s0 = (sol&0xffffffffffffffff) as u64;
		let s1 = (sol>>64) as u64;
		let mut xs = XS128::new(s0, s1);
		for pos in 0..constraints.len() {
			let con = &constraints[pos];
			let out = xs.next();
			assert_eq!(0, (out^con.value)&con.mask);
		}

		let mut xs = XS128::new(s0, s1);
		let mut ok = true;
		for pos in 0..pin_constraints.len() {
			let pin = (xs.next_f64()*5040.0) as u32;
			if let Some(expected_pin) = pin_constraints[pos] {
				if expected_pin != pin {
					ok = false;
					break;
				}
			}
		}

		if ok {
			println!("init {} {}", s0, s1);
		}
	}
	println!("end");
}
