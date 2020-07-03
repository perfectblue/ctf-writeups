import lmao as lottery
import requests
import json
import os


with open("infos.json", "rb") as f:
    infos = json.load(f)


uname = "hninpb1"
password = "pbctf"

lot_9 = "7+9tdAep3t1qgTYfEZiEWCbowHYs3xuYzgB06FMvv5pBvTKMIU/kqUv+Qy7vSL1cKg3JSNtkAL1hNidp1E4w944gfBIiWcb2YiWpzhLqoHKasTgtweFPTFE+9a6M2fNesPXa+yZ+jcS0xGCXaxFFH/bSt9reYD8AcCI4hIXsxZg="
lot_9 = list(lot_9.decode('base64'))

s = requests.Session()
lottery.login(s, uname, password)

for each in infos:
    if each['coin'] != 9:
        continue
    sice = each['enc']
    cur_sice = list(sice.decode('base64'))
    cur_sice[64:64+64] = lot_9[64:64+64]
    joined_enc = "".join(cur_sice).encode('base64').replace("\n", "")
    print(joined_enc)
    s.post("http://pwnable.org:2333/lottery/charge", data={'user':'69497136-af8e-4ac1-a259-2899e527108a', 'coin':'9', 'enc':joined_enc})

