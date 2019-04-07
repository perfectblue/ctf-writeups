# Marcoolio

**Category**: Web

725 Points

12 Solves

**Problem description**:
Third time's the charm. This time I got a security lib too. 

---

This was apparently one of the least solved challenges, but our solution was such a meme.

Same as the other Marco challenges, we have to XSS a page and submit a URL which pops alert(1) to get the flag. Here is the relevant source code:

```javascript
input = decodeURIComponent(location.search.match(/input=([^&#]+)/)[1]);
var converter = new showdown.Converter({tables: true});

window.onload=function(){
  $("#markdown").val(input);
  html = converter.makeHtml(input);
  clean = DOMPurify.sanitize(html);
  md = converter.makeMarkdown(clean);
  if(md.replace(/[\s\\]/g,"") === input.replace(/[\s\\]/g,"")){
    $("#render").html(html);
  }else{
      $("#render").html("<font id='error' color=red></font>");
      $("#error").text("hacking attempt!!!");
  }
}

function rerender(){
  try{
    input = $("#markdown").val();
    html = converter.makeHtml(input);
    clean = DOMPurify.sanitize(html);
    md = converter.makeMarkdown(clean);
    if(md.replace(/[\s\\]/g,"") === input.replace(/[\s\\]/g,"")){
      $("#render").html(html);
    }else{
      $("#render").html("<font id='error' color=red></font>");
      $("#error").text("hacking attempt!!!");
    }
  }catch(x){
    $("#render").html("<font id='error' color=red></font>");
    $("#error").text(x);
  }
}
```

So it's using some markdown library to convert out markdown into HTML, then running DOMPurify on it and doing some validation after it. As we know, DOMPurify is really good and they're using the latest version, so I don't think they want us to 0day it.

Looking at DOMPurify's [github](https://github.com/cure53/DOMPurify), we came across this statement in the README.md:

```
The resulting HTML can be written into a DOM element using innerHTML or the DOM using document.write(). That is fully up to you. But keep in mind, if you use the sanitized HTML with jQuery's very insecure elm.html() method, then the SAFE_FOR_JQUERY flag has to be set to make sure it's safe! Other than that, all is fine.
```

The script snippet is actually using JQuery's html() method to add our HTML and isn't using the SAFE_FOR_JQUERY flag, so we might be able to get an XSS even with DOMPurify.

So where do we start constructing our payload? I started looking at the unit tests for the `SAFE_FOR_JQUERY` flag and [here](https://github.com/cure53/DOMPurify/blob/2724763e41313b1a54724dfda5573e8b63116962/test/test-suite.js#L53) they test a bunch of payloads which would otherwise cause XSS in DOMPurify if used with JQuery's html() method.

As a base, we tried copying a couple of the payloads from there and BEHOLD, the 3rd one popped an alert()... WTF? was that it?

This is what I used

```
http://marcoolio-01.play.midnightsunctf.se:3003/markdown?input=<option><style></option></select><b><img src=xx: onerror=alert(1)></style></option>
```

Sumitting it actually gave me the flag? I'm sure the organizers did not intend this, but whatever gets you the flag eh?

