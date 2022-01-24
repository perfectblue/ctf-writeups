from braindead import *
from binascii import b2a_base64
log.enable()

args = Args(strict=True)
args.add('JAVA')
args.add('JAR')
args.parse()

r = io.connect(('139.224.248.65', 1337))
with open(args.JAVA, 'rb') as f:
    r.sla('Content:', b2a_base64(f.read(), newline=False))
with open(args.JAR, 'rb') as f:
    r.sla('Content:', b2a_base64(f.read(), newline=False))
io.interactive(r)
