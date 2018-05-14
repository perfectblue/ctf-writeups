from sage.all_cmdline import *
#from pwn import *
from RSAExploits import *
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_v1_5
import sys

sys.setrecursionlimit(10000)

# Parse and store all of the ciphertexts provided by the file
rsadata_list = []
for i in range(0, 100):
	publickey = RSA.importKey(open('%d.pem'%(i,)).read()).key
	N = publickey.n
	e = publickey.e
	c = long(open('%d.enc'%i).read().encode('hex'),16)
	rsadata_list.append(RSAData(rsa_obj(N, e), TextData(c, i)))

# Library specific call
# Run the exploit by specifying it
Common_Factor().run(rsadata_list)

