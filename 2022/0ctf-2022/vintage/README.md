# vintage

## Part 1

At this moment, I was using an emulator called [vectrexy](https://github.com/amaiorano/vectrexy). It has a simple debugger.

There was a loop looping for eight times, which seemed like checking the password.
It is surely doing sth like `inp[i] ^ 0x21 ^ i`, but it did not work to solve.

So in this case, I set breakpoints for each character to find the password.
The password was `BLACKKEY`.

## Part 2

At this moment, I was using an emulator called RetroArch, with the core called vecx.
It does not have a debugger, but there's a simple game state saver.
It was possible to change some memory values by modifying saved state files.

It seemed like using RC4 (`$2549`) to decrypt the flag, and the key was on `$CA60`.
However, it was impossible to get the flag by changing `$CA60` directly. (I still don't know why.)

There are three conditions to fulfill, to get the flag:
1. Collect five coins.
2. Jump 1337 times.
3. Press specific order of buttons (`LRUDAASS`).

About the first condition, we modified the `y` value to get the last coin, as it was not supposed to get in a normal way.
Also about the second condition, there are a 4-byte state (`$C8B2`) which changes on every jump
and a jump counter (I cannot remember where it was). We have to set both of them to the correct values.

Here's bad code to calculate the 4-byte state:
```python
def change(inp):
    values = list(inp)

    values[0] = (values[0] + 1) & 0xFF
    s0 = values[0]
    s1 = values[0] ^ values[1] ^ values[3]
    values[1] = s1
    values[2] = (s1 + values[2]) & 0xFF
    values[3] = (((values[2] >> 1) + values[3]) & 0xFF) ^ s1

    return bytes(values)

state = bytes.fromhex('36 58 CF 1F')
cnt = 0
while True:
    cnt += 1
    if cnt == 1335:
        print(state.hex())
    state = change(state)
    if state[1] == 0x70 and state[2] == 0x78 and state[3] == 0xb7:
        break

print(cnt, state)
```

After fulfilling those three conditions, we could get the flag: `flag{1337_VEC_GAME}`