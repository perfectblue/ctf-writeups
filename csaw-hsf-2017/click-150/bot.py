#!/usr/bin/env python

from socketIO_client import SocketIO
import sys,json,time,thread,random

def debug_on():
	import logging
	logging.getLogger('requests').setLevel(logging.WARNING)
	logging.basicConfig(level=logging.DEBUG)

sessionid='431495fc-a126-4126-a79a-376c5159cb47'

socketIO = None
best_clicker = 'BaseClick'
connected = True

def clicker_worth(clicker):
	return clicker['value'] * clicker['mult']

def get_best_clicker(data):
	clickers = data['clickers']
	return max(clickers, key=lambda name: clicker_worth(clickers[name]))

def choose_upgrade(data):
	score = data['score'] * 0.66 # get thrifty
	def get_best_upgrade(unlocks, price_key):
		try:
		        eligible_unlocks = filter(lambda name: unlocks[name][price_key] < score, unlocks)
		except KeyError:
			return None
	        if eligible_unlocks:
        	        return max(eligible_unlocks, key=lambda name: unlocks[name]['value'])
	        return None

	best_unlock = get_best_upgrade(data['unlockables'], 'price')
	if best_unlock:
		return {'name':best_unlock,'type':'value'}
	best_upgrade_m = get_best_upgrade(data['upgrades'], 'm-price')
	if best_upgrade_m:
		return {'name':best_upgrade_m,'type':'mult'}
	best_upgrade = get_best_upgrade(data['upgrades'], 'v-price')
	if best_upgrade:
		return {'name':best_upgrade,'type':'value'}
	return None

def on_update_response(*args):
	if not args:
		print 'Empty response'
		global connected
		connected = False
		return
	data = args[0]
	print data['score']

	upgrade = choose_upgrade(data)
	if upgrade:
		socketIO.emit('upgrade', upgrade)
		print 'Upgrading ' + str(upgrade)

	if data['frenzy_avail']:
		socketIO.emit('frenzy')
		print 'Frenzy'

	global best_clicker
	best_clicker = get_best_clicker(data)
	print best_clicker

#	print data

def on_achievements_response(*args):
	print args

def bot_update_loop():
	while connected:
		socketIO.emit('update', callback=on_update_response)
		socketIO.wait_for_callbacks(seconds=1)
		time.sleep(1)

def bot_click_loop():
	while connected:
		socketIO.emit('click', best_clicker)
		time.sleep(0.1 * random.random())

def bot_achievements_loop():
	while connected:
		socketIO.emit('achievements', callback=on_achievements_response)
		socketIO.wait_for_callbacks(seconds=10)
		time.sleep(60)

def connect(sessionid):
	global connected
	global socketIO
	with SocketIO('misc.hsf.csaw.io', 8001, cookies={'session': sessionid}) as s:
		socketIO = s
		connected = True
		thread.start_new_thread(bot_update_loop, ())
		thread.start_new_thread(bot_click_loop, ())
		thread.start_new_thread(bot_achievements_loop, ())
		try:
			while connected:
				time.sleep(1)
		except KeyboardInterrupt:
			connected = False
			return False
	return True

while connect(sessionid):
	time.sleep(1)

