# Marcodowno

**Category**: Web

105 Points

158 Solves

**Problem description**:
Someone told me to use a lib, but real developers rock regex one-liners.

---

So it's XSS challenge and we basically have to XSS a page and send them a URL popping alert(1) to get the flag

Here is the source of the webpage. It's apparently a "Markdown" converter which uses regex

```html
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="/static/style.css" />
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
</head>

<script>
input = decodeURIComponent(location.search.match(/input=([^&#]+)/)[1]);

function markdown(text){
  text = text.replace(/[<]/g, '').replace(/----/g,'<hr>').replace(/> ?([^\n]+)/g, '<blockquote>$1</blockquote>').replace(/\*\*([^*]+)\*\*/g, '<b>$1</b>').replace(/__([^_]+)__/g, '<b>$1</b>').replace(/\*([^\s][^*]+)\*/g, '<i>$1</i>').replace(/\* ([^*]+)/g, '<li>$1</li>').replace(/##### ([^#\n]+)/g, '<h5>$1</h5>').replace(/#### ([^#\n]+)/g, '<h4>$1</h4>').replace(/### ([^#\n]+)/g, '<h3>$1</h3>').replace(/## ([^#\n]+)/g, '<h2>$1</h2>').replace(/# ([^#\n]+)/g, '<h1>$1</h1>').replace(/(?<!\()(https?:\/\/[a-zA-Z0-9./?#-]+)/g, '<a href="$1">$1</a>').replace(/!\[([^\]]+)\]\((https?:\/\/[a-zA-Z0-9./?#]+)\)/g, '<img src="$2" alt="$1"/>').replace(/(?<!!)\[([^\]]+)\]\((https?:\/\/[a-zA-Z0-9./?#-]+)\)/g, '<a href="$2">$1</a>').replace(/`([^`]+)`/g, '<code>$1</code>').replace(/```([^`]+)```/g, '<code>$1</code>').replace(/\n/g, "<br>");
  return text;
}

window.onload=function(){
  $("#markdown").text(input);
  $("#rendered").html(markdown(input));
}

</script>

<h1>Input:</h1><br>
<pre contenteditable id="markdown" class="background-grey"></pre><br>
<br>
<button onclick='$("#rendered").html(markdown($("#markdown").text()))'>Update preview</button>
<hr>
<br>
<h1>Preview:</h1><br>
<div id="rendered" class="rendered background-grey"></div>
```

In the first replace, it removes all the open (<) HTML tags. How do we XSS without open tags? 

The replace that caught my eye was

```
replace(/!\[([^\]]+)\]\((https?:\/\/[a-zA-Z0-9./?#]+)\)/g, '<img src="$2" alt="$1"/>')
```
It woulb be used to transform the image tags in Markdown such as `![img1](http://url)` into `<img src="http://url" alt="img1">`. The URL is decently sanitized but alt is not. We can inject a double quote and break out of the alt tag, inject a event handler which would then pop up an XSS. 

Here was the final URL

```
http://marcodowno-01.play.midnightsunctf.se:3001/markdown?input=![" onerror="alert(1)"](http://x)
```
