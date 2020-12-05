const N = 100;
const candidates = Array.from({ length: 10000 }, (_, i) =>
  i.toString().padStart(4, "0")
).filter((x) => new Set(x).size === 4);
const pins = Array.from(
  { length: N },
  () => candidates[Math.floor(Math.random() * candidates.length)]
);

for (const pin of pins) {
	console.log(pin);
}

const nonce = Math.random().toString(36).slice(-10);
console.log(nonce);
