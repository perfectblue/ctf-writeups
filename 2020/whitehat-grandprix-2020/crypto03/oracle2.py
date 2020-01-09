import random
import copy
import itertools

RATE = 8
MASK = (1<<64)-1


class TheOracle:
	"""
	This class is used for encryption
	"""

	def __init__(self, key_bytes, nonce_bytes, a, b, c, d):
		self.key = key_bytes[:0x10] if len(key_bytes) > 0x10 else key_bytes + b'\x00' * (0x10 - len(key_bytes))
		self.nonce = nonce_bytes[:0x10] if len(nonce_bytes) > 0x10 else nonce_bytes + b'\x00' * (
			0x10 - len(nonce_bytes))
		self.rotor = list()
		# a - init; b - salt; c - encode/decode; d - tag
		#self.a, self.b, self.c, self.d = [random.randint(0, (1 << 5)) for i in range(4)]
		self.a, self.b, self.c, self.d = a, b, c, d
		self.init_rotor()

	def init_rotor(self): # like Ascon
		"""
		Initialize the rotor
		:return:
		"""
		key_nonce = self.key + self.nonce
		temp = [self.a, self.b, self.c, self.d]

		for j in range(0, 32, 8):
			self.rotor += [sum([key_nonce[j: j + 8][i] << ((7 - i) * 8) for i in range(8)])]
		self.rotor = [sum([temp[i] << ((7 - i) * 8) for i in range(len(temp))])] + self.rotor

		self.rotor = self.black_box(self.rotor, self.a)

		for i in range(2):
			self.rotor[3 + i] ^= sum([self.key[i * 8: i * 8 + 8][j] << ((7 - j) * 8) for j in range(8)])

	def black_box(self, rotor, loop):
		for r in range(loop % 16):
			rotor[4] ^= rotor[3] # just like ascon
			rotor[0] ^= rotor[3] ^ rotor[4]
			rotor[2] ^= rotor[1] ^ (0xf0 - r * 0x0f)

			t = [(rotor[i] ^ ((1 << 64) - 1)) & rotor[(i + 1) % 5] for i in range(5)]
			rotor = [rotor[i] ^ t[(i + 1) % 5] for i in range(5)] # just like ascon

			rotor[0] ^= rotor[4]
			rotor[3] ^= rotor[2]
			rotor[1] ^= rotor[4] ^ rotor[0]
			rotor[2] ^= ((1 << 64) - 1) # just like ascon

			# like in ascon
			rotor[0] ^= (((rotor[0] >> 0x13) | (rotor[0] << (64 - 0x13))) & ((1 << 64) - 1)) ^ (((rotor[0] >> 0x1c) ^ (rotor[0] << (64 - 0x1c))) % (1 << 64))
			rotor[1] ^= (((rotor[1] >> 0x3d) | (rotor[1] << (64 - 0x3d))) & ((1 << 64) - 1)) ^ (((rotor[1] >> 0x27) ^ (rotor[1] << (64 - 0x27))) % (1 << 64))
			rotor[2] ^= (((rotor[2] >> 0x01) | (rotor[2] << (64 - 0x01))) & ((1 << 64) - 1)) ^ (((rotor[2] >> 0x06) ^ (rotor[2] << (64 - 0x06))) % (1 << 64))
			rotor[3] ^= (((rotor[3] >> 0x0A) | (rotor[3] << (64 - 0x0A))) & ((1 << 64) - 1)) ^ (((rotor[3] >> 0x11) ^ (rotor[3] << (64 - 0x11))) % (1 << 64))
			rotor[4] ^= (((rotor[4] >> 0x07) | (rotor[4] << (64 - 0x07))) & ((1 << 64) - 1)) ^ (((rotor[4] >> 0x29) ^ (rotor[4] << (64 - 0x29))) % (1 << 64))

		return rotor

	def handle_salt(self, salt, the_hidden, rotor, the_rate):
		padding = bytes([0x80]) + bytes(the_rate - (len(salt) % the_rate) - 1)
		result = salt + padding

		for b in range(0, len(result), the_rate):
			# what fucking retard wrote this?
			rotor[0] ^= sum([result[b: b + the_rate][j] << ((the_rate - 1 - j) * the_rate) for j in range(the_rate)])
			self.black_box(rotor, the_hidden)

		return rotor

	def encrypt(self, salt=None, plain_text=None):
		"""
		Encrypt a plaintext
		:param salt:
		:param plain_text:
		:return: cipher text
		"""
		temp = copy.copy(self.rotor)
		if salt is not None:
			temp = self.handle_salt(salt, self.b, temp, RATE)
		temp[4] = temp[4] - 1 if temp[4] & 1 else temp[4] + 1

		padding = bytes([0x80]) + bytes(RATE - (len(plain_text) % RATE) - 1)
		result = plain_text + padding

		cipher_text = b''
		for b in range(0, len(result) - RATE, RATE):
			temp[0] ^= sum([result[b: b + RATE][j] << ((RATE - 1 - j) * RATE) for j in range(RATE)])
			cipher_text += bytes([(temp[0] >> ((RATE - 1 - i) * RATE)) & 0xff for i in range(RATE)])

			self.black_box(temp, self.c)

		the_last_mess = len(result) - RATE
		temp[0] ^= sum([result[the_last_mess: the_last_mess + RATE][j] << ((RATE - 1 - j) * RATE) for j in range(RATE)])
		cipher_text += bytes([(temp[0] >> ((RATE - 1 - i) * RATE)) & 0xff for i in range(RATE)][:-len(padding)])

		return cipher_text.hex()

	def decrypt(self, salt=None, plain_text=None):
		temp = copy.copy(self.rotor)
		if salt is not None:
			temp = self.handle_salt(salt, self.b, temp, RATE)
		temp[4] = temp[4] - 1 if temp[4] & 1 else temp[4] + 1

		padding = bytes([0x80]) + bytes(RATE - (len(plain_text) % RATE) - 1)
		result = plain_text + padding

		cipher_text = b''
		for b in range(0, len(result) - RATE, RATE):
			w = sum([result[b: b + RATE][j] << ((RATE - 1 - j) * RATE) for j in range(RATE)])
			w ^= temp[0]
			temp[0] ^= w
			#temp[0] ^= sum([result[b: b + RATE][j] << ((RATE - 1 - j) * RATE) for j in range(RATE)])
			cipher_text += bytes([(w >> ((RATE - 1 - i) * RATE)) & 0xff for i in range(RATE)])

			self.black_box(temp, self.c)

		the_last_mess = len(result) - RATE
		w = sum([result[the_last_mess: the_last_mess + RATE][j] << ((RATE - 1 - j) * RATE) for j in range(RATE)])
		w ^= temp[0]
		temp[0] ^= w
		cipher_text += bytes([(w >> ((RATE - 1 - i) * RATE)) & 0xff for i in range(RATE)][:-len(padding)])

		return cipher_text


CTEXT = bytes.fromhex('3de950493ad1c29b5f9ae4ac5587c88ff8a6e18bbd642f2d84ce')
if __name__ == "__main__":
	old = None
	for params in itertools.product(range(32), repeat=4):
		if params[0] != old:
			old = params[0]
			print(old)
		server = TheOracle(b'this_is_whitehat', b'do_not_roll_your_own_crypto', *params)
		salt_bytes = b'once_upon_a_time'
		#plain = open('flag').read().encode()
		#cipher = server.encrypt(salt_bytes, plain)
		plain = server.decrypt(salt_bytes, CTEXT)
		k = 0
		for x in plain:
			if x&0x80:
				k += 1
		if k == 0:
			print(plain)
