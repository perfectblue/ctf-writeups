# Secret

1. `m^(p + e) = m^(e + 1) mod p`. So, run LLL with `es[i]` to get `1 mod p`. Recover `p` from that.
2. Now we know `p`. Run LLL with `es[i] + p` to get `1 mod n`, then recover `q`.
3. Use extended GCD to recover `m`