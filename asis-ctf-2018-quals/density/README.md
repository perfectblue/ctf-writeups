# Density

Writeup by **slenderestman**

**Category**: Reverse

148 Points

27 Solves

**Problem description**:
```
Keep it short and simple
```
---

so, we are given two files, a executeable and a data file. base64 decoding the binary file yields `O++h+b+qcASIS++e01d+c4Nd+cGoLD+cASIS+c1De4+c4H4t+cg0e5+cf0r+cls+d++gdI++j+kM+vb++fD9W+q/Cg==` which is a nice start!

when you reverse the binary, you can see bad characters get turned into `+` and `/`.

the file name is b64pack, so we guess it is doing something base64 like.
Poke around in the binary and see it is appending a random amount of data before and after your input, then does some operations on it. I put in a lot of A's to the b64 binary nd read the output; there were a lot of null bytes.
I did it again with B's and because it was base64 I decided to split it in groups of six bits each (2^6 is 64) and look at it, using python.
In the middle of the output there were a bunch of 000001000001000001...
It seems it was changing the input into a 6 bit value.
I decided to bruteforce the 6 bit value corresponding to each character and made a python script to do so, then find the value for ASIS within the given file and decode it from there.
To deal with the prepended and appended random data while bruteforcing, I created a patched version of b64pack that didn't do that.
However it gave bad ouput, with { and _ spaces being messed up along with several other characters.
I realized there are more than 64 characters.
After some playing around it seems these other characters just used 12 or 18 bits to represent themselves, using 111110 as a sort of marker to mark a special character that would be more than 6 bits.
I bruteforced these values with another python script and then manually debugged the output until I got the flag.
Finally, I did a bunch of brute force guessing :\ so I guess that's how you do this problem blind.

`ASIS{01d_4Nd_GoLD_ASIS_1De4_4H4t_g0e5_f0r_ls!}`

```python
 x=open("pe","rb").read()
import binascii
f=binascii.hexlify(x)
re=bin(int(f,16))
re=re[re.index("000000010010001000010"):re.index("111110111110100000")+18]
y=open("pee","rb").read()
for i in range(len(x)):
    if x[i] in y:
        print ord(x[i])
z=open("scam","rb")
from pwn import *
import string,sys
f=binascii.hexlify(z.read())
print bin(int(f,16))
print bin(int(ord("A")-0x41))
print bin(int(ord("S")-0x41))
print re
poo1="000000010010001000010010111110111110011110110100110101011101111110011100111000001101011101111110011100000110101000001011000011111110011100000000010010001000010010111110011100110101000011011110111000111110011100111000000111111000101101111110011100100000110100011110111001111110011100011111110100101011111110011100100101101100111110011101111110111110100000"
#    000000010010001000010010111110111110011110110100110101011101111110011100111000001101011101111110011100000110101000001011000011111110011100000000010010001000010010111110011100110101000011011110111000111110011100111000000111111000101101111110011100100000110100011110111001111110011100011111110100101011111110011100100101101100111110011101111110111110100000
#    000000010010001000010010111110111110011110110100110101111110011100111000001101011101111110011100000110101000001011000011111110011100000000010010001000010010111110011100110101000011011110111000111110011100111000000111111000101101111110011100100000110100011110111001111110011100011111110100101011111110011100100101101100111110111110100000
poo="000000010010001000010010111110111110011110110100110101011101111110011100111000001101011101111110011100000110101000001011000011111110011100000000010010001000010010111110011100110101000011011110111000111110011100111000000111111000101101111110011100100000110100011110111001111110011100011111110100101011111110011100100101101100111110011101111110111110100000"
#    000000010010001000010010111110111110011110110100110101011101111110011100111000001101011101111110011100000110101000001011000011111110011100000000010010001000010010111110011100110101000011011110111000111110011100111000000111111000101101111110011100100000110100011110111001111110011100011111110100101011111110011100100101101100111110111110100000
print poo.index("101110")
fag="000000010010001000010010111110111110011110110100110101011101111110011100111000001101011101111110011100000110101000001011000011111110011100000000010010001000010010111110011100110101000011011110111000111110011100111000000111111000101101111110011100100000110100011110111001111110011100011111110100101011111110011100100101101100111110011101111110111110100000"
print fag==poo
for i in range(0,128):
    try:#ASIS{\01d_4Nd_GoLD_ASIS_1De4_4H4t_g0e5_f0r_ls!}
        #p=process("./b64pack ASIS{"+"\\"+"0"+"1"+chr(i)+"_4Nd_GoLD_ASIS_1De4_4H4t_g0e5_f0r_ls}",shell=True)#01111001111011010011010111
        flag="ASIS{\\01d_4Nd_GoLD_ASIS_1De4_4H4t_g0e5_f0r_ls!}"
        p=process("./b64pack "+flag,shell=True)
        x=p.recvall()
        f=binascii.hexlify(x)
        re=bin(int(f,16))
        re=re[re.index("000000010010001000010"):re.index("111110111110100000")+18]
        print re[54:60],chr(i)
        print poo[54:60],chr(i)
        print re
        if re[54:60]=="110100":
            print chr(i)
            sys.exit()
    except:
        pass
print re==poo
print poo==poo1
print flag
print bin(int(f,16))
#from pwn import *

sys.exit()
rep={}
penis=string.lowercase+string.uppercase+"0123456789{_}"

'''
for i in range(69,256):
    p=process("./b64pack "+chr(i)*12+"SSSS",shell=True)
    f=p.recvall()
    print i
    if "Error" in f:
        print "dd"
    else:
        f=binascii.hexlify(f)
        f=bin(int(f,16))
        print f
        if  f[f.index("010010010010010010010010")-12:f.index("010010010010010010010010")]=="111000000111":
            sys.exit(0)
        #rep[f[f.index("010010010010")-12:f.index("010010010010")]]=penis[i]
'''

for i in range(64):
    p=process("./b64pack "+penis[i]*9+"SS",shell=True)
    f=p.recvall()
    if "Error" in f:
        sys.exit(0)
    else:
        f=binascii.hexlify(f)
        f=bin(int(f,16))
        print f[f.index("010010010010")-18:f.index("010010010010")-12]
        rep[f[f.index("010010010010")-18:f.index("010010010010")-12]]=penis[i]
rep["010010"]="S"
print rep["101011"]
0b1110111100101010111111010011001101111111010010110100011100000011101001001001001001011111010010110010011110010110100011111111011111001101011001000001010
gayy=""
while True:
    #111110011100
    #111110111110100000
    re=poo[:6]

    poo=poo[6:]
    gayy+=rep[re]
    print gayy
    if re=="111110":
        poo=poo[6:]
```