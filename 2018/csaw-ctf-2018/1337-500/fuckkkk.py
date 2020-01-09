table = [
11, 	"[gnjxn+ne\x7Fny+\x7Fcn+{jxx|dyo1+",
12, 	"j`mkw)\x7Fq",
13, 	"(~(~(~(~(~(~(~(~(~(~",
14, 	"Zk|cg`ozk^|amk}}",
15, 	"@z{\x7Fz{Kjmzh\\{}fahN",
16, 	"WudSebbu~d@b\x7FsuccYt",
17, 	"^at\x7FAc~rtbb",
18, 	"[aVwpguuw`B`waw|f",
22, 	"[seewqsTynW",
23, 	"@e~crGextrddZrzxen",
24, 	"[j}yl}Lpj}y|",
25, 	"Ju||i",
26, 	"Ioij\x7Ft~Nrh\x7F{~",
27, 	"Lzro]tiHru|w~Tyq~xo",
28, 	"YduhLns\x7Fyoo",
29, 	"IrHst~ryxXe",
31, 	"jlzm,-1{ss",
]
i=32
shit = open('StringTable3.bin','rb').read()
while shit:
	table.append(i)
	length = ord(shit[0])
	unichode =shit[2:2+length*2]
	damn=''
	for cunt,c in enumerate(unichode):
		if cunt & 1 == 0:
			if unichode[cunt+1] != '\x00':
				damn += chr(ord(unichode[cunt+1])^ord(c))
			else:
				damn += c
	table.append(damn)
	shit = shit[2+length*2:]
	i+=1
# print table
def xor(s1,key):
	r=''
	for a in map(ord,s1):
		r+=chr(a^key)
	return r
fuckers = []
for i in range(0,len(table),2):
	asshat=xor(table[i+1],table[i]).encode('hex')
	# asshat=list(xor(table[i+1],0))
	# for i,c in enumerate(asshat):
	# 	if c=='-':
	# 		asshat[i]='\x00'
	# print asshat
	if asshat:
		fuckers.append(''.join(asshat))
# print fuckers
for dipshit in fuckers[-4:]:
	for i in range(0, 24, 8):
		ohFuck=dipshit[i:i+8][::-1]
		ohFuck = ohFuck.encode('hex')
		print 'printf("%%llx\\n", stupidlog(0x%s));' % (ohFuck,)


