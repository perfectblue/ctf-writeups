# dep

Here we exploit the weirdly (badly) implemented alpha equivalences so to make
bottom. See the [rules.pdf](2021/plaidctf-2021/dep/) for the obligatory typing
judgements for this language :)


```
Prop = #0
create = (z : Prop) -> (x : z) -> (p: Prop) -> x
cast = (victim : (p : Prop) => (x : p) => (z : Prop) => z) -> victim
easy_t = (phi : Prop) => (_ : (_ : (_ : phi) => (p : Prop) => p) => (p : Prop) => p) => phi
bottom = (cast create #255 #254)

(flag1 (bottom easy_t))
(flag2 bottom)
```
