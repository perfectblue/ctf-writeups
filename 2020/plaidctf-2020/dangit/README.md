# Dangit

Tl;dr, exposed web .git. We use dvcs-ripper, but oh no, we still have got nothing useful. From the challenge description, however:

> While many fine clients exist, only two deserve to be called *porcelains*

We google this phrase, we find git client called [Magit](https://github.com/brotzeit/magit). And apparently it [stores some extra refs](https://magit.vc/manual/magit/Wip-Modes.html) (?!?!)

- http://dangit.pwni.ng/.git/refs/wip/wtree/refs/heads/master
- http://dangit.pwni.ng/.git/refs/wip/index/refs/heads/master

Anyways, using these, NOW you are finally able to find the rest of the blobs you're missing and solve the challenge.

```
$ git cat-file -p 8b1559acf1b94bf02937723212a3a7417d2631c4
PCTF{looks_like_you_found_out_about_the_wip_ref_which_magit_in_emacs_uses}
```
