import binascii
import socket
import struct

from Crypto.Cipher import AES
from Crypto.Hash import SHA256

pack = lambda x: struct.pack('<H', x)
unpack = lambda x: struct.unpack('<H', x)[0]

class Netcat:
	def __init__(self, ip, port):
		self.request = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		self.request.connect((ip, port))
	def read(self):
		length = unpack(self.request.recv(2))
		data = bytes()
		while len(data) < length:
			data += self.request.recv(1)
		return data
	def write(self, data):
		self.request.send(pack(len(data)))
		self.request.send(data)
	def close(self):
		self.request.close()

client = Netcat('crypto-mitm.ctfz.one', 3338)
server = Netcat('crypto-mitm.ctfz.one', 3339)

client_hello = client.read()
print(client_hello)

server.write(client_hello)
server_hello = server.read()
print(server_hello)

client.write(server_hello)
client_ok = client.read()
client_ok = b'OK:B=0|nonce=00000000000000000000000000000000|\n'
print(client_ok)

server.write(client_ok)
enc = binascii.unhexlify(server.read())
print(enc)

client.close()
server.close()

h = SHA256.new()
h.update(b'0')
key = h.digest()

cipher = AES.new(key, AES.MODE_CTR, nonce=bytes(12))
dec = cipher.decrypt(enc)
print(dec)
