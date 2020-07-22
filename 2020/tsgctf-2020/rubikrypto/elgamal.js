const Cube = require('cubejs');
const fs = require('fs');
const {randint, buffer2cubes, cubes2buffer} = require('./utils.js');

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

const str = (cube) => Cube.inverse(cube.solve());
const from_str = (cube) => Cube.move(cube);

const ORDER = 43_252_003_274_489_856_000n;
}


const flag = fs.readFileSync('flag.txt');
const cubes = buffer2cubes(flag);

for (const cube of cubes) {
  const g = Cube.random();
  const x = randint(ORDER)

  const h = pow(g, x);
  const y = randint(ORDER)

  const m = cube.clone();

  const c1 = pow(g, y);
  const c2 = m.multiply(pow(h, y));

  console.log({
    g: str(g),
    h: str(h),
    c1: str(c1),
    c2: str(c2),
  });
}
Cube.initSolver();
