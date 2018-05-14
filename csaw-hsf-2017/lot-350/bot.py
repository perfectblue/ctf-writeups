#!/usr/bin/env python3

# flag{w0w_uR_pr3tty_luckY}
# flag{w0w_uR_pr3tty_luckY}
# flag{w0w_uR_pr3tty_luckY}
# flag{w0w_uR_pr3tty_luckY}

from socketIO_client import SocketIO
import sys,json,time,_thread,random
from timeseed import guess_t

def debug_on():
	import logging
	logging.getLogger('requests').setLevel(logging.WARNING)
	logging.basicConfig(level=logging.DEBUG)

#sessionid='431495fc-a126-4126-a79a-376c5159cb47' # clean2
sessionid='431495fc-a126-4126-a79a-376c5159cb47' # clean3

COLLECT_DATA_LEN=10
socketIO = None
connected = True
prevScore = -1
t_send = -1
num_updates = 0
t_last_upd = 0
server_rng = None
rng_need_fixup=True

diffs = []

def guess_thread(diffs_to_crack):
	global server_rng,rng_need_fixup

	guessed = guess_t(t_send, 25.84/1000,diffs_to_crack)
	if not guessed:
		print('GUESS FAILED')
		sys.exit(1)
	print('guessed:%f'%(guessed,))
	print(diffs_to_crack)
	server_rng = random.Random(guessed)
	rng_need_fixup=True

def on_update_response(*args):
	global prevScore,t_last_upd,num_updates,diffs,rng_need_fixup
	if not args:
		print('Empty response')
		global connected
		connected = False
		return
	data = args[0]
	score = data['score']
	print('%d    | %f s'%(score,time.time()-t_last_upd), end=' ')

	if prevScore != -1:
		dScore = score - prevScore
		if (t_last_upd != 0 and time.time() - t_last_upd >= 1.0) or dScore:
			t_last_upd = time.time()
			diffs.append(dScore)
			num_updates += 1
			print('+%d %d/%d'%(dScore,num_updates,COLLECT_DATA_LEN), end=' ')

			if num_updates == COLLECT_DATA_LEN:
				print("STARTING CRACK THREAD")
				_thread.start_new_thread(guess_thread, (list(diffs),))

			if server_rng and dScore < 100: # we cracked seed :)! , check dSCore<100 avoid lottery upd
				if rng_need_fixup: # need to match the rng back to server due to missed times
					print("\nRNG FIXUP:")
					for i in range(0,num_updates-1):
						print(server_rng.randint(0,100),end=' ')
					print()
					rng_need_fixup = False

				predicted = server_rng.randint(0,100) # keep predicted rng LOCKSTEP with server
				print('predict:%d'%(predicted,))

				# do lottery guess here because more time between random updates
				lottery_guess=server_rng.randint(0,1000)
				print('LOTTERY GUESS:%d'%(lottery_guess,),end='')
				socketIO.emit('lottery', str(lottery_guess),callback=lottery_cb)

	print()

	prevScore = score

#	print data

def lottery_cb(*args):
	print('\nLOTTERY RESP:',end=' ')
	print(args)

def bot_update_loop():
	while connected:
		socketIO.emit('update', callback=on_update_response)
		socketIO.wait_for_callbacks(seconds=1)
		time.sleep(0.1)

def connect(sessionid):
	global connected
	global socketIO, t_send
	t_send = time.time()
	with SocketIO('misc.hsf.csaw.io', 8001, cookies={'session': sessionid}) as s:
		socketIO = s
		connected = True
		_thread.start_new_thread(bot_update_loop, ())
		try:
			while connected:
				time.sleep(1)
		except KeyboardInterrupt:
			connected = False
			return False
	return True

connect(sessionid)
