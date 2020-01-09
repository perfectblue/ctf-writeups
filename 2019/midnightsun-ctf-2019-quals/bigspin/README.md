# Bigspin

**Category**: Web

424 Points

26 Solves

**Problem description**:
This app got hacked due to admin and uberadmin directories being open. Was just about to wget -r it, but then they fixed it :( Can you help me get the files again? 

---

We are provided with a link to a site. Opening it, it shows a simple HTML page with the following text.

```
What's it gonna be? Are you an uberadmin, an admin, a user, or (most likely) just a pleb? 
```

The `uberadmin`, `admin`, `user` and `pleb` are hyperlinks to their respective directories. The `uberadmin` and `user` directories returned 403 forbidden while `admin` returned 404. The `pleb` directory returned the same page example.com domain

Appending anything after the `pleb` directory (like `/pleb/whatever`) also returned the same page, acting just like example.com, weird huh?

After some more recon, I noticed changing `/pleb` to `/pleb.` worked the same way as before, `/pleb~` returned a 404 while `/pleb{anythingElse}` retuslted in a 502.

The `pleb` and `pleb.` are working just like domain TLDs, any time we visit `example.com`, we are actually sending a DNS request to `example.com.` because a fully qualified domain needs to have a trailing dot at the end. That's why visiting `example.com` and `example.com.` produce the same result.

To confirm my supicions, I set up a wildcard DNS listener at dnsbin.zhack.ca and sent a request to `/pleb.mysub.dnsbin.zhack.ca` and sure enough, I received a DNS query for example.com. 

So the pattern here is that the server is actually forwarding our request from `/pleb{anything}` to `example.com{anyhing}`.

In the exploitation process, I used nip.io to provide extensively awesome wildcard DNS service. Sending a request to `/pleb.127.0.0.1.nip.io` returned the localhost, which was the same index page as before. But this time, I could visit the `user` directory.

```
Index of /user/

../
nginx.cÃ¶nf                                        05-Apr-2019 11:51                1253
```
Well, looks like there a file which seems like nginx.conf but with a couple of UTF-8 characters.

For some reason, I wasn't able to download it, so I set up a listener on my VPS and realized that the `/pleb` proxy wasn't forwarding non-ASCII chars. 

It basically stopped at the occurance of the first non-ASCII char, but percents (%) were allowed. Since nginx would urldecode whatever we send before forwarding them, what if double URL encode (encode %ff as %25ff, so when nginx decodes, it becomes %ff and gets forwaded). This trick worked and I was able to download the nginx.conf.

```
    server {
        listen 80;

        location / {
            root /var/www/html/public;
            try_files $uri $uri/index.html $uri/ =404;
        }

        location /user {
            allow 127.0.0.1;
            deny all;
            autoindex on;
            root /var/www/html/;
        }

        location /admin {
            internal;
            autoindex on;
            alias /var/www/html/admin/;
        }

        location /uberadmin {
            allow 0.13.3.7;
            deny all;
            autoindex on;
            alias /var/www/html/uberadmin/;
        }

        location ~ /pleb([/a-zA-Z0-9.:%]+) {
            proxy_pass   http://example.com$1;
        }

        access_log /dev/stdout;
        error_log /dev/stdout;
    }

}
```

So it's using proxypass to forward our requests. The `/admin` directory is internal only whereas the `/uberadmin` will only shown if our IP is 0.13.3.7. 

The internal directive here means that only the requests sent internally (rewritten by nginx) will be allowed to access that. But there are no rewrite rules in this config...

After some googling, I came across the [X-Accel-Redirect](https://kovyrin.net/2006/11/01/nginx-x-accel-redirect-php-rails/) which apparently if returned by the backend server/proxy_pass will allow us to access the internaal directive because it acts as a rewrite rule.

So I set up a quick php script with the following

```
<?php header("X-Accel-Redirect: /admin/"); ?>
```

This showed me the contents of /admin/ when I visited `/pleb.my.ip.nip.io`. There was a flag.txt in there but it was fakenews and just directed us towards `/useradmin`..

So how do we access `/uberadmin`? If you are current on your security news, you must've heard about the [Off-by-Slash](https://i.blackhat.com/us-18/Wed-August-8/us-18-Orange-Tsai-Breaking-Parser-Logic-Take-Your-Path-Normalization-Off-And-Pop-0days-Out-2.pdf) bug in many nginx configurations.
```
        location /admin {
            internal;
            autoindex on;
            alias /var/www/html/admin/;
        }
```

Basically if we're using the alias directive with a location directive, nginx would directly concat them them together. In this case, a request to `/admin../uberadmin/` would actually open the uberadmin directory.

This was my final payload

```
<?php header("X-Accel-Redirect: /admin../uberadmin/flag.txt"); ?>
```

Overall, this was an awesome challenge and I loved every part of it

