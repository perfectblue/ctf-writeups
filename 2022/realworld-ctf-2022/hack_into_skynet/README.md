# Hack into Skynet

Category: Web

Solves: 81

Points: 73

Main solvers: myrdyr, ammaraskar, sampriti, L3o

---

## Challenge Description

>Hack into skynet to save the world, which way do you prefer?
>
>Note: Skynet is a blackbox detection engine which is not provided. But you don't have to guess.
>
>Note2: Scanner or sqlmap NOT REQUIRED to solve this challenge, please do not use scanners.

## Write-up

We are given `server.py`, which is running a Flask web server.

There is a potential vulnerable service in `query_kill_time`, but we have to login first.

```python
def query_login_attempt():
    username = flask.request.form.get('username', '')
    password = flask.request.form.get('password', '')
    if not username and not password:
        return False

    sql = ("SELECT id, account"
           "  FROM target_credentials"
           "  WHERE password = '{}'").format(hashlib.md5(password.encode()).hexdigest())
    user = sql_exec(sql)
    name = user[0][1] if user and user[0] and user[0][1] else ''
    return name == username
```

When we provide an empty string as username with arbitrary password, we can make `name == username` to true, and login successfully.

The second part is SQL Injection. However, there is a WAF `Skynet` filtering our requests.

```python
def query_kill_time():
    name = flask.request.form.get('name', '')
    if not name:
        return None

    sql = ("SELECT name, born"
           "  FROM target"
           "  WHERE age > 0"
           "    AND name = '{}'").format(name)
    nb = sql_exec(sql)
    if not nb:
        return None
    return '{}: {}'.format(*nb[0])
```

We encode our payload into `multipart/form-data`, and get SQLi executed.

We can simply use `union` to fetch data.

The rest is to find the flag in database `target_credentials` column `secret_key`, which is `rwctf{t0-h4ck-$kynet-0r-f1ask_that-Is-th3-questi0n}`.