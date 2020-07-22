const Cube = require('cubejs');
const fs = require('fs');
const {randint, buffer2cubes, cubes2buffer} = require('./utils.js');
Cube.initSolver();

const DSA = [
{
  g: "L2 R2 U R2 U' R2 B2 D2 L2 U B2 U2 R' B' U2 F2 U L' B2 R D' R'",
  h: "L2 R2 D2 B2 L2 U' R2 D B2 D' B2 U' F R' D U' L D' B U R F",
  c1: "U2 F2 D L2 B2 D' R2 B2 F2 U L2 U2 F R U L2 R2 U2 B' F2 U",
  c2: "U2 L2 R2 U' R2 D2 F2 U B2 U R2 F' U L' B D' U2 R' F2 L' B D"
},
{
  g: "U2 L2 U2 L2 D F2 D' L2 D R2 U' R2 U2 F L B D' L2 D2 R F2 D'",
  h: "L2 U L2 D' B2 U R2 U B2 R2 B2 R U2 B D' L2 D' F' R U' B D2",
  c1: "L2 D2 F2 U L2 D2 L2 U B2 D' B2 F' L D' B' U' R F U' B2 L' F2",
  c2: "L2 F2 D2 F2 D' R2 B2 D B2 L2 U B2 F' L2 F' D F2 L F D R U"
},
{
  g: "B2 U F2 D B2 D L2 U R2 D' B F R' D F L R F2 R2 B U2",
  h: "L2 F2 U2 R2 F2 R2 U2 R2 F2 L' R' U2 L' R'",
  c1: "D F2 U F2 U B2 D' B2 U F2 L2 U2 R' F2 L U2 B' U' L2 R' B2 F'",
  c2: "F2 U L2 F2 D L2 U R2 B2 U' B2 R2 U B R' D' U F' L B' R' D'"
},
{
  g: "B2 L2 D' B2 R2 U2 L2 U' F2 U R2 F2 R B' D2 R F R' D L U' F",
  h: "F2 D' L2 D U2 L2 R2 U' L2 B2 U2 B' F L B2 D' B2 L' U2 F U2 R'",
  c1: "D' F2 R2 B2 F2 U2 L2 U' B2 U R2 B2 F2 L' D L2 R B F' L U L2",
  c2: "U2 R2 D U2 F2 L2 D' L2 U L2 U2 R' B' D2 U2 L R2 B R D R'"
},
{
  g: "B2 U' F2 U' F2 U2 L2 D B2 U' B2 F' L' R2 B' R2 D B F D2 R' U",
  h: "F2 R2 B2 L2 F2 R2 U R2 U' L2 R2 D2 L' B L F2 L' U2 F' R2 U' R2",
  c1: "R2 U' L2 D2 U' F2 L2 B2 F2 R2 D' B' R' D L' R' U2 B' D' U R'",
  c2: "U2 R2 U' L2 U' F2 D B2 D F2 R2 U F' L B R2 F R2 D U F' R"
},
{
  g: "F2 D' L2 U2 F2 R2 U2 R2 F2 L2 R' F L2 F2 L' D' R B R2 D' F2",
  h: "B2 U F2 R2 D L2 U' F2 U2 F2 R2 F' U R' B2 D' F L' F2 U F U'",
  c1: "D R2 D' B2 D' F2 L2 F2 D2 B2 F2 U' L' U2 B F' R B D2 L2 D R2",
  c2: "F2 R2 F2 D' L2 D L2 U F2 U L2 U2 F' L R' D' L R2 U' L D'"
},
{
  g: "D2 L2 D' F2 L2 R2 U' B2 F2 D2 U' R2 B' L F' L' F' L' D2 U",
  h: "B2 U2 L2 D' R2 F2 R2 U' R2 D' L2 D U' F' D' R' D2 F' D' F R'",
  c1: "D R2 B2 D L2 U2 R2 B2 U F2 D2 R' B2 D' U2 B R' B2 R' F R2 U",
  c2: "D2 L2 R2 B2 D' F2 D L2 D' F2 R2 B' R2 U L R' D B L2 U L' B'"
},
{
  g: "D' F2 L2 U' B2 U2 F2 D' F2 U' B' R' U R D2 B R B L' U2 R2",
  h: "D2 B2 F2 D B2 D L2 B2 F2 U' L2 U2 L B' F U' F D2 B2 L D2 U'",
  c1: "L2 R2 U L2 R2 U2 F2 U' R2 U' B2 D' R D2 F R' D' F U' L2 D' U",
  c2: "U2 B2 U' F2 R2 D L2 F2 U B2 D' B U' R2 F2 R B' L' R F D' R'"
},
{
  g: "D' R2 D' B2 R2 D L2 U2 R2 B2 L2 B2 L' B U' R' D' R B' F2 L2",
  h: "U' R2 B2 D2 B2 U' B2 D' F2 D U2 F R2 U' L' D' B' U2 F' L' U2 R'",
  c1: "U L2 R2 F2 R2 U B2 D R2 B2 D' R2 B' D F2 R U2 R B D R F",
  c2: "R2 F2 L2 F2 U F2 U2 R2 F2 U' B2 R2 B' R2 U B' R' F' R2 D' R2 F2"
},
{
  g: "L2 U B2 U' F2 R2 D' L2 B2 U L2 F' D' R' U R' D2 R' B' L' F R2",
  h: "F2 D F2 L2 U2 B2 F2 U' L2 U B2 D2 L B2 R D' B' F2 L2 B2 D2 R",
  c1: "R2 B2 U2 R2 B2 D U B2 R2 U2 F2 L' F2 R D U' F' D2 F' U2",
  c2: "L2 D F2 D B2 F2 R2 D2 R2 U B2 L2 F2 R B R' B' L R F' R2 F2"
},
];

const pow = (a, n) => {
	const r = new Cube();
	const x = a.clone();
	while (n !== 0n) {
		if (n % 2n === 1n) {
			r.multiply(x);
		}
		x.multiply(x);
		n /= 2n;
	}
	return r;
};

const from_str = (cube) => new Cube().move(cube);

const ORDER = 43_252_003_274_489_856_000n;

function eq(a, b) {
	return JSON.stringify(a.toJSON()) == JSON.stringify(b.toJSON());
}

function assert(cond, msg) {
	if (! cond) {
		console.log("assertion failed:", msg);
		while (1) {}
	}
}

function dlog(g, h) {
	var it = new Cube();
	var l = 0n;
	while (! eq(it, h)) {
		l += 1n;
		it = it.multiply(g);
	}
	return l;
}

var cubes = [];
for (const dsa of DSA) {
	var g = from_str(dsa.g);
	var h = from_str(dsa.h);
	var c1 = from_str(dsa.c1);
	var c2 = from_str(dsa.c2);
	var x = dlog(g, h);
	console.log('dlog', x);
	assert(eq(pow(g, x), h), "dlog is correct");
	const pad = pow(c1, x);
	cubes.push(c2.multiply(new Cube().move(pad.solve())));
}

console.log(cubes2buffer(cubes).toString('utf8'));
