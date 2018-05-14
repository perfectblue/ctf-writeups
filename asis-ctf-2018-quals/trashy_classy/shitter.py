import shutil
import requests
import sys
from subprocess import Popen, PIPE
import os

while True:
#    os.system('rm -rfvd ./fuck/.#flag*')
    proc = Popen('strace -e trace=openat casync mtree flag.caidx', shell=True, bufsize=1, stderr=PIPE, stdout=PIPE)
    try:
        proc.stdout.close()
        for line in proc.stderr:
            if 'default.castr/' in line and 'cacnk' in line and 'ENOENT' in line:
                line = line.split(', ')[1][1:-1].split('/')
                dirname = os.path.join(os.getcwd(), *line[0:2])
                if not os.path.exists(dirname):
                    os.makedirs(dirname)
                    print 'mkdir ' + dirname
                url = 'http://167.99.233.88/private/flag.castr/' + '/'.join(line[1:])
                destfile = os.path.join(os.getcwd(), *line)
                print 'GET ' + url + ' > ' + destfile
                r = requests.get(url, stream=True, auth=requests.auth.HTTPDigestAuth('admin', 'rainbow'))
                with open(destfile, 'wb') as f:
                    shutil.copyfileobj(r.raw, f)
                break
        else:
            break
    finally:
        proc.stderr.close()
        proc.wait()

print 'Everything should be downloaded'
