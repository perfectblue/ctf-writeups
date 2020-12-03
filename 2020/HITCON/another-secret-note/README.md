# another secret note

There are two things we can do:
1. Send json xored with a random byte and ask the server whether it's malformed or not (JSON oracle)
2. Send millions of bytes to the server to brute-force a message like `{"cmd":"get_secret","who":"admin","name":"admin","a":"aaaaaa"}`

## Getting user secret

Used method 1. in here to get user_secret.

The original message would be like:
```
0123456789012345
{"secret": "hitc
on{wedonknow", "
who": "user", "n
ame": "test"}
```

So, we set IV to `enc('{"secret": "hitc')` and then set ciphertext to:
```
0123456789012345
{"{wedonknow ,  
who": "user", "n
ame": "test"}
```

By xoring random byte to each byte of `wedonknow`, we can recover `user_secret`.

The solver is `solver_first.py`, and `user_flag` is `hitcon{JSON_is_5`.

## Getting encrypted admin messages

Used method 2. to get any message we want. Check `solver_second.py`.

From this point, we used two messages to get `admin_secret`:
```
{"cmd": "get_secret", "who": "admin", "name": "admin", "a": "a", "secret": "012345678901234}"}
eyJjaXBoZXIiOiAiZTM3ODVmYTM3MTU2YzM3NjI2Y2UwM2Y3NDk4Y2ZkMDBiYWQzYTczZDY2OGI2NDFhNDk1YWNmMzdmYzk1ZThjYzJmZTJiM2I3ODEyY2JkYzJmZGJmYjVkMmM3OTkwOTJmOTcyYmI1YmM4MGNjZmFiOGZhZjg2Y2Q4NWE4MzA1MjE4Yjk0Y2M4ZmQ0YWQyN2Q5ZTdjMGZjMGYxYTk0ZWE2Y2Q1OTc3NWU5NDY5MzM1M2YzZDNiZThlNzM0MTI2NWZmIn0=

{"cmd": "get_secret", "who": "admin", "name": "admin", "a": "aaaaaa", "secret": "012345678901234}"}
eyJjaXBoZXIiOiAiOGQ1YzFmNmE3ODliODJiM2I2NTBlZjJiYjAxNDE5YjQzN2UwMzM1NmQxNTljMGZiMjVlMGQxZTRiYWM4ZGUyNjA1NWVhZjEzODg4NjJmMGMzZDUxYmQ3NDZlNWZhOTVkYTZmNmVjYzkxZmU3NzZiMDc2M2YzZjgwNmQ0NDRlMDU0NzEyOGM4ZjZkZjc5MzRhMzUwNjM0NjM5MjE5NDkyY2I3YmMzMzcxYTc5NDk2YmIwZjQyZmZkMDM2MmE2MjNhYWYxZGY2ZWFhNmYyMDU2Zjk0ODkwNDA2M2I5NTRlNGEifQ==
```

## Getting admin secret

Used method 1. , as same as getting the user secret.
Check out `solver_third_1.py` and `solver_third_2.py`.

`admin_secret` is `0_woNderFul!@##}`.