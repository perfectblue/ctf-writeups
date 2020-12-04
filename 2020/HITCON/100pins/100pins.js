#!/usr/bin/env node

const rl = require("readline").createInterface({
  input: process.stdin,
  output: process.stdout,
});
rl.on("close", () => {
  yellow("Bye");
  process.exit(1);
});

const ask = (q) => new Promise((resolve) => rl.question(q, (s) => resolve(s)));

const colorLog = (c) => (...args) =>
  console.log(`\x1b[1;${c}m` + args.join(" ") + "\x1b[0m");
const red = colorLog(31);
const green = colorLog(32);
const yellow = colorLog(33);
const info = colorLog(0);

const flag = process.env["FLAG"];
if (flag === undefined || !flag.startsWith("hitcon")) {
  red("Oops... missing flag, please contact admin");
  process.exit(2);
}

setTimeout(() => {
  red("Too sloooooooooooow :(");
  process.exit(3);
}, 180 * 1000);

const N = 100;
const candidates = Array.from({ length: 10000 }, (_, i) =>
  i.toString().padStart(4, "0")
).filter((x) => new Set(x).size === 4);
const pins = Array.from(
  { length: N },
  () => candidates[Math.floor(Math.random() * candidates.length)]
);

const match = (pin, s) => {
  let a = 0;
  let b = 0;
  for (let i = 0; i < s.length; i++) {
    const j = pin.indexOf(s[i]);
    if (j === i) a++;
    else if (j !== -1) b++;
  }
  return [a, b];
};

const sha256 = (s) =>
  require("crypto").createHash("sha256").update(s).digest("hex");

const pow = async () => {
  const nonce = Math.random().toString(36).slice(-10);
  const s = await ask(`Show me sha256("${nonce}" + s) ends with "00000": `);
  const hash = sha256(nonce + s);
  if (!hash.endsWith("00000")) {
    red("Huh?");
    //process.exit(4);
  }
};

const main = async () => {
  green(`Welcome to FLAG locker ${process.version}`);
  await pow();
  info(`=== FLAG is locked with ${N} pins ===`);
  let rem = 128;
  for (let i = 0; i < N; i++) {
    if (--rem < 0) {
      red("Too many errors! Device is wiped and the flag is gone ¯\\_(ツ)_/¯");
      process.exit(5);
    }

    const pin = pins[i];
    const s = await ask(`Pin ${i + 1}? `);
    const [a, b] = match(pin, s);
    if (a === 4) {
      green("OK");
      continue;
    }

    yellow(`Hmm... hint: ${a}A${b}B`);
    i--;
  }

  green("FLAG Unlocked:", flag);
  process.exit(0);
};

main().finally(() => process.exit(6));
