import sys
import requests
import hashlib
from Crypto.Cipher import PKCS1_OAEP
from Crypto.Hash import SHA256
from Crypto.PublicKey import RSA

privkey = open('real_privkey', 'rb').read()
keyid = hashlib.sha256(privkey).hexdigest()

file_name = sys.argv[1]

src = open(file_name, 'rb').read()
# referer = 'https://flags.2020.chall.actf.co/'
referer = None

# HOST = "http://0.0.0.0:5000"
HOST = "https://ubi.2020.chall.actf.co"

resp = requests.post(HOST + "/build", data={"src": src, "key": privkey, "referer": referer})
print resp.text.strip()
