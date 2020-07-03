import requests
import string
import random

def rand_str():
    return ''.join(random.choice(string.digits) for _ in range(10))

def register():
    uname = rand_str()
    pwd = rand_str()
    requests.post("http://pwnable.org:2333/user/register", data={'username':uname, 'password':pwd})
    return uname, pwd

def login(s, uname, pwd):
    return s.post("http://pwnable.org:2333/user/login", data={"username":uname, "password":pwd}).json()['user']

def lottery_buy(s, uinfo):
    return s.post("http://pwnable.org:2333/lottery/buy", data={"api_token":uinfo["api_token"]}).json()['enc']

def lottery_info(s, enc):
    return s.post("http://pwnable.org:2333/lottery/info", data={'enc': enc}).json()

if __name__ == '__main__':
    uname, pwd = register()
    s = requests.Session()

    print("Username -> {}\nPassword -> {}".format(uname, pwd))

    user_deets = login(s, uname, pwd)

    for m in range(3):
        lottery = lottery_buy(s, user_deets)
        print("Bought -> {}".format(lottery))
        print(lottery_info(s, lottery))








