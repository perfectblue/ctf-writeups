import lmao as lottery
import requests

s1 = "TKWvCtOYA9P2YC8ZVqbnkAH4PYVkKaAy48CsWE1gBXJpS3p86iYxP9BItR1ZRiBDzuSjfANQNham69AbUBOCHRytLnqpHIUnq5FfYmJCPajobAdytolo5uT42QpuItdIFQAm0qAi4eqdVeqlXhtaQ/bSt9reYD8AcCI4hIXsxZg=".decode('base64')
s1 = list(s1)

s2 = "FMQnbnkjXh14+BldPeOJ3nTkCEvAR+o2UWa07EryBeYnwTe/RxqjsxQrL4sY+MIheWVgz3f00jUgpgBcsHcFS72yamXPpbUySJlSTIhP+Ts7xVuDnO8FsN6+lOLbnErfaclxVmDjqlwr9yjUYyPr5/bSt9reYD8AcCI4hIXsxZg=".decode('base64')
s2 = list(s2)

s = requests.Session()

for m in range(0, len(s1), 16):
    print("For m -> {}, {}".format(m, lottery.lottery_info(s,"".join(s1).encode('base64').replace("\n", ""))))
    temp = s1[m:m+16]
    s1[m:m+16] = s2[m:m+16]

    cur = "".join(s1).encode("base64").replace("\n", "")
    print "Changed -> {}".format(lottery.lottery_info(s, cur))
    s1[m:m+16] = temp

