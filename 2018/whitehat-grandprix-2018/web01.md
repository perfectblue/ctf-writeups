# web01

This was a quite easy challenge. We're basically given a simple [Web server](web01/server.py) written in Python which only handles GET requests and POST requests with files.

I basically had a intuition that the vulnerabilty would be a directory traversal either in the GET path handling or the POST filename.

I added a bunch of debug prints to the file for the GET path and POST filename and it confirmed my suspicion, there was a directory traversal in POST filename. The following request wrote a file 'lol.txt' in the root directory with the content "hacked"

```
POST / HTTP/1.1
Host: web01.grandprix.whitehatvn.com
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-GB,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://web01.grandprix.whitehatvn.com/
Content-Type: multipart/form-data; boundary=---------------------------13214009622098986519196351465
Content-Length: 630
Cookie: XXX
Connection: close
Upgrade-Insecure-Requests: 1

-----------------------------13214009622098986519196351465
Content-Disposition: form-data; name="file"; filename="../lol.txt"
Content-Type: application/octet-stream

HACKED

-----------------------------13214009622098986519196351465--
```

Oh so what file can we overwrite? The challenge description was the following (disguised to give us a hint)

```
manhndd is running a service file upload at web01.grandprix.whitehatvn.com, it is restored every 2 minutes. Every 1 minute after service starts, he ssh into server to check /var/secret. Can you get it?
```

So it confirms that there is a user named `manhndd` and he SSH-es in every minute. We can't overwrite anything `/home/manhndd/.ssh/` as we don't have the appropriate permission or we could have just added our own public key there.

But instead we can overwrite `.bashrc` and when the user `manhndd` SSH-es in, it will execute our command in `.bashrc`

The real thing was that we had to race against other players since everyone will be trying to overwrite `.bashrc` with their payload and we need to win that race.

Another thing I figured out was that there is no `nc` or any way to exfil the flag, so we can just read the flag from `/var/secret` and write it to `/opt/mydank` (`/opt` is the web facing directory)

To win the race, I opened the request in Burp's repeater and just spammed `Go` and wrote a python script to read from `/mydank`. Soon enough, I won the race and got the flag.

![](web01/burp.png)

```
