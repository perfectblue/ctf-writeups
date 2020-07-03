# Lottery

- Lottery redemption based on encrypted ciphertext that includes userID, lottery ID and amount of coins.
- The encryption algo was kinda weird, but we could flip random blocks with blocks from other ciphertexts
- Basically replace the last 2 blocks with our userID to redeem lotteries from other accounts as ours
- Last two blocks didn't include the first byte of account ID, so @knapstack registered 400 accounts with the same prefix
- Solve script in [solve.py](solve.py) and [solve2.py](solve2.py) 
