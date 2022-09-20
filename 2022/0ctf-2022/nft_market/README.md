# nft-market

1. Claim airdrop, buy first NFT
2. Create fake NFT contract then create junk order with `purchaseTest`, get 1337 TTK tokens, buy second NFT
3. Notice that the contract is compiled with 0.8.15 even though 0.8.17 was released like 11 days ago
4. 0.8.16 fixed a bug that caused the first word of calldata to be zeroed
5. Notice that the first word is order id, which lets you do order id confusion between the market and the verifier
6. Final exploit is
  a. Create fake order (id 3)
  b. Claim airdrop
  c. Buy order 0 (now orders are `[fake order, real token 2, real token 3]`)
  d. Use purchaseTest to create and buy fake order to get tokens from market
  e. Buy order 1 (now orders are `[fake order, real token 3]`)
  f. Use coupon to buy order 1 for 1 TTK
    i. Coupon will verify that the owner of order 0 approved, which is us
    ii. Coupon will then allow us to purchase order 1 for 1 TTK
  g. Win

