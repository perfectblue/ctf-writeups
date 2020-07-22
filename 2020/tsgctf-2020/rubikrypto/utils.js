// I think you don't have to read this file in order to solve challenge.

const crypto = require('crypto');
const {range, sum} = require('lodash');
const Cube = require('cubejs');

const ORDER = 43_252_003_274_489_856_000n;

const getParity = (perm) => {
  const p = perm.slice();
  let parity = false;
  for (const i of range(p.length)) {
    for (const j of range(p.length - 1)) {
      if (p[j] > p[j + 1]) {
        [p[j], p[j + 1]] = [p[j + 1], p[j]];
        parity = !parity;
      }
    }
  }
  return parity;
};

const number2cube = (n) => {
  const randint = (range) => {
    const ret = Number(n % BigInt(range));
    n /= BigInt(range);
    return ret;
  };

  const cp = [];
  const corners = range(8);
  for (const i of range(8, 0)) {
    const index = randint(i);
    cp.push(corners.splice(index, 1)[0]);
  }

  const ep = [];
  const edges = range(12);
  for (const i of range(12, 2)) {
    const index = randint(i);
    ep.push(edges.splice(index, 1)[0]);
  }

  if (getParity(cp) ^ getParity([...ep, ...edges])) {
    ep.push(edges[1], edges[0]);
  } else {
    ep.push(edges[0], edges[1]);
  }

  const co = [];
  for (const i of range(7)) {
    co.push(randint(3));
  }
  co.push((24 - sum(co)) % 3);

  const eo = [];
  for (const i of range(11)) {
    eo.push(randint(2));
  }
  eo.push((24 - sum(eo)) % 2);
  
  const cube = new Cube();
  cube.init({center: range(6), cp, ep, co, eo});

  return cube;
};

const cube2number = (cube) => {
  let n = 0n;

  const unrandint = (rand, range) => {
    n = n * BigInt(range) + BigInt(rand);
  };
  
  const [cp, ep, co, eo] = [
    cube.cp.slice(),
    cube.ep.slice(),
    cube.co.slice(),
    cube.eo.slice(),
  ];

  eo.reverse();
  for (const o of eo.slice(1)) {
    unrandint(o, 2);
  }

  co.reverse();
  for (const o of co.slice(1)) {
    unrandint(o, 3);
  }

  {
    const rands = [];
    const edges = range(12);
    for (const p of ep.slice(0, -2)) {
      const index = edges.indexOf(p);
      rands.push(index);
      edges.splice(index, 1);
    }

    rands.reverse();
    for (const [i, rand] of rands.entries()) {
      unrandint(rand, i + 3);
    }
  }

  {
    const rands = [];
    const corners = range(8);
    for (const p of cp) {
      const index = corners.indexOf(p);
      rands.push(index);
      corners.splice(index, 1);
    }

    rands.reverse();
    for (const [i, rand] of rands.entries()) {
      unrandint(rand, i + 1);
    }
  }

  return n;
};

const buffer2cubes = (buffer) => {
  let number = BigInt('0x' + buffer.toString('hex'));

  const cubes = [];
  while (number > 0n) {
    const mod = number % ORDER;
    cubes.push(number2cube(mod))
    number /= ORDER;
  }

  return cubes;
};

const cubes2buffer = (cubes) => {
  let number = 0n;
  for (const cube of cubes.reverse()) {
    number *= ORDER;
    number += cube2number(cube);
  }
  const hex = number.toString(16);
  if (hex.length % 2 === 1) {
    return Buffer.from('0' + hex, 'hex');
  }
  return Buffer.from(hex, 'hex');
};

const randint = (n) => {
  return BigInt('0x' + crypto.randomBytes(32).toString('hex')) % n;
};

module.exports = {
  buffer2cubes,
  cubes2buffer,
  randint,
};
