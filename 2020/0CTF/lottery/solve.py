import lmao as lottery
import requests
import json
import os


# accounts = []

# for m in range(100):
    # s = requests.Session()
    # uname, pwd = lottery.register()
    # userinfo = lottery.login(s, uname, pwd)
    # accounts.append({"username":uname, "password": pwd})

# filename = "accounts/accounts{}.json"

# i = 0
# while True:
    # if not os.path.isfile(filename.format(i)):
        # filename = filename.format(i)
        # break
    # i += 1

# with open(filename, "wb") as f:
    # f.write(json.dumps(accounts)) 

#uname = hninpb1
password = "pbctf"

lot_9 = "7+9tdAep3t1qgTYfEZiEWCbowHYs3xuYzgB06FMvv5pBvTKMIU/kqUv+Qy7vSL1cKg3JSNtkAL1hNidp1E4w944gfBIiWcb2YiWpzhLqoHKasTgtweFPTFE+9a6M2fNesPXa+yZ+jcS0xGCXaxFFH/bSt9reYD8AcCI4hIXsxZg="
lot_4 = "n7JAkuB4qkS71yov//W3Zq9nRKzSpi4GS7vz5iBFn+lmflb0e4atBGfBFVA9th3yaSyjtFKeK0fYHFoF/BpEk44gfBIiWcb2YiWpzhLqoHKasTgtweFPTFE+9a6M2fNenZLaZrbOMefmb1YSx5bmrvbSt9reYD8AcCI4hIXsxZg="

with open("accounts.json", "rb") as f:
    accounts = json.load(f)

with open("infos.json", "rb") as f:
    infos = json.load(f)

for m in range(len(accounts)):
    s = requests.Session()
    cur_account = accounts[m]
    username = cur_account['user']['username']
    sice = lottery.login(s, username, password)
    for m in range(3):
        try:
            lot_buy1 = lottery.lottery_buy(s, sice)
            lot_info = lottery.lottery_info(s, lot_buy1)['info']
            lot_info['enc'] = lot_buy1
            print("Info -> {}".format(lot_info))
            infos.append(lot_info)
        except:
            print("Error L")

with open("infos.json", "wb") as f:
    f.write(json.dumps(infos))


