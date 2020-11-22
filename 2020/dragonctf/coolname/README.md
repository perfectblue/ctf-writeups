XSS in DNS CNAME record. You setup a DNS server to put XSS in CNAME records which is reflected to the admin. Then you can DNS exfil from the admin. Other exfil is not allowed because only 53/udp outbound is permitted.

Also apparently the admin bot did not accept double quotes in the payload but you just had to guess that... lol

Solved as team effort
