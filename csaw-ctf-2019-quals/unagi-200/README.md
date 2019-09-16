#unagi - 200

- Typical XXE in the upload, WAF blocks "Entity"
- Use UTF-16 to bypass (`iconv -f UTF-8 -t UTF-16BE`)
- Typical OOB Exfiltration

