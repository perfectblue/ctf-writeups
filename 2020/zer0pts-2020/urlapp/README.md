### urlapp

- Flag is stored in the redis db under the key `flag`
- Can `GET` arbitrary keys from the redis db following the regex `/^[0-9a-f]{16}$/`  (16 hex chars)
- CRLF Injection in `set` bypassing the URI regex, can inject arbitrary redis commands.
- Rename flag key to an hex key and also replace `{` and `}` as they fuck up the redirect 

Final payload: ```http://lol/%0d%0aSETRANGE flag 7 F%0d%0aSETRANGE flag 35 F%0d%0aRENAME flag aaaaaaaaaaaaaaaa%0d%0a```
