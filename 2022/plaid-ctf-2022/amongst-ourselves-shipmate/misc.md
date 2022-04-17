# Amongst Ourselves: Shipmate - Upload Data (Misc)

We extraced data by capturing packets while handling `FileTransferSystem.ts`.

After extracting the full data, we could see a lot of HTTP requests/responses with `Range:`:
```
GET /sus.png HTTP/1.1..Host: internal.storage.shelld..User-Agent: curl/7.74.0..Accept: */*..Range: bytes=219325-223420
...
```

We extracted the `sus.png` from the data, and found this:
![](sus.png)
(We could not extract the last chunk of the file, so it may not be displayed well)

The flag is `PCTF{[BOTTOM TEXT]}`.