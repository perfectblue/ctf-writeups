from pwn import *
#63-94
import sys
#f="^_^ONE_BYTE_INSTRUCTION_FLAG_IZ_CLASSY_AND_FUN_B"
f="L"
cmp="AAAAaaaaCAAA q31EAAAFAAAGAAAHAAATu31baaacaaadaaaeaaafaaagaaahaaabaaaaaaaCAAA q31EAAAFAAAGAAAHAAAXu31caaadaaaeaaafaaagaaahaaabaaacaaaCAAA q31EAAAFAAAGAAAHAAA\\u31daaaeaaafaaagaaahaaaaaaacaaaCAAA q31EAAAFAAAGAAAHAAA\\u31daaaeaaafaaagaaahaaaaaaabaaaCAAA q31EAAAFAAAGAAAHAAA\\u31daaaeaaafaaagaaahaaaaaaabaaaDAAA q31EAAAFAAAGAAAHAAA\\u31daaaeaaafaaagaaahaaadaaabaaaDAAA q31EAAAFAAAGAAAHAAA`u31eaaafaaagaaahaaadaaabaaaDAAA q31EAAAGAAAGAAAHAAA`u31eaaafaaagaaahaaadaaabaaaDAAA q31EAAAGAAAeaaaHAAAdu31faaagaaahaaadaaabaaaDAAA q31EAAAGAAAeaaaHAAA`u31du31faaagaaahaaadaaabaaaEAAA q31EAAAGAAAeaaaHAAA`u31du31faaagaaahaaadu31baaaEAAA q31EAAAGAAAeaaaHAAAdu31faaagaaahaaadu31baaaEAAA q31EAAAGAAAdaaaHAAAdu31faaagaaahaaadu31aaaaEAAA q31EAAAGAAAdaaaHAAAdu31faaagaaahaaadu31aaaaEAAA q31EAAAGAAAdaaaHAAA`u31EAAAfaaagaaahaaadu31aaaaEAAA q31EAAAGAAAdaaaHAAA\\u31`u31EAAAfaaagaaahaaadu31aaaaEAAA q31EAAAGAAAdaaaHAAAXu31GAAA`u31EAAAfaaagaaahaaadu31aaaaEAAA q31EAAAGAAAdaaaHAAATu31EAAAGAAA`u31EAAAfaaagaaahaaadu31aaaaEAAA q31FAAAGAAAdaaaHAAATu31EAAAGAAA`u31EAAAfaaagaaahaaadu31aaaaEAAA q31FAAAGAAAdaaaHAAAPu31Tu31EAAAGAAA`u31EAAAfaaagaaahaaadu31aaaaEAAA q31FAAAGAAAcaaaHAAAPu31Tu31EAAAGAAA`u31EAAAfaaagaaahaaacu31aaaaEAAA q31FAAAGAAAcaaaHAAAPu31Tu31EAAAGAAA`u31EAAAfaaagaaahaaacu31`aaaEAAA q31FAAAGAAAcaaaHAAAPu31Tu31EAAAGAAA`u31EAAAfaaagaaahaaaTu31`aaaEAAA q31FAAAGAAAcaaaHAAATu31EAAAGAAA`u31EAAAfaaagaaahaaaTu31aaaaEAAA q31FAAAGAAAcaaaHAAATu31EAAAGAAA`u31EAAAfaaagaaahaaaTu31aaaaEAAA q31FAAAGAAAcaaaHAAASu311EAAAGAAA`u31EAAAfaaagaaahaaaTu31aaaaEAAA q31FAAAGAAAdaaaHAAASu311EAAAGAAA`u31EAAAfaaagaaahaaaUu31aaaaEAAA q31FAAAGAAAdaaaHAAASu311EAAAGAAA`u31EAAAfaaagaaahaaa1EAAaaaaEAAA q31FAAAGAAAdaaaHAAAWu31AGAAA`u31EAAAfaaagaaahaaa1EAAaaaaEAAA q31FAAAGAAAcaaaHAAAWu31AGAAA`u31EAAAfaaagaaahaaa1EAAaaaaEAAA q31FAAAAGAAcaaaHAAA[u31A`u31EAAAfaaagaaahaaaA`u3aaaaEAAA q31FAAAAGAAcaaaHAAA_u311EAAAfaaagaaahaaaA`u3aaaaEAAA q31GAAAAGAAcaaaHAAA_u311EAAAfaaagaaahaaaA`u3aaaaEAAA q31GAAAAGAAcaaaHAAA^u3131EAAAfaaagaaahaaaA`u3aaaaEAAA q31GAAAAGAAdaaaHAAA^u3131EAAAfaaagaaahaaaA`u3aaaaEAAA q31GAAAAGAAdaaaHAAAZu31GAAA31EAAAfaaagaaahaaaA`u3aaaaEAAA q31GAAAAGAAdaaaHAAAVu31GAAAGAAA31EAAAfaaagaaahaaaA`u3aaaaEAAA q31GAAAAGAAGAAAHAAAZu31GAAA31EAAAfaaagaaahaaaGAAAaaaaEAAA q31GAAAAGAAGAAAHAAA^u3131EAAAfaaagaaahaaaGAAAaaaaEAAA q31GAAAAGAAHAAAHAAA^u3131EAAAfaaagaaahaaaGAAA`aaaEAAA q31GAAAAGAAHAAAHAAA^u3131EAAAfaaagaaahaaaGAAA`aaaEAAA q31GAAAAGAAHAAAHAAA_u311EAAAfaaagaaahaaa1EAA`aaaEAAA q31GAAAAGAAHAAAHAAAcu31Afaaagaaahaaa1EAAaaaaEAAA q31GAAAAGAAHAAAHAAAcu31Afaaagaaahaaa1EAAaaaaEAAA q31GAAAAGAAHAAAHAAA_u31EAAAAfaaagaaahaaa1EAA`aaaEAAA q31GAAAAGAAHAAAHAAA_u31EAAAAfaaagaaahaaaEAAA`aaaEAAA q31GAAAAGAAHAAAHAAAcu31AfaaagaaahaaaEAAA`aaaEAAA q31GAAABGAAHAAAHAAAcu31AfaaagaaahaaaEAAA`aaaAfaa q31GAAABGAAHAAAHAAAgu31agaaahaaa"
count=2
for awefae in range(1):
	for i in range(64,96):
		p=process("gdb -q dd",shell=True)
		p.recvuntil("peda$")
		p.sendline("set print elements 0")
		p.recvuntil("peda$")
		p.sendline("break *0x8048942")
		p.recvuntil("peda$")
		p.sendline("r")

		p.sendline(f+chr(i))
		p.recvuntil("peda$")
		p.sendline("x/700xw 0x31338000")
		m1=""
		for j in range(5*count):
			p.recvuntil(":")
			m1+=p.recvline()

		#print m1
		#p.interactive()
		p.recvuntil("peda$")
		p.sendline("x/700xw 0x3133a000")
		m2=""
		for j in range(5*count):
			p.recvuntil(":")
			m2+=p.recvline()
		#p.interactive()
		p.recvuntil("peda$")
		print m1
		print chr(i)
		print m2
		if m1==m2:
			print m1,m2
			print chr(i), count, i
			f+=chr(i)
			count+=1
			print f
			sys.exit(0)
		p.close()

p.interactive()