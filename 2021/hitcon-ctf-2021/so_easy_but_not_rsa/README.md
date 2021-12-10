# so easy but not rsa

This one is about recovering the Mersenne Twister state. As `240 = 32 * 7 + 16`, it's impossible to recover the eighth value every eight values directly. By using the fact that the next `x_i` value is generated from `x_{i+1}`, `x_{i+397}` and the old `x_i`, it's possible to recover those lost values easily.

After recovering the state (`recover.py`), just brute force to recover the random nonce in encryption and then the flag. The flag is `hitcon{ohno!secure_random_is_50_important!}`.