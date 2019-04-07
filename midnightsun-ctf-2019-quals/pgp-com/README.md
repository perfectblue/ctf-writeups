# Pgp-com

**Category**: Crypto, misc

451 Points

24 Solves

**Problem description**: You know how PGP works, right?

---

After extracting all the PGP files and viewing the messages (we could view messages 1 and 3, we decided to extract the RSA keys to see if there was some sort of attack on them. Unfortunately, we could not find any, and got stuck for a while. Later, we decided to look up the pgp specification itself, and found this image:
![stuff](https://cdn.discordapp.com/attachments/563875097505693700/563974111475269644/unknown.png)

We realized that we could maybe attack the session key itself, and bypass the RSA encryption part. The rest of our solve in this challenge can be summed up in these two screenshots:

![stuff](https://cdn.discordapp.com/attachments/563875097505693700/563974741539422228/unknown.png)

![stuff2](https://cdn.discordapp.com/attachments/563875097505693700/563974808962859009/unknown.png)

Flag: `midnight{sequential_session_is_bad_session}`