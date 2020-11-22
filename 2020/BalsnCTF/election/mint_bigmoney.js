fs = require('fs');
const Web3 = require('web3')
var Tx = require('ethereumjs-tx').Transaction;

const web3 = new Web3(new Web3.providers.HttpProvider('https://ropsten.infura.io/v3/REDACTED'))
const eth = web3.eth;

async function load_accounts(file){
    account_list = JSON.parse(fs.readFileSync(file));
    let loaded_accounts = []
    for(var i = 0; i < account_list.length; ++i){
        let account = account_list[i];
        let cur_acct = web3.eth.accounts.privateKeyToAccount(account.privateKey);
        cur_acct.nonce = await web3.eth.getTransactionCount(cur_acct.address);
        loaded_accounts.push(cur_acct);
    };
    return loaded_accounts;
}

function load_abi(file){
    return new eth.Contract(JSON.parse(fs.readFileSync(file)));
}

async function get_transaction(account, _to, _value, _data)
{
    var privateKey = Buffer.from(account.privateKey.slice(2), 'hex');

    var rawTx = {
        to: _to,
        value: _value,
        data:_data,
        gasLimit: 3000000,
        gasPrice:13000000000,
    }

    var tx = new Tx(rawTx, {'chain':'ropsten'});
    tx.sign(privateKey);

    var serializedTx = tx.serialize();
    return '0x' + serializedTx.toString('hex')
}

async function get_signed(account, _to, _value, _data)
{
    deet = account.signTransaction({
        to: _to,
        value: _value,
        data:_data,
        gasLimit: 3000000,
        gasPrice:14000000000,
        nonce: account.nonce
    })
    account.nonce += 1;
    return deet;
}

async function main(){
    let accounts = await load_accounts('accounts.json')
    //console.log(accounts)
    let election = load_abi('election.abi')
    election.options.address = "0xf8d083836bce629221e8148bd326ed4b15e94a48";

    t2_data = await election.methods.transfer(accounts[4].address, 1).encodeABI() 
    t1_data = await election.methods.giveMeMoney().encodeABI(); 

    tx1 = await get_signed(accounts[0], election.options.address, 0, t1_data);
    tx2 = await get_signed(accounts[1], election.options.address, 0, t1_data);
    tx3 = await get_signed(accounts[2], election.options.address, 0, t1_data);
    tx4 = await get_signed(accounts[3], election.options.address, 0, t1_data);


    s1 = eth.sendSignedTransaction(tx1.rawTransaction);
    s2 = eth.sendSignedTransaction(tx2.rawTransaction);
    s3 = eth.sendSignedTransaction(tx3.rawTransaction);
    s4 = eth.sendSignedTransaction(tx4.rawTransaction);

    tx1 = await get_signed(accounts[0], election.options.address, 0, t2_data);
    tx2 = await get_signed(accounts[1], election.options.address, 0, t2_data);
    tx3 = await get_signed(accounts[2], election.options.address, 0, t2_data);
    tx4 = await get_signed(accounts[3], election.options.address, 0, t2_data);

    s5 = eth.sendSignedTransaction(tx1.rawTransaction);
    s6 = eth.sendSignedTransaction(tx2.rawTransaction);
    s7 = eth.sendSignedTransaction(tx3.rawTransaction);
    s8 = eth.sendSignedTransaction(tx4.rawTransaction);

    await Promise.all([s1, s2, s3, s4, s5, s6, s7, s8]);

    //await Promise.all([s1, s2, s3, s4]);
}
main();
