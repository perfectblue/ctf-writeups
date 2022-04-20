# Amongst Ourselves: Shipmate - Provide Credentials

Category: Web

Solves: 60

Points: 70

---

## Challenge Description

>Green starts teleporting wildly around The Shelld before suddenly disappearing. Meanwhile, Brown inspects the access logs on the ship's computer to piece together a timeline of the murders.


## Write-up

The flag is in the database.

In `packages/game-server/src/systems/ProvideCredentialsSystem.ts`, there are some filters to prevent SQL Injection.

```ts
// No sql injection
username = username.replace("'", "''");
password = password.replace("'", "''");

// Max length of username and password is 32
username = username.substring(0, 32);
password = password.substring(0, 32);

pool.query<{ id: number; username: string }>(
    `SELECT id, username FROM users WHERE username = '${username}' AND password = '${password}'`
)
    .then((result) => {
        ...
        if (result.rows[0].id !== this.credentials.id) {
            throw new Error("Invalid credentials");
        }
```

The server is using PostgreSQL.

First, it replaces a single quote with two single quotes. We can give it two single quotes, and it will only replace the first one. The consecutive three single quotes will be treated as a single quote, and the previous part till the single quote is the content of the string.

Then, we can use `union select 1,*from flag--` to fetch the flag.
The '1' in the payload is not always 1. We should give the corresponding id for the user since it checks the id with `result.rows[0].id !== this.credentials.id`.

So the final payload is `''union select 1,*from flag--`.
The flag is `PCTF{BAD_READ.TOO_LONG.TRY_AGAIN}`.