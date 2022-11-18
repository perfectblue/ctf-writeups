use minidump::{Minidump, MinidumpSystemInfo, MinidumpMemory64List};
use rayon::prelude::*;

struct RC4 {
	s: [u8; 256],
	i: u8,
	j: u8,
}

impl RC4 {
	fn fwd(&mut self) -> u8 {
		self.i = self.i.wrapping_add(1);
		self.j = self.j.wrapping_add(self.s[self.i as usize]);
		self.s.swap(self.i as usize, self.j as usize);
		self.s[self.s[self.i as usize].wrapping_add(self.s[self.j as usize]) as usize]
	}

	fn back(&mut self) {
		self.s.swap(self.i as usize, self.j as usize);
		self.j = self.j.wrapping_sub(self.s[self.i as usize]);
		self.i = self.i.wrapping_sub(1);
	}
}

fn load_ct() -> anyhow::Result<Vec<u8>> {
	let bytes = std::fs::read("../tcp/192.168.003.006.08080-010.000.002.015.50600")?;

	let mut ct = vec![];

	let mut inp = &bytes[..];
	let mut pkt_i = 0;
	while ! inp.is_empty() {
		let n = u32::from_le_bytes(inp[..4].try_into().unwrap()) as usize;
		dbg!(pkt_i, n);
		pkt_i += 1;
		if pkt_i > 1 {
			ct.extend_from_slice(&inp[4..4+n]);
		}
		inp = &inp[4+n..];
	}

	Ok(ct)
}

fn check_keystream(ciphertext: &[u8], keystream: &[u8]) -> bool {
	for kw in keystream.windows(ciphertext.len()) {
		let mut ok = true;
		for (k, c) in ciphertext.iter().copied().zip(kw.iter().copied()) {
			if (k^c) >= 0x80 {
				ok = false;
				break;
			}
		}
		if ok {
			let mut pt = vec![];
			for (k, c) in ciphertext.iter().copied().zip(kw.iter().copied()) {
				pt.push(k^c);
			}
			eprintln!("pt: {:?}", pt);
			return true;
		}
	}

	false
}

fn main() -> anyhow::Result<()> {
	let ciphertext = load_ct()?;
	let ciphertext = &ciphertext[..100];

	let dmp = Minidump::read_path("../araiguma.DMP")?;

	let mem = dmp.get_stream::<MinidumpMemory64List>()?;

	let regions: Vec<_> = mem.by_addr().collect();
	regions.par_iter().for_each(|r| {
		let mut mask = [0u64; 4];
		for (ofs, state) in r.bytes.windows(256).enumerate() {
			mask.fill(0);

			for b in state {
				mask[(b>>6) as usize] |= 1<<(b&63);
			}

			if ! mask.into_iter().all(|x| x == u64::MAX) {
				continue
			}

			eprintln!("potential state at 0x{:x}", ofs as u64 + r.base_address);

			let mut rc4 = RC4 {
				s: [0; 256],
				i: 0,
				j: 0,
			};
			let mut x = vec![];
			for i in 0..=255 {
			for j in 0..=255 {
				rc4.s.copy_from_slice(&state[..]);
				rc4.i = i;
				rc4.j = j;

				for _ in 0..400 {
					rc4.back();
				}
				x.clear();
				for _ in 0..800 {
					x.push(rc4.fwd());
				}

				check_keystream(&ciphertext, &x);
			} }
		}
	});

	Ok(())
}
