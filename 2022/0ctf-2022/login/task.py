#!/usr/bin/env sage

import signal
import socketserver
import string
from base64 import b64encode
from hashlib import sha256
from os import urandom
from sage.all import *
from sage.crypto.lwe import RingLWE, UniformPolynomialSampler
from sage.stats.distributions.discrete_gaussian_polynomial import DiscreteGaussianDistributionPolynomialSampler
#from secret import flag
flag = 'FLAG{askdjnalskdnalksdn}'
import random

MENU = '''
Welcome to 0CTF's backend system. This is the beta version, so there may be some bugs...
1. Player Login
2. Admin Login
3. Exit
'''

BITS = 64
N = 2048

def s2v(s):
    return list(map(int, bin(int.from_bytes(s, 'big'))[2:].ljust(N, '0')))

def serialize(v):
    s = b''
    for _ in v:
        s += int(_).to_bytes(BITS // 8, 'big')
    return b64encode(s).decode('latin-1')

class CryptoSuite:    
    
    def __init__(self, n, bits):
        Q = random_prime(2**bits - 1, False, 2**(bits - 1))
        Zqx = Zmod(Q)['a']
        a = Zqx.gens()[0]
        self.Rq = Zqx.quotient(1 + a**n, 'x')
        self.M = int(ceil(Q / (2 * n + 1)))
        self.N = n
        self.D = [
            UniformPolynomialSampler(ZZ['x'], n=n, lower_bound=0, upper_bound=Q-1),
            DiscreteGaussianDistributionPolynomialSampler(ZZ['x'], n=n, sigma=35),
            DiscreteGaussianDistributionPolynomialSampler(ZZ['x'], n=n, sigma=59473923),
            DiscreteGaussianDistributionPolynomialSampler(ZZ['x'], n=n, sigma=118947842),
        ]
        
    def sample(self, i):
        return self.Rq(self.D[i]())

    def encode(self, i): # binary to NRZ poly
        return self.Rq([_ if _ == 1 else -1 for _ in i])

    def Setup(self):
        alpha = self.sample(0) # Q
        self.msk = self.sample(1) # g35
        pk = alpha * self.msk + self.sample(1)
        self.mpk = (alpha, pk)

    def KeyGen(self, y, msk=None):
        if not msk:
            msk = self.msk
        y_ = self.encode(y)
        return (y_, y_ * msk)

    def Enc(self, x, mpk=None):
        if not mpk:
            mpk = self.mpk
        alpha, pk = mpk
        r = self.sample(2)
        f0 = self.sample(2)
        ct0 = alpha * r + f0
        f1 = self.sample(3)
        ct1 = pk * r + f1 + self.Rq(self.M) * self.encode(x)
        return (ct0, ct1)

    def Dec(self, sk, ct):
        return ct[1] * sk[0] - ct[0] * sk[1]

    def extract(self, pt):
        return self.N == round(int(pt[0]) / self.M)

class System:
    
    def __init__(self):
        self.C = CryptoSuite(N, BITS)
        self.C.Setup()
        self.USERS = {}

    def Register(self, passwd, name):
        self.USERS[name] = [self.C.Enc(passwd), self.C.KeyGen(passwd)]
        return True

    def Player_Login(self, passwd):
        # To save the traffic, let's do encryption for you.
        ct = self.C.Enc(passwd)
        pt = self.C.Dec(self.USERS['0ctf-player'][1], ct)
        if self.C.extract(pt):
            return True, 'Welcome, 0ctf player!'
        else:
            return False, 'Login failed, invalid data ' + serialize(pt)

    def Admin_Login(self):
        # Since you are logged in as player, it's not allowed to input another password.
        pt = self.C.Dec(self.USERS['0ctf-admin'][1], self.USERS['0ctf-player'][0])
        if self.C.extract(pt):
            return True, flag
        else:
            return False, 'Login failed, invalid data ' + serialize(pt)

    def Reset(self, passwd, name):
        self.USERS[name] = [self.C.Enc(passwd), self.C.KeyGen(passwd)]
        return True

class Task(socketserver.BaseRequestHandler):
    def __init__(self, *args, **kargs):
        super().__init__(*args, **kargs)

    def proof_of_work(self):
        random.seed(urandom(8))
        proof = ''.join([random.choice(string.ascii_letters + string.digits + '!#$%&*-?') for _ in range(20)])
        digest = sha256(proof.encode()).hexdigest()
        self.dosend('sha256(XXXX + {}) == {}'.format(proof[4: ], digest))
        self.dosend('Give me XXXX:')
        x = self.request.recv(10)
        x = (x.strip()).decode('utf-8') 
        if len(x) != 4 or sha256((x + proof[4: ]).encode()).hexdigest() != digest: 
            return False
        return True

    def dosend(self, msg):
        try:
            self.request.sendall(msg.encode('latin-1') + b'\n')
        except:
            pass

    def timeout_handler(self, signum, frame):
        raise TimeoutError

    def recv_fromhex(self, l):
        passwd = self.request.recv(l).strip()
        passwd = bytes.fromhex(passwd.decode('latin-1'))
        return passwd       

    def handle(self):
        try:
            signal.signal(signal.SIGALRM, self.timeout_handler)
            signal.alarm(50)
            if not self.proof_of_work():
                self.dosend('You must pass the PoW!')
                return
            signal.alarm(15)

            Sys = System()
            for name in ['0ctf-admin', '0ctf-player']:
                y = urandom(N // 8)
                with open(name, 'w') as f:
                    print(*s2v(y), sep='', file=f)
                Sys.Register(s2v(y), name)
            
            LOGIN = False
            FAILED = 0

            self.dosend(MENU)
            while FAILED < 3:
                self.dosend('> ')
                op = int(self.request.recv(3).strip())
                if op == 1:
                    self.dosend('Password: ')
                    passwd = self.recv_fromhex(N // 4 + 2) # actually N//8 bytes
                    passwd += urandom(N // 8 - len(passwd))
                    _, msg = Sys.Player_Login(s2v(passwd))
                    self.dosend(msg)
                    if _:
                        LOGIN = True
                    else:
                        FAILED += 1
                elif op == 2:
                    if not LOGIN:
                        self.dosend('You should login as 0ctf player at first.')
                        FAILED += 1
                    else:
                        _, msg = Sys.Admin_Login()
                        self.dosend(msg)
                        if not _:
                            FAILED += 1
                elif op == 3:
                    return
                if FAILED == 2:
                    self.dosend('Reset your password?')
                    if self.request.recv(3).strip() == b'Y':  
                        self.dosend('Password: ')
                        passwd = self.recv_fromhex(N // 4 + 2)
                        passwd += urandom(N // 8 - len(passwd)) # optional pad
                        Sys.Reset(s2v(passwd), '0ctf-player')
                        self.dosend('Reset done!')

        except TimeoutError:
            self.dosend('Timeout!')
            self.request.close()
        except:
            self.dosend('Wtf?')
            self.request.close()

class ThreadedServer(socketserver.ForkingMixIn, socketserver.TCPServer):
    pass

if __name__ == "__main__":
    HOST, PORT = '0.0.0.0', 13337
    server = ThreadedServer((HOST, PORT), Task)
    server.allow_reuse_address = True
    server.serve_forever()
