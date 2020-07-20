import base64
import itertools
import sys

run = int(input())

if run == 1:
    for i in range(1000):
        corr = True
        try:
            x = base64.b64decode("{}/".format(str(i).zfill(3))).decode('utf-8')
        except UnicodeDecodeError:
            corr = False
        if corr: print(str(i).zfill(3)+"/")

if run == 2:
    for i in range(10000):
        corr = True
        try:
            x = base64.b64decode("{}".format(str(i).zfill(4))).decode('utf-8')
        except UnicodeDecodeError:
            corr = False
        if corr: print(str(i).zfill(4))

if run == 3:
    for x in itertools.product(list('0123456789e+'), repeat=4):
        if x.count('e') != 1:
            continue
        t = ''.join(x)
        corr = True
        try:
            y = base64.b64decode(t).decode('utf-8')
        except UnicodeDecodeError:
            corr = False
        if corr: print(t)

if run == 4:
    for x in itertools.product(list('0123456789+e/'), repeat=4):
        if '+' not in x:
            continue
        t = ''.join(x)
        corr = True
        try:
            y = base64.b64decode(t).decode('utf-8')
        except UnicodeDecodeError:
            corr = False
        if corr: print(t)

if run == 5:
    for x in itertools.product(list('0123456789/e+'), repeat=4):
        t = ''.join(x)
        if '/' not in t or '+/' in t or t.count('e') > 1:
            continue
        corr = True
        try:
            y = base64.b64decode(t).decode('utf-8')
        except UnicodeDecodeError:
            corr = False
        if corr: print(t)

if run == 6:
    for x in itertools.product(list('0123456789/e+o'), repeat=4):
        t = ''.join(x)
        if not (t.startswith('0o') or t.startswith('+0o') or t.startswith('/0o')) or t.count('o') > 1:
            continue
        corr = True
        try:
            y = base64.b64decode(t).decode('utf-8')
        except UnicodeDecodeError:
            corr = False
        if corr: print(t)

if run == 7:
    for x in itertools.product(list('01/+b'), repeat=4):
        t = ''.join(x)
        if not (t.startswith('0b') or t.startswith('+0b') or t.startswith('/0b')) or t.count('b') > 1:
            continue
        corr = True
        try:
            y = base64.b64decode(t).decode('utf-8')
        except UnicodeDecodeError:
            corr = False
        if corr: print(t)
