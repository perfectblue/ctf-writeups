import requests
import os
import time

def solve_file(name):
    data = open(name, "rb").read()
    digits = []
    for x in "0123456789":
        digits.append(open("{}.mp3".format(x), "rb").read())
        assert len(digits[-1]) == 13259
    ans = ""
    for i in range(6):
        for j in range(10):
            if digits[j] == data[13259*i:13259*(i+1)]:
                ans += str(j)
                break
    print(ans)
    return ans

resp = requests.get("http://sound-captcha.sstf.site/", cookies={"PHPSESSID": "77840039ca440f9d28e4f690f1c38f77"})
for i in range(100):
    url = "http://sound-captcha.sstf.site" + resp.text.split('value')[1].split('"')[1][1:]
    os.system("rm -f sice.mp3")
    os.system("wget -O sice.mp3 '{}'".format(url))
    ans = solve_file("sice.mp3")
    resp = requests.post("http://sound-captcha.sstf.site/", cookies={"PHPSESSID": "77840039ca440f9d28e4f690f1c38f77"}, data={"captcha_val": ans})
    print resp.text
