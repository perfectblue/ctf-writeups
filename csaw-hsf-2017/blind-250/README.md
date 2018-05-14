We have a blind sqli on the username field: if the query succeeds, we are logged in. otherwise it fails.
We try various requests to fingerprint the DBMS and we try MySQL, MSSQL, Oracle, but these do not match. It is oddly enough a sqlite.
Do a basic blind sqli.
We do the username as:
`' OR 1=1 AND EXISTS(SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 's%')--`
This lets us enumerate the table names. We know that we should look at what tables there are because the problem text said we should.
Then we see a table 'secret'. OK.
`' OR 1=1 AND EXISTS(SELECT value FROM secret WHERE value LIKE 'flag{%')--`

`flag{blind3d_m3_with_injections}`
