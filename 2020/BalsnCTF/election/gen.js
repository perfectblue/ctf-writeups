fs = require('fs');
const Web3 = require('web3')

const web3 = new Web3(new Web3.providers.HttpProvider('https://ropsten.infura.io/v3/REDACTED'))

async function sice(){
    //let acts = []
    //for(var i = 0; i < 5; ++i){
        //let cur_acct = web3.eth.accounts.create();
        //acts.push({'address':cur_acct.address, 'privateKey': cur_acct.privateKey});
    //}
    //fs.writeFileSync('accounts1.json', JSON.stringify(acts));

    while(1){
        let cur_acct = web3.eth.accounts.create()
        if(parseInt(cur_acct.address.slice(-2), 16) == 3){
            console.log(cur_acct);
            return;
        }
    }
}

sice()

