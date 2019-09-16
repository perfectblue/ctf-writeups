import socketserver
import random
import signal
import time
import gmpy2
from Crypto.Util.number import inverse, bytes_to_long, long_to_bytes

FLAG = open('flag', 'r').read().strip()


def s2n(s):
    return bytes_to_long(bytearray(s, 'latin-1'))


def n2s(n):
    return long_to_bytes(n).decode('latin-1')


def gen_prime():
    base = random.getrandbits(1024)
    off = 0
    while True:
        if gmpy2.is_prime(base + off):
            break
        off += 1
    p = base + off

    return p, off


class RSA(object):
    def __init__(self):
        pass

    def generate(self, p, q, e=0x10001):
        self.p = p
        self.q = q
        self.N = p * q
        self.e = e
        phi = (p-1) * (q-1)
        self.d = inverse(e, phi)

    def encrypt(self, p):
        return pow(p, self.e, self.N)

    def decrypt(self, c):
        return pow(c, self.d, self.N)

    # ===== FUNCTIONS FOR PERSONAL TESTS, DON'T USE THEM =====
    def TEST_CRT_encrypt(self, p, fun=0):
        ep = inverse(self.d, self.p-1)
        eq = inverse(self.d, self.q-1)
        qinv = inverse(self.q, self.p)
        c1 = pow(p, ep, self.p)
        c2 = pow(p, eq, self.q) ^ fun
        h = (qinv * (c1 - c2)) % self.p
        c = c2 + h*self.q
        return c

    def TEST_CRT_decrypt(self, c, fun=0):
        dp = inverse(self.e, self.p-1)
        dq = inverse(self.e, self.q-1)
        qinv = inverse(self.q, self.p)
        m1 = pow(c, dp, self.p)
        m2 = pow(c, dq, self.q) ^ fun
        h = (qinv * (m1 - m2)) % self.p
        m = m2 + h*self.q
        return m


def go(req):
    r = RSA()
    p, x = gen_prime()
    q, y = gen_prime()

    r.generate(p, q)
    fake_flag = 'fake_flag{%s}' % (('%X' % y).rjust(32, '0'))

    def enc_flag():
        req.sendall(b'%X\n' % r.encrypt(s2n(FLAG)))

    def enc_fake_flag():
        req.sendall(b'%X\n' % r.encrypt(s2n(fake_flag)))

    def enc_fake_flag_TEST():
        req.sendall(b'%X\n' % r.TEST_CRT_encrypt(s2n(fake_flag), x))

    def enc_msg():
        req.sendall(b'input the data:')
        p = str(req.recv(4096).strip(), 'utf-8')
        req.sendall(b'%X\n' % r.encrypt(s2n(p)))

    menu = {
        '1': enc_flag,
        '2': enc_fake_flag,
        '3': enc_fake_flag_TEST,
        '4': enc_msg,
    }

    cnt = 2
    while cnt > 0:
        req.sendall(bytes(
            '====================================\n'
            '            fault box\n'
            '====================================\n'
            '1. print encrypted flag\n'
            '2. print encrypted fake flag\n'
            '3. print encrypted fake flag (TEST)\n'
            '4. encrypt\n'
            '====================================\n', 'utf-8'))

        choice = str(req.recv(2).strip(), 'utf-8')
        if choice not in menu:
            exit(1)

        menu[choice]()

        if choice == '4':
            continue

        cnt -= 1


class incoming(socketserver.BaseRequestHandler):
    def handle(self):
        signal.alarm(300)
        random.seed(time.time())

        req = self.request
        while True:
            go(req)


class ReusableTCPServer(socketserver.ForkingMixIn, socketserver.TCPServer):
    pass


socketserver.TCPServer.allow_reuse_address = True
server = ReusableTCPServer(("0.0.0.0", 23333), incoming)
server.serve_forever()
