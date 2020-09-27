use std::io::{BufRead, BufReader, Read, Lines, Result};
use std::fs::OpenOptions;
use rayon::prelude::*;

const ERRORS: [usize; 64] = [
	6, 8, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 8, 6, 6, 8,
	6, 6, 6, 8, 6, 6, 6, 6, 8, 6, 8, 6, 8, 6, 6, 6, 6,
	6, 8, 6, 8, 6, 6, 6, 8, 6, 8, 6, 6, 6, 8, 6, 8, 6,
	6, 8, 6, 6, 8, 6, 6, 8, 6, 6, 8, 6, 6
];

const DEGREE: usize = 4096;

struct Jump {
	gap: u128,
	coeffs: Vec<u8>,
}

impl Jump {
	fn from_reader(r: impl Read) -> Result<Self> {
		let mut line = String::new();
		let mut r = BufReader::new(r);

		r.read_line(&mut line)?; // read {} bits
		line.clear();

		r.read_line(&mut line)?; // linear complexity: {}/{}
		line.clear();

		r.read_line(&mut line)?; // char
		let mut j = Jump { 
			gap: 1,
			coeffs: vec![],
		};
		{
			let mut it = line.split_whitespace();
			assert_eq!(Some("char:"), it.next());
			assert_eq!(Some("1"), it.next());
			while let Some(s) = it.next() {
				j.coeffs.push(s.parse().unwrap());
			}
		}
		line.clear();

		Ok(j)
	}

	fn append(&self, left: &Jump, jump1: &Jump) -> Jump {
		let mut buf = vec![0; self.coeffs.len()+left.coeffs.len()-1];

		//eprintln!("=== APPENDING {} and {}", self.gap, left.gap);

		for i in 0..self.coeffs.len() {
			for j in 0..left.coeffs.len() {
				buf[i+j] ^= self.coeffs[i] & left.coeffs[j];
			}
		}
		if false {
			eprint!("buf: ");
			for x in buf.iter() {
				eprint!("{}", x);
			}
			eprintln!("");
		}
		// buf is self.gap+left.gap..self.gap+self.gap+2*L-1

		assert_eq!(1, jump1.gap);
		let last = 'l: loop {
			for i in (0..jump1.coeffs.len()).rev() {
				if jump1.coeffs[i] != 0 {
					break 'l i;
				}
			}
			unreachable!()
		};

		// reduce buf to self.gap+left.gap .. self.gap+left.gap+L
		for i in (jump1.coeffs.len()..buf.len()).rev() {
			if buf[i] != 0 {
				let ofs = i-last;
				buf[ofs-1] ^= 1; // implicit 1
				for j in 0..jump1.coeffs.len() {
					buf[ofs+j] ^= jump1.coeffs[j];
				}
			}
			assert_eq!(0, buf[i]);
		}

		if false {
			eprint!("reduced: ");
			for x in buf.iter() {
				eprint!("{}", x);
			}
			eprintln!("");
		}

		Jump {
			gap: self.gap + left.gap,
			coeffs: buf[..jump1.coeffs.len()].to_vec(),
		}
	}

	fn unity() -> Self {
		Jump {
			gap: 0,
			coeffs: vec![1],
		}
	}
}

struct Jumps {
	seed: Vec<u8>,
	jumps: Vec<Jump>, // jumps[i].gap == 1<<i
	error: usize,
}

impl Jumps {
	fn new(i: usize, mut seed: Vec<u8>, jump1: Jump) -> Self {
		let mut wanted = 0;
		for i in 0..64 {
			wanted = (wanted<<1) + (seed[seed.len()-64+i] as u64);
		}
		seed.truncate(seed.len()-64);
		let wanted = wanted;

		let mut s = Jumps {
			seed,
			jumps: vec![],
			error: 0,
		};
		s.jumps.push(jump1);
		for i in 1..128 {
			s.jumps.push(s.jumps[i-1].append(&s.jumps[i-1], &s.jumps[0]));
		}
		/*
		let mut window = 0;
		for i in 0..64 {
			window = (window<<1) + s.get_bit_at(s.seed.len()+i) as u64;
		}

		let mut error = 0;
		while window != wanted {
			window = (window<<1) + s.get_bit_at(s.seed.len()+64+error) as u64;
			error += 1;
		}
		*/

		s.error = ERRORS[i];

		s
	}

	fn get_jump(&self, gap: u128) -> Jump {
		let mut jmp = Jump::unity();
		for i in 0..128 {
			if gap>>i&1 == 1 {
				jmp = jmp.append(&self.jumps[i], &self.jumps[0]);
			}
		}
		assert_eq!(gap, jmp.gap);
		jmp
	}

	fn get_bit_at(&self, pos: u128) -> u8 {
		if pos < self.seed.len() as u128 {
			self.seed[pos as usize]
		} else {
			let pos = pos + self.error as u128;
			let gap = pos-(self.seed.len() as u128)-1;
			let jmp = self.get_jump(gap);

			let mut x = 0;
			for i in 0..jmp.coeffs.len() {
				x ^= self.seed[jmp.coeffs.len()-1-i] & jmp.coeffs[i];
			}
			x
		}
	}
}

fn load_seq(i: usize) -> Vec<u8> {
	let path = format!("{}.seq", i);
	let mut r = BufReader::new(OpenOptions::new().read(true).open(path).unwrap());
	let mut buf = String::new();
	let mut seq = vec![];
	r.read_to_string(&mut buf).unwrap();
	for tok in buf.split_whitespace() {
		seq.push(tok.parse().unwrap());
	}
	seq
}

fn load_lr(i: usize) -> Jumps {
	let mut seq = load_seq(i);
	seq.truncate(4100+64);
	eprintln!("loading {}", i);

	let path = format!("{}.lr", i);
	let jump1 = Jump::from_reader(OpenOptions::new().read(true).open(path).unwrap()).unwrap();
	let j = Jumps::new(i, seq, jump1);
	//println!("error {} {}", i, j.error); // no fucking clue why
	j
}

fn main() {
	let lr: Vec<Jumps> = (0..64usize).into_par_iter()
		.map(|bit| load_lr(bit))
		.collect();
	println!("ready");

	let mut req = String::new();
	loop {
		req.clear();
		std::io::stdin().read_line(&mut req).unwrap();
		let req = req.trim();
		if req == "quit" {
			break
		}

		let pos: u128 = req.parse().unwrap();
		let bits: Vec<u64> = (0..64usize).into_par_iter()
			.map(|bit| lr[bit].get_bit_at(pos) as u64)
			.collect();
		let mut out = 0;
		for bit in 0..64 {
			out += bits[bit]<<bit;
		}
		println!("{}", out);
	}
}
