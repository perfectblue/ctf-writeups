from braindead import *
log.enable()
import subprocess

args = Args()
args.parse()

r = io.connect(('35.200.15.81', 30003))

r.ru('hashcash ')
hc_args = r.ru('`')[:-1].decode()
info("hashcash params: %s", hc_args)
out = subprocess.check_output(['hashcash', *hc_args.split()]).decode().split()[-1]
info("hashcash answer: %s", out)
r.sl(out)

r.rla('EOF word is `TSGCTF')
with open("./sploit.py") as f:
	for l in f:
		if not l.startswith('#'):
			r.sl(l[:-1])
r.send(b'\nTSGCTF\n')

io.interactive(r)

