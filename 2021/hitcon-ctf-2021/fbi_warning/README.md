# FBI WARNING

```
Please help FBI to arrest Ωrange!
(Flag format: hitcon{<ip-address-of-Ωrange>})
(Hint: The prefix of the IP address is 219)

http://3.112.91.135/

```

The link goes to an image board with only 1 post (only static HTML left) and it shows this message

```
FBI was hacked Name Ωrange 21/12/03(金)22:14 ID:ueyUrcwA No.2   [返信]

    I have hacked FBI and dump the DB here.
    https://tinyurl.com/fbi-hack
```

The goal is to figure out the IP address of the poster, and this is possible to figure out through the tripcode ("ueyUrcwA").

We find some code snippets of [futaba-ng](https://github.com/futoase/futaba-ng/blob/49eec202a9fbd73273c492c8e685d62b8ec47969/app/dest/futaba.php) online, which shows how the tripcode is generated. It is essentially

```php
ID:".substr(crypt(md5($_SERVER["REMOTE_ADDR"].IDSEED.gmdate("Ymd", $time+9*60*60)),'id'),-8)
```

where IDSEED is some salt, where the default is 

```php
define("IDSEED", 'idの種');
```

Since we know the time it was posted, it is easy to brute force the unknown octets of the IP address.

```php
<?php

define("IDSEED", 'idの種');

$time = 16385372593;
$target = "ueyUrcwA";

foreach(range(0, 256) as $a)
{
    foreach(range(0, 256) as $b)
    {
        foreach(range(0, 256) as $c)
        {
            $addr = "219" . "." . $a . "." . $b . "." . $c;
            //$g = substr(crypt(md5($addr.IDSEED.gmdate("Ymd", $time+9*60*60)),'id'),-8);
            $g = substr(crypt(md5($addr.IDSEED."20211203"),'id'),-8);
            if ($g === $target)
            {
                echo $addr . "\n";
            }
        }
    }
}
?>
```

After a short amount of time, the correct IP pops out

`hitcon{219.91.64.47`