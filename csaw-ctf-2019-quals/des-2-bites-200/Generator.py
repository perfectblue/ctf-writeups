from Crypto.Cipher import DES
import binascii

IV = '13371337'

def getNibbleLength(offset):	
	if str(offset)[0]=="9":
		return len(str(offset))+1
	return len(str(offset))

def duck(aChr):
	try:
		return int(aChr)
	except:
		return "abcdef".index(aChr)+11

def encodeText(plainText,offset):
	hexEncoded = plainText.encode("hex")
	nibbleLen = getNibbleLength(offset)
	output = ""
	for i in range(0,len(hexEncoded),2):
		hexByte = hexEncoded[i:i+2]
		try: 
			output += str(duck(hexByte[0]) + offset).rjust(nibbleLen,"0")
			output += str(duck(hexByte[1]) + offset).rjust(nibbleLen,"0")
		except:
			continue
	return output

def padInput(input):
	bS = len(input)/8
	if len(input)%8 != 0:
		return input.ljust((bS+1)*8,"_")	
	return input
	
def desEncrypt(input,key):
	cipher = DES.new(key, DES.MODE_OFB, IV)
	msg = cipher.encrypt(padInput(input))
	return msg
		
def createKey(hex,fileName):
	with open(fileName, 'wb') as f:
		f.write(binascii.unhexlify(hex))

def createChallenge():
	createKey("INSERT_SOME_KEY","key1")
	createKey("SOME_OTHER_KEY","key2")

	plainText = open('FLAG.txt').read()
	key1 = open('key1').read()

	byte = desEncrypt(plainText,key1)
	key2 = open('key2').read()

	cipherText = desEncrypt(byte,key2)
	cipherText = encodeText(binascii.hexlify(cipherText),9133337)
	with open('FLAG.enc', 'w') as f:
		f.write(cipherText)
