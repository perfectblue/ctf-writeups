function main(input) {
  let goldeen = input.map((x) => parseInt(x.join(""), 2).toString(16)).join(""); 
  let stunfisk = ""; 
  for (let i = 0; i < 1000000; i++) { 
    stunfisk = require("crypto").createHash("sha512").update(stunfisk).update(goldeen).digest("hex"); 
  } 
  let feebas = Buffer.from(stunfisk, "hex");
  let remoraid = Buffer.from("0ac503f1627b0c4f03be24bc38db102e39f13d40d33e8f87f1ff1a48f63a02541dc71d37edb35e8afe58f31d72510eafe042c06b33d2e037e8f93cd31cba07d7", "hex");
  for (var i = 0; i < 64; i++) { 
    feebas[i] ^= remoraid[i]; 
  } 
  console.log(feebas.toString("utf-8")); 
}
main([[0, 0, 0, 0],
      [1, 0, 0, 1],
      [1, 1, 1, 1],
      [0, 1, 0, 0],
      [1, 0, 0, 0],
      [0, 0, 1, 0],
      [1, 1, 0, 0],
      [0, 0, 0, 1],
      [0, 1, 0, 1],
      [1, 0, 1, 0],
      [1, 0, 1, 1],
      [1, 1, 0, 1],
      [0, 1, 1, 1],
      [0, 1, 1, 0],
      [1, 1, 1, 0],
      [0, 0, 1, 1],
      [0, 0, 0, 0]])
// �PCTF{s0_Lon6_4Nd_tHanK5_f0R_4lL_Th3_f15H!_f74857d88a039}�